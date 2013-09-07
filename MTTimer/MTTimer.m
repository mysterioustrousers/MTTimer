//
//  MTTimer.m
//  Firehose
//
//  Created by Adam Kirk on 6/6/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTTimer.h"


@interface MTTimer ()
@property (nonatomic, strong) void       (^block)();
@property (nonatomic, strong) NSTimer    *minTimer;
@property (nonatomic, strong) NSTimer    *maxTimer;
@property (nonatomic, assign) BOOL       isDone;
@end

@implementation MTTimer


+ (MTTimer *)timerThatMustLastAtLeast:(NSTimeInterval)interval untilPerformingBlock:(void (^)())block
{
    MTTimer *timer  = [MTTimer new];
    timer.minTimer  = [NSTimer scheduledTimerWithTimeInterval:interval
                                                       target:timer
                                                     selector:@selector(nsTimerExpired:)
                                                     userInfo:nil
                                                      repeats:NO];
    timer.maxTimer  = nil;
    timer.block     = block;
    timer.isDone    = NO;
    return timer;
}

+ (MTTimer *)timerThatMustLastAtMost:(NSTimeInterval)interval beforePerformingBlock:(void (^)())block
{
    MTTimer *timer  = [MTTimer new];
    timer.maxTimer  = [NSTimer scheduledTimerWithTimeInterval:interval
                                                       target:timer
                                                     selector:@selector(nsTimerExpired:)
                                                     userInfo:nil
                                                      repeats:NO];
    timer.minTimer  = nil;
    timer.block     = block;
    timer.isDone    = NO;
    return timer;
}

+ (MTTimer *)timerThatMustLastAtLeast:(NSTimeInterval)min atMost:(NSTimeInterval)max beforePerformingBlock:(void (^)())block
{
    MTTimer *timer  = [MTTimer new];
    timer.minTimer  = [NSTimer scheduledTimerWithTimeInterval:min
                                                       target:timer
                                                     selector:@selector(nsTimerExpired:)
                                                     userInfo:nil
                                                      repeats:NO];

    timer.maxTimer  = [NSTimer scheduledTimerWithTimeInterval:max
                                                       target:timer
                                                     selector:@selector(nsTimerExpired:)
                                                     userInfo:nil
                                                      repeats:NO];
    timer.block     = block;
    timer.isDone    = NO;
    return timer;
}


- (void)done
{
    if (_minTimer && !_maxTimer) {
        if (_minTimer.isValid) {
            _isDone = YES;
        }
        else {
            if (_block) _block();
        }
    }

    else if (_maxTimer && !_minTimer) {
        if (_maxTimer.isValid) {
            [_maxTimer fire];
        }
    }

    else if (_minTimer && _maxTimer) {
        if (_minTimer.isValid) {
            _isDone = YES;
        }
        else if (!_minTimer.isValid && _maxTimer.isValid) {
            [_maxTimer fire];
        }
    }
}





#pragma mark - Private

- (void)nsTimerExpired:(NSTimer *)nsTimer
{
    if (_minTimer && !_maxTimer) {
        if (_isDone) {
            if (_block) _block();
        }
    }

    else if (_maxTimer && !_minTimer) {
        if (_block) _block();
    }

    else if (_maxTimer && _minTimer) {
        if (_isDone || nsTimer == _maxTimer) {
            if (_block) _block();
        }
    }
    
}

@end
