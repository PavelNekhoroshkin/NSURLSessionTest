//
//  SessionDounloadDelegate.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "DownloadController.h"


@interface DownloadController()

@end

@implementation DownloadController

- (void) sendSearchRequest:(NSString *)searchText
{
//    [self.controller performSelectorOnMainThread:@selector(showErrorAlert) withObject:nil waitUntilDone:NO];

    [self.sessionController downloadSearchResult:searchText];

}



//из последовательной очереди делегата сессии (один поток)
- (void) proceedSearchResult:(NSData *)data error:(NSError * _Nullable)error
{

    if (!data)
    {
        [self.controller performSelectorOnMainThread:@selector(showErrorAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    NSDictionary *parcedSearchResult = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"%@", parcedSearchResult);
    
    
    NSArray *photoParamsArray = [[parcedSearchResult objectForKey:@"photos"] objectForKey:@"photo"];
    
    self.dataStore.pictureIds = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *photoParamsDictonary = [[NSMutableDictionary alloc] init];
    int i = 0;
    for (id pictureData in photoParamsArray) {
        
        NSString *idPicture = [pictureData objectForKey:@"id"];
        [photoParamsDictonary setObject:pictureData forKey:idPicture];
        //контроллер сесси запускает запросы в отдельном потоке, отличном от
        [self.sessionController downloadPictureParams:idPicture];

        
        i++;
        if (i>9){
//            break;
        }
    }
    self.dataStore.photoParams = photoParamsDictonary;
}


//из последовательной очереди делегата сессии (один поток)
- (void) proceedPictureParamsDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture
{
    if (!data)
    {
//        [self.controller performSelectorOnMainThread:@selector(showErrorAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSDictionary *pictureParams = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *size = [[pictureParams objectForKey:@"sizes"] objectForKey:@"size"];
    NSString *pictureURLmin = [[size objectAtIndex:0] objectForKey:@"source"];
    NSString *pictureURLmax;
    for(int i = 0; i < [size count] ; i++ ){
        if ( [[[size objectAtIndex:i] objectForKey:@"height"] integerValue] >= 600){
            pictureURLmax = [[size objectAtIndex:i] objectForKey:@"source"];
            break;
        }
        
    }
    
    if (!pictureURLmax) {
        pictureURLmax = [[size objectAtIndex:([size count] - 1)] objectForKey:@"source"];
    }
    
    [self.dataStore.pictureURLs setObject:@{@"min":pictureURLmin, @"max":pictureURLmax} forKey:idPicture];
    
    NSLog(@"%@",pictureURLmin);

    [self.sessionController dowloadPictureWithURL:pictureURLmin idPicture:idPicture];
}



//из последовательной очереди делегата сессии (один поток)
- (void) proceedPictureWithURLDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture
{
    if (!data)
    {
        //        [self.controller performSelectorOnMainThread:@selector(showErrorAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self.dataStore.minPhotoNSData setValue:data forKey:idPicture];
    [self.dataStore.pictureIds addObject:idPicture];
    
    [self.controller performSelectorOnMainThread:@selector(reloadCollectionView) withObject:nil waitUntilDone:NO ];
    
}

- (void) downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture
{
    [self.dataStore.maxPhotoStartDownload setObject:@"Startged download" forKey:idPicture];
    [self.sessionController downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture];
    
}

- (void) proceedMaxPictureWithURLDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture
{
    if (!data)
    {
        [self.controller performSelectorOnMainThread:@selector(showErrorAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self.dataStore.maxPhotoNSData setValue:data forKey:idPicture];
    [self.dataStore.pictureIds addObject:idPicture];
    
//    [self.controller performSelectorOnMainThread:@selector(reloadCollectionView) withObject:nil waitUntilDone:NO ];
    
}

#pragma mark - NSURLSessionDownloadDelegate


/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */

//сессия запускает метод в той очереди, которая указана в настройках сессии, только если не указан блок completionHendler
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
    
    NSData *pictureData = [NSData dataWithContentsOfURL:location];
    if(pictureData){
        [self.dataStore.maxPhotoStartDownload setObject:@"Download complete" forKey:downloadTask.accessibilityLabel];
    }
    else
    {
        [self.dataStore.maxPhotoStartDownload removeObjectForKey:downloadTask.accessibilityLabel];

    }
    [self.dataStore.maxPhotoNSData setValue:pictureData forKey:downloadTask.accessibilityLabel];
    NSLog(@"100%");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pictureViewController showPicture];
    });

}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
//    NSLog(@"%f - %@",progress, downloadTask  );
//    NSLog(@"%f%",progress * 100);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pictureViewController showProgress:(double)progress];
    });

}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{

    
}


@end
