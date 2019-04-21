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


/**
 Получить результат поиска и передать его на обработку

 @param searchString строка поиска
 */
- (void) downloadSearchResult:(NSString*)searchString
{
    NSString *urlString = [self urlStringForSearch:searchString];
    
    NSMutableURLRequest *request = [self createRequestWithURL:urlString];

    if(!self.session)
    {
        [self createSession];
    }
    
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {[self.downloadController proceedSearchResult:data error:error];}];
    
    [sessionDataTask resume];
    
}


/**
 Получить достуные размеры, URL и название рисунка по идентификатору

 @param idPicture идкнтификатор рисунка
 */
- (void) downloadPictureParams:(NSString *)idPicture
{
    NSString *urlString = [self urlStringForGettingPicture:idPicture];
    
    NSMutableURLRequest *request = [self createRequestWithURL:urlString];

    
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {[self.downloadController proceedPictureParamsDownload:data error:error idPicture:idPicture];}];
    
    [sessionDataTask resume];
    
}



/**
 Получить данные мини-рисунка (75х75) для отображения в UICollectionView

 @param pictureURL URL
 @param idPicture идентификатор рисунка (для сохранения данных рисунка в словарь)
 */
- (void) dowloadPictureWithURL:(NSString *)pictureURL idPicture:(NSString *)idPicture
{
    NSMutableURLRequest *request = [self createRequestWithURL:pictureURL];
    
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {[self.downloadController proceedPictureWithURLDownload:data error:error idPicture:idPicture];}];

    [sessionDataTask resume];
    
}


/**
 Загрузить данные рисунка выбранного размера (150х150)

 @param maxPictureURL URL
 @param idPicture идентификатор рисунка (для сохранения данных рисунка в словарь)
 */
- (void) downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture
{
    NSMutableURLRequest *request = [self createRequestWithURL:maxPictureURL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self.downloadController delegateQueue:nil];
    
    NSURLSessionDownloadTask *sessionDataTask = [session downloadTaskWithRequest:request];
    [sessionDataTask setAccessibilityLabel:idPicture];
    
    [sessionDataTask resume];
    
}



/**
 Вспомогательный метод для формирования запроса

 @param urlString URL
 @return объект запроса для отправки в сессию
 */
- (NSMutableURLRequest *)createRequestWithURL:(NSString *)urlString
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    return request;
}


/**
 Подготовка URL для поиска

 @param searchString строка поиска
 @return URL для поиска
 */
-(NSString *)urlStringForSearch:(NSString *)searchString
{
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=25&format=json&nojsoncallback=1", kAPIKey, searchString];
}

/**
 Подготовка URL для получения данных о доступных размерах, названии и списке URL на разные размеры рисунка

 @param idPicture идентификатор рисунка
 @return URL для получения дынных о доступных размерах рисунка
 */
-(NSString *)urlStringForGettingPicture:(NSString *)idPicture
{
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", kAPIKey, idPicture];
}

@end
