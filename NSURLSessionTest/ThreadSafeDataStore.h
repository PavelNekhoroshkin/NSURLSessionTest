//
//  ThreadSafeDataStore.h
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 13.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThreadSafeDataStore : NSObject
- (NSDictionary *)getPictureParamsById:(NSString *)idPicture;
- (void)setPictureParams:(NSDictionary *)pictureParams byId:(NSString *)idPicture;


@end

NS_ASSUME_NONNULL_END
