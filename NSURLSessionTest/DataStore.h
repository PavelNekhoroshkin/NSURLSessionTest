//
//  DataStore.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UserNotifications;


NS_ASSUME_NONNULL_BEGIN

@interface DataStore : NSObject

//--------переменные для выполнения запросов и храения данных--------
//ключ для запроса к flikr
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

//--------переменные для работы уведомлений--------------------------
//последняя строка поиска (для формироования уведомления)
@property (nonatomic, strong) NSString *searchText;
//временная директория для хранения текущей картинки 1
@property (nonatomic, strong, nullable) NSURL *tmpSubFolderURL;



//временная директория для хранения текущей картинки 1
@property (nonatomic, strong, nullable) NSURL *tmp1FileURL;
//временная директория для хранения текущей картинки 2
@property (nonatomic, strong, nullable) NSURL *tmp2SubFolderURL;
//временная директория для хранения текущей картинки 2
@property (nonatomic, strong, nullable) NSURL *tmp2FileURL;
//временная директория для хранения текущей картинки 2


@property (nonatomic, strong, nullable) NSString *noitficationPicture;
@property (nonatomic, strong, nullable) NSString *noitficationMaxPicture;
//новый поиск, нужно сменить картинку
@property (nonatomic, strong, nullable) NSString *searchStarted;
//@property (nonatomic, strong, nullable) UILocalNotification *notificatiom;



@end

NS_ASSUME_NONNULL_END
