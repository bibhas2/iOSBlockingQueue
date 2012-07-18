//
//  BlockingQueue.h
//  ThreadTest
//
//  Created by BIBHAS BHATTACHARYA on 5/20/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>
#import <time.h>
#import <sys/time.h>

@interface BoundedBlockingQueue : NSObject {
@private
int maxSize;
NSMutableArray *queue;
pthread_mutex_t lock;
pthread_cond_t notEmpty, notFull;
}
- (BoundedBlockingQueue*) initWithSize: (int) size;
- (void) put: (id) data;
- (id) take: (int) timeout;
- (BOOL) isInQueue: (id) obj;
@end
