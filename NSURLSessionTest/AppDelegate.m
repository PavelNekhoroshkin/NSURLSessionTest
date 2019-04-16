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

@protocol UISearchBarDelegate;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc] init];
    ViewController *controller = [[ViewController alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];

    window.rootViewController = controller;
    
   
    DataStore *dataStore =[[DataStore alloc] init];
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


@end
