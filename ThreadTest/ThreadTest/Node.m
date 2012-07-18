//
//  Node.m
//  ThreadTest
//
//  Created by BIBHAS BHATTACHARYA on 5/21/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Node.h"

@implementation Node 

@synthesize data;
@synthesize next;

- (void) dealloc {
    NSLog(@"Node geting destroyed: %@", data);
}

@end
