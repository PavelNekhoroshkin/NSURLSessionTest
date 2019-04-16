//
//  PictureViewController.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 15.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@class ViewController;
NS_ASSUME_NONNULL_BEGIN

@interface PictureViewController : UIViewController
@property (nonatomic, weak) ViewController *controller;
@property (nonatomic, weak) DataStore  *dataStore;
@property (nonatomic, strong) NSData  *pictureData;
@property (nonatomic, weak) NSString *idPicture;
- (void) showProgress:(double)progress;
- (void) showPicture;

@end

NS_ASSUME_NONNULL_END
