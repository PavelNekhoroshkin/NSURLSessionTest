//
//  FilterButton.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 16.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "FilterButton.h"


/**
 Вспомогательный интерфейс для кнопок фильтров
 */
@implementation FilterButton

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 80, 30)];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor] ;
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        self.backgroundColor = UIColor.lightGrayColor;
        self.layer.borderWidth = 5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = 5;
    }
    return self;
}

@end
