//  WYDataManager.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WYConstants.h"
#import "WYDatabase.h"
#import "WYGoal.h"
#import "WYCommitLog.h"

extern const int kSecondsPerDay;

@interface WYDataManager : NSObject

DECLARE_SHARED_INSTANCE(WYDataManager)

@property (strong, nonatomic) WYDatabase *database;

- (NSString *)generateUUID;
- (void)initDatabase;
- (void)initManagers;

#pragma mark - Goals

- (WYGoal *)addGoalNamed:(NSString *)actionNameOfGoal;
- (WYGoal *)getGoalByID:(NSString *)goalID;
- (BOOL)updateGoal:(WYGoal *)goal;
- (BOOL)deleteGoalByID:(NSString *)goalID;

#pragma mark - CommitLogs

- (WYCommitLog *)getCommitLogByGoalID:(NSString *)goalID year:(int)year month:(int)month day:(int)day;
- (BOOL)updateCommitLog:(WYCommitLog *)commitLog;
- (BOOL)deleteCommitLog:(WYCommitLog *)commitLogToDelete;

#pragma mark - MainView

- (NSArray *)getMainViewLiveGoalViewModelList;

#pragma mark - AllDetailView

- (NSArray *)getAllGoalDetailViewModelList;

#pragma mark - Timeline

- (int)calculateContinueSequenceForGoal:(NSString *)goalID;
- (float)calculateCommitPercentageForGoal:(NSString *)goalID;
- (int)calculateCommitRankingForGoal:(NSString *)goalID;

#pragma mark - Utils

- (WYDate *)convertDateToWYDate:(NSDate *)date;

@end
