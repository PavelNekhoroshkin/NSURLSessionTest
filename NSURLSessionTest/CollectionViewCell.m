//
//  CollectionViewCell.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 14.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,8,CGRectGetWidth(frame)-16,CGRectGetHeight(frame)-20)];
        imageView.backgroundColor = UIColor.greenColor;
        self.imageView = imageView;
        [self.contentView addSubview:imageView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,CGRectGetHeight(frame)-12,CGRectGetWidth(frame)-16,12)];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        
    }
    return self;
}

@end
