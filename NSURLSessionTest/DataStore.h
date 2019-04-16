//
//  DataStore.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataStore : NSObject

@property (nonatomic, strong) NSString *APIKey;

//название и другие параметры фото
@property (nonatomic, strong) NSMutableDictionary *photoParams;
//список идентификаторов
@property (nonatomic, strong) NSMutableArray *pictureIds;
//список URL на рисунки
@property (nonatomic, strong) NSMutableDictionary *pictureURLs;
//словарь скачанных миниверсий рисунков
@property (nonatomic, strong) NSMutableDictionary *minPhotoNSData;
//словарь скачанных миниверсий рисунков
@property (nonatomic, strong) NSMutableDictionary *maxPhotoNSData;
//признак запуска загрузки рисунков, чтобы не начинать повторные загрузки, пока первая не закончена
@property (nonatomic, strong) NSMutableDictionary *maxPhotoStartDownload;


@end

NS_ASSUME_NONNULL_END
