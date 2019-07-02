//
//  SUMainThreadMonitor.m
//  MainThreadMonitor
//
//  Created by dida on 2019/7/2.
//  Copyright © 2019 dida. All rights reserved.
//

#import "SUMainThreadMonitor.h"
#import <CrashReporter/CrashReporter.h>

@interface SUMainThreadMonitor(){
    CFRunLoopObserverRef _observer;
    @public
    CFRunLoopActivity activity;
    dispatch_semaphore_t _semaphore;
}

@end

@implementation SUMainThreadMonitor


+ (instancetype)shared{
    static SUMainThreadMonitor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)startMonitor{
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runloopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long st = dispatch_semaphore_wait(self->_semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st == 0) {
                continue;
            }
            if (self->activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting) {
                PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
                
                PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
                
                NSData *data = [crashReporter generateLiveReport];
                PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
                NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter withTextFormat:PLCrashReportTextFormatiOS];
                if ([self.watchDelegate respondsToSelector:@selector(SUMainThreadMonitorReport:)]) {
                    [self.watchDelegate SUMainThreadMonitorReport:report];
                }
            }
        }
    });
}

- (void)stopMonitor{
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    CFRelease(_observer);
    _observer = NULL;
}

static void runloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
     SUMainThreadMonitor *monitor = (__bridge SUMainThreadMonitor*)info;
    monitor->activity = activity;
    dispatch_semaphore_signal(monitor->_semaphore);
}


@end
