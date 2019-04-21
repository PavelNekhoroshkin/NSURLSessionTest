//
//  CollectionViewCell.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 14.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell// <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray<NSString *> *pickerViewData;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ViewController *controller;
@end

NS_ASSUME_NONNULL_END
