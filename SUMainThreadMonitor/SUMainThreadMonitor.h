//
//  SUMainThreadMonitor.h
//  MainThreadMonitor
//
//  Created by dida on 2019/7/2.
//  Copyright © 2019 dida. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SUMainThreadMonitorDelegate <NSObject>

- (void)SUMainThreadMonitorReport:(NSString*)report;

@end


@interface SUMainThreadMonitor : NSObject
@property (nonatomic, weak) id<SUMainThreadMonitorDelegate> watchDelegate;
+ (instancetype)shared;
- (void)startMonitor;
- (void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
