//
//  SearchBarDelegate.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "DownloadController.h"
#import "NotificationGenerator.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchBarDelegate : NSObject   <UISearchBarDelegate>
@property (nonatomic, weak) DownloadController *downloadController;
@property (nonatomic, weak) DataStore *dataStore;
@property (nonatomic, weak) NotificationGenerator *notificationGenerator;

@end

NS_ASSUME_NONNULL_END
