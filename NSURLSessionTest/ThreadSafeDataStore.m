//
//  ThreadSafeDataStore.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 13.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "ThreadSafeDataStore.h"

@interface ThreadSafeDataStore()
@property (nonatomic, strong) NSMutableDictionary *pictureList;
@property (nonatomic,strong) dispatch_queue_t concurenQueue;

@end


@implementation ThreadSafeDataStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t queueForAccessToThreadSafeDataStore =   dispatch_queue_create("QueueForAccessToThreadSafeDataStore", DISPATCH_QUEUE_CONCURRENT);
        self.concurenQueue = queueForAccessToThreadSafeDataStore;
        self.pictureList = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}


- (NSDictionary *)getPictureParamsById:(NSString *)idPicture
{
    __block NSDictionary *pictureParams;

    dispatch_async(self.concurenQueue, ^{
        pictureParams = [self.pictureList objectForKey:idPicture];
    });
    
    return pictureParams;

}

- (void)setPictureParams:(NSDictionary *)pictureParams byId:(NSString *)idPicture
{
    dispatch_barrier_async(self.concurenQueue, ^{
        [self.pictureList setObject:pictureParams forKey:idPicture];
    });
}

@end

