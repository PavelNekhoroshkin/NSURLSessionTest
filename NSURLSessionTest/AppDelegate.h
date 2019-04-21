//
//  AppDelegate.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
@import UserNotifications;


@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UNUserNotificationCenter *center;


@end

