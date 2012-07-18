//
//  UnboundedBlockingQueue.h
//  ThreadTest
//
//  Created by BIBHAS BHATTACHARYA on 5/21/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/time.h>
#import "Node.h"

@interface UnboundedBlockingQueue : NSObject{
@private
    pthread_mutex_t lock;
    pthread_cond_t notEmpty;
    Node *first, *last;
}

- (UnboundedBlockingQueue*) init;
- (void) put: (id) data;
- (id) take: (int) timeout;

@end
