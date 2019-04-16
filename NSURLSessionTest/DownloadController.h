//
//  SessionDounloadDelegate.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStore.h"
#import "ViewController.h"
#import "SessionController.h"
#import "PictureViewController.h"


@class ViewController;
@class SessionController;
@class PictureViewController;
NS_ASSUME_NONNULL_BEGIN

@interface DownloadController : NSObject<NSURLSessionDelegate,NSURLSessionDownloadDelegate>
@property (nonatomic, weak) DataStore *dataStore;
@property (nonatomic, weak) ViewController *controller;
@property (nonatomic, weak) PictureViewController *pictureViewController;
@property (nonatomic, strong) SessionController *sessionController;

- (void) sendSearchRequest:(NSString *)searchText;
- (void) proceedSearchResult:(NSData *)data error:(NSError * _Nullable)error;
- (void) proceedPictureParamsDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture;
- (void) proceedPictureWithURLDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture;
- (void) downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture;
- (void) proceedMaxPictureWithURLDownload:(NSData *)data error:(NSError * _Nullable)error idPicture:(NSString *)idPicture;


@end

NS_ASSUME_NONNULL_END
