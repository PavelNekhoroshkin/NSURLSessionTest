//
//  ViewController.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadController.h"
#import "NotificationGenerator.h"


@class DownloadController;

@interface ViewController : UIViewController
@property (nonatomic, strong) DataStore *dataStore;
@property (nonatomic, strong) NSObject<UISearchBarDelegate> *searchBarDelegate;
@property (nonatomic, strong) DownloadController *downloadController;
@property (nonatomic, strong) NotificationGenerator *notificationGenerator;

- (void) reloadCollectionView;
- (void) showErrorAlert;
//- (void) storeFile:(NSData *)imageData idPicture:(NSString *)idPicture notification:(int)notification;
//- (void) removeFileWithIdPicture:(NSString *)idPicture notification:(int)notification;
- (void) setSearchBarStringForCats;
- (void) searchFromNotificationWithString:(NSString *)searchString;

@end

