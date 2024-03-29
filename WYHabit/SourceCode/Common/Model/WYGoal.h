//
//  WYGoal.h
//  WYHabit
//
//  Created by Jia Ru on 2/24/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYGoal : NSObject

@property (copy, nonatomic) NSString *goalID;
@property (copy, nonatomic) NSString *action;
@property (copy, nonatomic) NSDate *startTime;
@property (copy, nonatomic) NSDate *endTime;
@property (copy, nonatomic) NSDate *achiveTime;
@property (assign, nonatomic) int totalDays;
@property (assign, nonatomic) int totalHours;

@end
