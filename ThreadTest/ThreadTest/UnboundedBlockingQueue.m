//
//  UnboundedBlockingQueue.m
//  ThreadTest
//
//  Created by BIBHAS BHATTACHARYA on 5/21/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "UnboundedBlockingQueue.h"

@implementation UnboundedBlockingQueue

- (UnboundedBlockingQueue*) init {
    if ((self = [super init])) {
        last = nil;
        first = nil;
        pthread_mutex_init(&lock, NULL);
        pthread_cond_init(&notEmpty, NULL);   
    }
    return self;
}

- (void) dealloc {
    pthread_mutex_destroy(&lock);
    pthread_cond_destroy(&notEmpty);
}

- (void) put: (id) data {
    NSLog(@"put() about to lock");
    pthread_mutex_lock(&lock);
    NSLog(@"put() got lock");

    NSLog(@"put() adding data");
    Node *n = [[Node alloc] init];
    
    n.data = data;

    if (last != nil) {
        last.next = n;
    }
    if (first == nil) {
        first = n;
    }
    
    last = n;

    NSLog(@"put() signalling not empty");
    pthread_cond_signal(&notEmpty);
    pthread_mutex_unlock(&lock);
    NSLog(@"put() unloacked");
}

- (id) take: (int) timeout {
    id data = nil;
    struct timespec ts;
    struct timeval now;
    
    NSLog(@"take() about to lock");
    pthread_mutex_lock(&lock);
    NSLog(@"take() got lock");
    
    gettimeofday(&now, NULL);
    
    ts.tv_sec = now.tv_sec + timeout; 
    ts.tv_nsec = 0; 
    
    while (first == nil) {
        NSLog(@"take() going to wait for not empty");
        if (pthread_cond_timedwait(&notEmpty, &lock, &ts) != 0) {
            NSLog(@"take() wait timedout");
            pthread_mutex_unlock(&lock);
            return nil;
        }
    }
    NSLog(@"take() extracting data");
    data = first.data;
    first = first.next;
    if (first == nil) {
        last = nil; //Empty queue
    }
    
    pthread_mutex_unlock(&lock);
    NSLog(@"take() unlocked");
    
    return data;
}

@end
