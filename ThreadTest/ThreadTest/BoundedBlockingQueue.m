//
//  BlockingQueue.m
//  ThreadTest
//
//  Created by BIBHAS BHATTACHARYA on 5/20/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "BoundedBlockingQueue.h"

@implementation BoundedBlockingQueue

- (BoundedBlockingQueue*) initWithSize:(int)size {
    if ((self = [super init])) {
        maxSize = size;
        queue = [[NSMutableArray alloc] initWithCapacity: maxSize];

        pthread_mutex_init(&lock, NULL);
        pthread_cond_init(&notEmpty, NULL);   
        pthread_cond_init(&notFull, NULL);   
    }
    return self;
}

- (void) dealloc {
    pthread_mutex_destroy(&lock);
    pthread_cond_destroy(&notEmpty);
    pthread_cond_destroy(&notFull);
}

- (void) put: (id) data {
    //NSLog(@"put() about to lock");
    pthread_mutex_lock(&lock);
    //NSLog(@"put() got lock");
    while ([queue count] == maxSize) {
        //NSLog(@"put() going to wait for not full");
        pthread_cond_wait(&notFull, &lock);
        //NSLog(@"put() finished waiting");
    }
    //NSLog(@"put() adding data");
    [queue addObject: data];
    //NSLog(@"put() signalling not empty");
    pthread_cond_signal(&notEmpty);
    pthread_mutex_unlock(&lock);
    //NSLog(@"put() unloacked");
}

- (id) take: (int) timeout {
    id data = nil;
    struct timespec ts;
    struct timeval now;
    
    //NSLog(@"take() about to lock");
    pthread_mutex_lock(&lock);
    //NSLog(@"take() got lock");
    
    gettimeofday(&now, NULL);
    
    ts.tv_sec = now.tv_sec + timeout; 
    ts.tv_nsec = 0; 
    
    while ([queue count] == 0) {
        //NSLog(@"take() going to wait for not empty");
        if (pthread_cond_timedwait(&notEmpty, &lock, &ts) != 0) {
            //NSLog(@"take() wait timedout");
            pthread_mutex_unlock(&lock);
            return nil;
        }
    }
    //NSLog(@"take() extracting data");
    data = [queue objectAtIndex:0];
    [queue removeObjectAtIndex:0];
    
    //NSLog(@"take() signalling not full");
    pthread_cond_signal(&notFull);
    pthread_mutex_unlock(&lock);
    //NSLog(@"take() unlocked");
    
    return data;
}

- (BOOL) isInQueue: (id) obj {
    pthread_mutex_lock(&lock);
    BOOL result = FALSE;
    
    for (int i = 0; i < queue.count; ++i) {
        id o = [queue objectAtIndex:i];
        if (o == obj) {
            result = TRUE;
            break;
        }
    }
    pthread_mutex_unlock(&lock);
    
    return result;
}
@end
