//
//  NotificationGenerator.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 20.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationGenerator.h"
@import UserNotifications;

@implementation NotificationGenerator
/**
 Генератор уведомления, с приглашением вернуться к поиску.
 Уведомления приходят только в background через 3 секунды после выхода из приложения.
 Если был выполнен поиск, то в уведомление будет последняя строка поиска и первый загруженный рисунок.
 Если был просмотр рисунков в окне фильтров, то в уведомлении будет последний просмотренный рисунок.
 
 @param searchText последняя строка поиска
 */
- (void) createOnExitNotificationWithSearchText:(NSString *)searchText
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    NSString *searhActionTitle;
    NSString *searhActionIdentifier;
    
    if(searchText)
    {
        content.title = @"Хотите продолжить?";
        content.body = [@"Вы искали: " stringByAppendingString:searchText];
        searhActionTitle = @"Повторить поиск";
        searhActionIdentifier = @"RepeatSearchAction";
        content.userInfo = @{@"searchText":searchText};
    }
    else
    {
        content.title = @"Можно найти все что угодно!";
        content.body = @"Просто укажите тему для поиска";
        searhActionTitle = @"Начать поиск";
        searhActionIdentifier = @"OpenSearchAction";
        content.userInfo = @{};
    }
    
    content.sound = [UNNotificationSound defaultSound];
    content.categoryIdentifier = @"FirstNotification";
    
    NSData *imageData = [self getImageData];
    if (imageData)
    {
        UNNotificationAttachment *attachment = [self createAttachmentWithImageData:imageData];
        
        if(attachment){
            content.attachments = @[attachment];
        }
    }
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

    UNNotificationAction *searhAction = [UNNotificationAction actionWithIdentifier:searhActionIdentifier title:searhActionTitle options:UNNotificationActionOptionForeground];
    UNNotificationAction *cancelAction = [UNNotificationAction actionWithIdentifier:@"CancelAction" title:@"Отмена" options:UNNotificationActionOptionDestructive];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"FirstNotification" actions:@[searhAction, cancelAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone ];
    [center setNotificationCategories:[NSSet setWithObject:category]];

    UNNotificationTrigger *triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Invitation for searching" content:content trigger:triger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"Error: %@",error);
        }
    }];
}



/**
 Генератор уведомления, с приглашениес поискать котов, если был поиск не по строкам "сat" или "сats".
 Уведомления приходят только в foreground через 10 секунд после загрузки первого найденного рисунка,
 в уведомлении включен найденный рисунок.
 
 @param searchText последняя строка поиска
 */
- (void) createCatSearchNotificationWithSearchText:(NSString *)searchText;
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

    
    NSString *searhActionTitle;
    NSString *searhActionIdentifier;
    
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];

    if([searchText caseInsensitiveCompare:@"Cat"] == NSOrderedSame || [searchText caseInsensitiveCompare:@"Cats"] == NSOrderedSame )
    {
        //если пользователь успел до показа уведомления сам выполнить поиск кошек, то нужно отменить отправленные уведомления
        [center removePendingNotificationRequestsWithIdentifiers:@[@"Cat searching"]];
        return;
    }
   
    content.title =[[@"Хватит искать \"" stringByAppendingString:searchText] stringByAppendingString:@"\""];
    content.body = @"Может лучше посмотрим пушистых котиков?";
    searhActionTitle = @"Смотреть КОТЭ!!!";
    searhActionIdentifier = @"CatSearchAction";
    content.userInfo = @{@"searchText":searchText};
    content.sound = [UNNotificationSound defaultSound];
    content.categoryIdentifier = @"SecondNotification";
    
    NSData *imageData = [self getImageData];
    if(imageData)
    {
        UNNotificationAttachment *attachment = [self createAttachmentWithImageData:imageData];
        
        if(attachment){
            content.attachments = @[attachment];
        }
    }
    
    UNNotificationAction *searhAction = [UNNotificationAction actionWithIdentifier:searhActionIdentifier title:searhActionTitle options:UNNotificationActionOptionForeground];
    UNNotificationAction *cancelAction = [UNNotificationAction actionWithIdentifier:@"CancelAction" title:@"Отмена" options:UNNotificationActionOptionDestructive];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"SecondNotification" actions:@[searhAction, cancelAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone ];
    UNNotificationTrigger *triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Cat searching" content:content trigger:triger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"Error: %@",error);
        }
    }];
    [center setNotificationCategories:[NSSet setWithObject:category]];
    
}
    


- (UNNotificationAttachment *) createAttachmentWithImageData:(NSData *)imageData
{
    NSURL *tmpFileURL =  [self getNSURL:imageData];
    
    NSError *error = nil;
    
    if(tmpFileURL)
    {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"Search" URL:tmpFileURL options:nil error:&error];
        
        if(attachment)
        {
            return attachment;
        }
    }
    return nil;
}


- (NSData *) getImageData
{
    NSString *idPicture = self.dataStore.noitficationMaxPicture;
    if (idPicture) {
        return [self.dataStore.maxPhotoNSData objectForKey:idPicture];
    }
    
    idPicture = self.dataStore.noitficationPicture;
    return [self.dataStore.minPhotoNSData objectForKey:idPicture];
}

/**
 Сохраняет просматриваемую картинку в файл, чтобы потом можно было отправить ее в уведомлении
 
 @param imageData данные загруженной картинки
 */
- (NSURL *) getNSURL:(NSData *)imageData
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSString *tmpSubFolderName = [[NSProcessInfo processInfo] globallyUniqueString];
    NSURL *tmpSubFolderURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpSubFolderName]];
    
    if([fileManager createDirectoryAtURL:tmpSubFolderURL withIntermediateDirectories:YES attributes:nil error:& error])
    {
        self.dataStore.tmpSubFolderURL = tmpSubFolderURL;
    }
    else
    {
        self.dataStore.tmpSubFolderURL = nil;
        return nil;
    }
    
    NSString *tmpFileName = [@"tmp." stringByAppendingString:[self contentTypeForImageData:imageData]];
    NSURL *fileURL = [tmpSubFolderURL URLByAppendingPathComponent:tmpFileName];
    
    if([imageData writeToURL:fileURL atomically:YES])
    {
        return fileURL;
    }
    
    return nil;
}


/**
 Очистить временную директорию
*/
- (void) removeTmpSubFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtURL:self.dataStore.tmpSubFolderURL error:&error];
    self.dataStore.tmpSubFolderURL = nil;
}


/**
 Опеределим тип расширения для файла картинки
 
 @param data данные загруженной картинки
 @return расширение
 */
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
    }
    return nil;
}


@end
