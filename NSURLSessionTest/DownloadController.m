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
    self.dataStore.searchText = searchText;
    [self.sessionController downloadSearchResult:searchText];

}


/**
 Обрабатывает результат первого запроса

 @param data JSON со списком рисунков
 @param error информация об ошибках
 */
- (void) proceedSearchResult:(NSData *)data error:(NSError * _Nullable)error
{
    if (!data)
    {
        [self.controller performSelectorOnMainThread:@selector(showErrorAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    NSDictionary *parcedSearchResult = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSArray *photoParamsArray = [[parcedSearchResult objectForKey:@"photos"] objectForKey:@"photo"];
    
    self.dataStore.pictureIds = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *photoParamsDictonary = [[NSMutableDictionary alloc] init];
    for (id pictureData in photoParamsArray)
    {
        NSString *idPicture = [pictureData objectForKey:@"id"];
        [photoParamsDictonary setObject:pictureData forKey:idPicture];
        //контроллер сесси запускает запросы в отдельном потоке, отличном от
        [self.sessionController downloadPictureParams:idPicture];
    }
    self.dataStore.photoParams = photoParamsDictonary;
}


/**
 Обработка результата запроса по доступным размерам картинки и ее названием

 @param data JSON со списком размеров рисунка
 @param error информация об ошибках
 @param idPicture идентификатор рисунка
 */
- (void) proceedPictureParamsDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture
{
    if (!data)
    {
        return;
    }
    
    NSDictionary *pictureParams = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *size = [[pictureParams objectForKey:@"sizes"] objectForKey:@"size"];
    NSString *pictureURLmin = [[size objectAtIndex:0] objectForKey:@"source"];
    NSString *pictureURLmax;
    for(int i = 0; i < [size count] ; i++ ){
        if ( [[[size objectAtIndex:i] objectForKey:@"height"] integerValue] >= 150){
            pictureURLmax = [[size objectAtIndex:i] objectForKey:@"source"];
            break;
        }
        
    }
    
    if (!pictureURLmax) {
        pictureURLmax = [[size objectAtIndex:([size count] - 1)] objectForKey:@"source"];
    }
    
    [self.dataStore.pictureURLs setObject:@{@"min":pictureURLmin, @"max":pictureURLmax} forKey:idPicture];
    
    [self.sessionController dowloadPictureWithURL:pictureURLmin idPicture:idPicture];
}


/**
 Запрос на загрузку рисунка


 @param maxPictureURL URL рисунка выбранного размера
 @param idPicture идентификатор рисунка
 */
- (void) downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture
{
    [self.dataStore.maxPhotoStartDownload setObject:@"Startged download" forKey:idPicture];
    [self.sessionController downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture];
}

/**
 Загрузка рисунка

 @param data данные рисунка
 @param error информация об ошибках
 @param idPicture идентификатор рисунка
 */
- (void) proceedPictureWithURLDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture
{
    if (!data)
    {
        return;
    }
    
    [self.dataStore.minPhotoNSData setValue:data forKey:idPicture];
    [self.dataStore.pictureIds addObject:idPicture];
    
    [self.controller performSelectorOnMainThread:@selector(reloadCollectionView) withObject:nil waitUntilDone:NO ];
    
}




/**
 Обработка результата загрузки большой картинки для фильтра

 @param data полученные данные большой картинки
 @param error ошибка, если была, полученая при загрузке
 @param idPicture идентификатор рисунка
 */
- (void) proceedMaxPictureWithURLDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture
{
    if (!data)
    {
        [self.controller performSelectorOnMainThread:@selector(showErrorAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self.dataStore.maxPhotoNSData setValue:data forKey:idPicture];
    [self.dataStore.pictureIds addObject:idPicture];
}






#pragma mark - NSURLSessionDownloadDelegate


/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
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
    NSLog(@"100%%");
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pictureViewController showProgress:(double)progress];
    });

}

@end
