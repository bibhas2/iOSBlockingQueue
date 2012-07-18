//
//  SimpleViewController.m
//  ThreadTest
//
//  Created by BIBHAS BHATTACHARYA on 5/20/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "SimpleViewController.h"

@interface SimpleViewController ()

@end

@implementation SimpleViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //queue = [[BoundedBlockingQueue alloc] initWithSize:5];
    queue = [[UnboundedBlockingQueue alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction) put: (id) sender {
    [NSThread detachNewThreadSelector:@selector(doPut) toTarget:self withObject:nil];
}

- (IBAction) get: (id) sender {
    [NSThread detachNewThreadSelector:@selector(doGet) toTarget:self withObject:nil];
}
- (void) doPut {
    int i;
    for (i = 0; i < 5; ++i) {
            @autoreleasepool {
            NSString *str = [NSString stringWithFormat: @"Data %d", i];
            NSLog(@"Putting %@", str);
            [queue put: str];
        }
    }
}

- (void) doGet {
    while (TRUE) {
        @autoreleasepool {
            NSString *str = [queue take: 10];
            if (str == nil) {
                NSLog(@"Queue is empty");
            } else {
                [NSThread sleepForTimeInterval: 1];
                NSLog(@"Got %@", str);
            }
        }
    }  
}
@end
