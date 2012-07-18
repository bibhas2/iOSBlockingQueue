//
//  SimpleViewController.h
//  ThreadTest
//
//  Created by BIBHAS BHATTACHARYA on 5/20/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoundedBlockingQueue.h"
#import "UnboundedBlockingQueue.h"

@interface SimpleViewController : UIViewController {
    //BoundedBlockingQueue *queue;
    UnboundedBlockingQueue *queue;
}
- (IBAction) put: (id) sender;
- (IBAction) get: (id) sender;
@end
