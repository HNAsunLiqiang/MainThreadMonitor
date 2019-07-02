//
//  ViewController.m
//  MainThreadMonitor
//
//  Created by dida on 2019/7/2.
//  Copyright © 2019 dida. All rights reserved.
//

#import "ViewController.h"
#import "SUMainThreadMonitor.h"
@interface ViewController ()<SUMainThreadMonitorDelegate>
{
    dispatch_semaphore_t _sem;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SUMainThreadMonitor shared] startMonitor];
    [SUMainThreadMonitor shared].watchDelegate = self;
//    _sem = dispatch_semaphore_create(0);
}
- (IBAction)startTask:(id)sender {
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER);
//        NSLog(@"1");
//        long sr = dispatch_semaphore_wait(_sem, dispatch_time(DISPATCH_TIME_NOW, 1000*NSEC_PER_MSEC ));
//        NSLog(@"2 -- %l",sr);
//    });
    
    sleep(2);
}

- (IBAction)task2:(id)sender {
    
//    dispatch_semaphore_signal(_sem);
}

- (void)SUMainThreadMonitorReport:(NSString *)report {
    NSLog(@"report:%@",report);
}

@end
