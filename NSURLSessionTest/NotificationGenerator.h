//
//  NotificationGenerator.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 20.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationGenerator : NSObject
@property (nonatomic, weak) DataStore *dataStore;

- (void) createOnExitNotificationWithSearchText:(NSString *)searchText;
- (void) createCatSearchNotificationWithSearchText:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
