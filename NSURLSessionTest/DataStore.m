//
//  DataStore.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore
- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoParams = [[NSMutableDictionary alloc] init];
        _pictureIds = [[NSMutableArray alloc] init];
        _pictureURLs = [[NSMutableDictionary alloc] init];
        _minPhotoNSData = [[NSMutableDictionary alloc] init];
        _maxPhotoNSData = [[NSMutableDictionary alloc] init];
        _maxPhotoStartDownload = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
