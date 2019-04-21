//
//  AppDelegate.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SearchBarDelegate.h"
#import "DownloadController.h"
#import "DataStore.h"
#import "NotificationGenerator.h"

@import UserNotifications;

@interface AppDelegate ()
@property (nonatomic, strong) DataStore *dataStore;
@property (nonatomic, strong) ViewController *controller;
@property (nonatomic, strong) NotificationGenerator *notificationGenerator;
@property (nonatomic, strong) SearchBarDelegate  *searchBarDelegate;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] init];
    ViewController *controller = [[ViewController alloc] init];
    window.rootViewController = controller;
    self.controller = controller;
    
    //Подготовить и связать все объекты
    [self prepareObjectsWithController:controller];
    
    self.window = window;
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Уедомления, отправлненные для foreground не должны быть показаны в фоне
    //поэтому при выходе удалим все уведомления с приглашением найти котов
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
#pragma GCC diagnostic pop
    
    //создать уведомление для bacground при выходе из приложения
    //Приглашение повторить поиск
    [self createNotification:self.dataStore.searchText];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



/**
 Подготавливает и связывает все объекты

 @param controller рут-контроллер (ViewController)
 */
- (void) prepareObjectsWithController:(ViewController *)controller
{
    DataStore *dataStore =[[DataStore alloc] init];
    self.dataStore = dataStore;
    controller.dataStore = dataStore;
    
    SearchBarDelegate *searchBarDelegate = [[SearchBarDelegate alloc] init];
    
    DownloadController *downloadController = [[DownloadController alloc] init];
    
    SessionController *sessionController = [[SessionController alloc] init];
    
    controller.searchBarDelegate = searchBarDelegate;
    controller.downloadController = downloadController;
    
    downloadController.controller = controller;
    downloadController.dataStore = dataStore;
    downloadController.sessionController = sessionController;
    
    
    sessionController.downloadController = downloadController;
    
    searchBarDelegate.downloadController = downloadController;
    searchBarDelegate.dataStore = dataStore;
    self.searchBarDelegate = searchBarDelegate;

    NotificationGenerator *notificationGenerator = [[NotificationGenerator alloc]init];
    notificationGenerator.dataStore = dataStore;
    self.notificationGenerator = notificationGenerator;
    
    searchBarDelegate.notificationGenerator = notificationGenerator;
    controller.notificationGenerator = notificationGenerator;
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(!granted){
            NSLog(@"No permitions for use notifications");
        }
    }];
    
    center.delegate = self;
}

/**
 Генерирует уведомления, отображаемые через 3 секунды после выхода из приложения,
 если был выполнен поиск, то в передает в уведомление последнюю строку поиска,
 если был просмотр рисунка, то передает последний просмотренный рисунок

 @param searchText последняя строка поиска
 */
- (void) createNotification:(NSString *)searchText
{
    [self.notificationGenerator createOnExitNotificationWithSearchText:searchText];
}



#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    UNNotificationContent *content = notification.request.content;
    if([content.categoryIdentifier isEqualToString:@"SecondNotification"])
    {
        //Заставляет второе уведомление (на поиск кошек) отобразиться даже если приложение активно
        completionHandler(UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionBadge);
    }
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    
    
    if([response.actionIdentifier isEqualToString:@"RepeatSearchAction"])
    {
        UNNotificationContent *content = response.notification.request.content;
        [self.controller searchFromNotificationWithString:[content.userInfo objectForKey:@"searchText"]];
    }
    

    if([response.actionIdentifier isEqualToString:@"CatSearchAction"])
    {
        [self.controller setSearchBarStringForCats];
        [self.controller searchFromNotificationWithString:@"Cat"];
    }
}

@end
