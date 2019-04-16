//
//  SessionController.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 14.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "SessionController.h"

NSString *const kAPIKey = @"5553e0626e5d3a905df9a76df1383d98";

@interface SessionController()
@property (nonatomic,strong) NSURLSession *session;

@end

@implementation SessionController



- (void) createSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self.downloadController delegateQueue:nil];
    self.session = session;
}


- (void) downloadSearchResult:(NSString*)searchString
{
    NSString *urlString = [self urlStringForSearch:searchString];
    
    NSMutableURLRequest *request = [self createRequestWithURL:urlString];

    if(!self.session)
    {
        [self createSession];
    }
    
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //вызов из последовательной очереди делегата сессии (один поток)
        [self.downloadController proceedSearchResult:data error:error];
    }];
    [sessionDataTask resume];
    
}


- (void) downloadPictureParams:(NSString *)idPicture
{
    NSString *urlString = [self urlStringForGettingPicture:idPicture];
    
    NSMutableURLRequest *request = [self createRequestWithURL:urlString];

    
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //вызов из последовательной очереди делегата сессии (один поток)
        [self.downloadController proceedPictureParamsDownload:data error:error idPicture:idPicture];
        
        
    }];
    
    NSLog(@"idPicture:%@ --- sessionDataTask:%@", idPicture, sessionDataTask);
    
    [sessionDataTask resume];
    
}



//из разных потоков сессионной очереди

- (void) dowloadPictureWithURL:(NSString *)pictureURL idPicture:(NSString *)idPicture
{
    NSMutableURLRequest *request = [self createRequestWithURL:pictureURL];
    
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [self.downloadController proceedPictureWithURLDownload:data error:error idPicture:idPicture];
        
    }];
    //    [sessionDataTask setAccessibilityLabel:idPicture];
    [sessionDataTask resume];
    
}


- (void) downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture
{
    NSMutableURLRequest *request = [self createRequestWithURL:maxPictureURL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self.downloadController delegateQueue:nil];
    
    
//    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        [self.downloadController proceedMaxPictureWithURLDownload:data error:error idPicture:idPicture];
//
//    }];
    
    NSURLSessionDownloadTask *sessionDataTask = [session downloadTaskWithRequest:request];
    [sessionDataTask setAccessibilityLabel:idPicture];
    [sessionDataTask resume];
    
}



- (NSMutableURLRequest *)createRequestWithURL:(NSString *)urlString
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    return request;
}


-(NSString *)urlStringForSearch:(NSString *)searchString
{
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=25&format=json&nojsoncallback=1", kAPIKey, searchString];
}

-(NSString *)urlStringForGettingPicture:(NSString *)photoId
{
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", kAPIKey, photoId];
}





@end
