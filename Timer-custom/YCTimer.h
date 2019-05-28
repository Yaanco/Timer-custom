//
//  YCTimer.h
//  Timer-custom
//
//  Created by Yaanco on 2019/5/13.
//  Copyright © 2019 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTimer : NSObject

/**
 执行一个定时器任务

 @param task        任务
 @param start       开始时间
 @param interval    间隔时间
 @param async       是否异步执行
 @param repeats     是否重复执行
 @return            任务的唯一标识
 */
+ (NSString *)excuteTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval async:(BOOL)async repeats:(BOOL)repeats;
+ (NSString *)excuteTask:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval async:(BOOL)async repeats:(BOOL)repeats;

/**
 取消定时器任务

 @param name 任务的唯一标识
 */
+ (void)cancelTask:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
