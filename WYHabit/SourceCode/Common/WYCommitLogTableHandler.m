//
//  WYCommitLogTableHandler.m
//  WYHabit
//
//  Created by Jia Ru on 3/27/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYCommitLogTableHandler.h"

#import <FMDatabase.h>
#import "FMDatabase+Addition.h"

@implementation WYCommitLogTableHandler

- (BOOL)createTables {
    return [self createCommitLogTable];
}

- (BOOL)createCommitLogTable {
    __block BOOL createTableSucceed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS CommitLog(goalID TEXT NO NULL, year INT, month INT, day INT, duration INT8, totalDaysUntilNow INT, totalHoursUntilNow INT, Reserve1 TEXT, Reserve2 TEXT, Reserve3 TEXT, PRIMARY KEY(goalID, year, month, day));";
        createTableSucceed = [database executeUpdate:sql];
    }];
    return createTableSucceed;
}

- (BOOL)updateCommitLog:(WYCommitLog *)commitLog {
    __block BOOL updateCommitLogSucceed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:10];
        dataDict[@"goalID"] = commitLog.goalID;
        dataDict[@"year"] = @(commitLog.year);
        dataDict[@"month"] = @(commitLog.month);
        dataDict[@"day"] = @(commitLog.day);
        dataDict[@"duration"] = @(commitLog.duration);
        dataDict[@"totalDaysUntilNow"] = @(commitLog.totalDaysUntilNow);
        dataDict[@"totalHoursUntilNow"] = @(commitLog.totalHoursUntilNow);
        updateCommitLogSucceed = [database updateTable:@"CommitLog" withParameterDictionary:dataDict];
    }];
    return updateCommitLogSucceed;
}

- (WYCommitLog *)getCommitLogBy:(NSString *)goalID year:(int)year month:(int) month day:(int)day {
    __block WYCommitLog *commitLog = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * from CommitLog WHERE goalID=? AND year=? AND month=? AND day=?", goalID, year, month, day];
        [resultSet next];
        commitLog = [self fillCommitLog:resultSet];
    }];
    return commitLog;
}

- (NSArray *)getCommitLogListByGoalID:(NSString *)goalID {
    __block NSMutableArray *commitLogList = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * from CommitLog WHERE goalID=?", goalID];
        while ([resultSet next]) {
            [commitLogList addObject:[self fillCommitLog:resultSet]];
        }
    }];
    return commitLogList;
}

- (WYCommitLog *)fillCommitLog:(FMResultSet *)resultSet {
    WYCommitLog *commitLog = [[WYCommitLog alloc] init];
    commitLog.goalID = [resultSet stringForColumn:@"goalID"];
    commitLog.year = [resultSet intForColumn:@"year"];
    commitLog.month = [resultSet intForColumn:@"month"];
    commitLog.day = [resultSet intForColumn:@"day"];
    commitLog.duration = [resultSet intForColumn:@"duration"];
    commitLog.totalDaysUntilNow = [resultSet intForColumn:@"totalDaysUntilNow"];
    commitLog.totalHoursUntilNow = [resultSet intForColumn:@"totalHoursUntilNow"];
    return commitLog;
}

@end