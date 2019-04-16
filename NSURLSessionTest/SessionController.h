//
//  SessionController.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 14.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStore.h"
#import "ViewController.h"
#import "DownloadController.h"


@class ViewController;
@class DownloadController;
NS_ASSUME_NONNULL_BEGIN

@interface SessionController : NSObject

@property (nonatomic, weak) DownloadController *downloadController;
- (void) downloadSearchResult:(NSString*)searchString;
- (void) downloadPictureParams:(NSString *)idPicture;
- (void) dowloadPictureWithURL:(NSString *)pictureURL idPicture:(NSString *)idPicture;
- (void) downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture;

@end

NS_ASSUME_NONNULL_END

