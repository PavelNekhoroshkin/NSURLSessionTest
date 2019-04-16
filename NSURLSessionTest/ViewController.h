//
//  ViewController.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadController.h"


@class DownloadController;

@interface ViewController : UIViewController
@property (nonatomic, strong) DataStore *dataStore;
@property (nonatomic, strong) NSObject<UISearchBarDelegate> *searchBarDelegate;
@property (nonatomic, strong) DownloadController *downloadController;

- (void) reloadCollectionView;
- (void) showErrorAlert;

@end

