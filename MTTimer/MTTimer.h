//
//  MTTimer.h
//  Firehose
//
//  Created by Adam Kirk on 6/6/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTTimer : NSObject

+ (MTTimer *)timerThatMustLastAtLeast:(NSTimeInterval)interval untilPerformingBlock:(void (^)())block;
+ (MTTimer *)timerThatMustLastAtMost:(NSTimeInterval)interval beforePerformingBlock:(void (^)())block;
+ (MTTimer *)timerThatMustLastAtLeast:(NSTimeInterval)min atMost:(NSTimeInterval)max beforePerformingBlock:(void (^)())block;

- (void)done;

@end
