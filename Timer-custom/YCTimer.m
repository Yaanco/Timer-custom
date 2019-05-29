//
//  YCTimer.m
//  Timer-custom
//
//  Created by Yaanco on 2019/5/13.
//  Copyright © 2019 Andy. All rights reserved.
//

#import "YCTimer.h"

@implementation YCTimer

static NSMutableDictionary *timers_;
static dispatch_semaphore_t semaphore_;

+ (void)initialize
{
    if (self == [YCTimer class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            timers_ = [NSMutableDictionary dictionary];
            semaphore_ = dispatch_semaphore_create(1);
        });
    }
}

+ (NSString *)excuteTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval async:(BOOL)async repeats:(BOOL)repeats {
    if (!task || start < 0 || (interval <= 0 && repeats)) return nil;
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    NSString *name = [NSString stringWithFormat:@"%zd",timers_.count];
    timers_[name] = timer;
    dispatch_semaphore_signal(semaphore_);
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    dispatch_resume(timer);
    return name;
}

+ (NSString *)excuteTask:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval async:(BOOL)async repeats:(BOOL)repeats {
    if(!target || !selector) return nil;
    return [self excuteTask:^{
        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    } start:start interval:interval async:async repeats:repeats];
}

+ (void)cancelTask:(NSString *)name {
    if(name.length == 0) return;
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[name];
    if (timer) {
        dispatch_source_cancel(timers_[name]);
        [timers_ removeObjectForKey:name];
    }
    dispatch_semaphore_signal(semaphore_);
}

@end
