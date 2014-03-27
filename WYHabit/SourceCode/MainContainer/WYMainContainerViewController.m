//
//  WYMainContainerViewController.m
//  WYHabit
//
//  Created by Jia Ru on 3/26/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYMainContainerViewController.h"
#import "ITTCalendarView.h"
#import "ITTBaseDataSourceImp.h"
#import "WYDataManager.h"
#import "WYGoalInMainViewModel.h"
#import "WYUIElementManager.h"

static const int kCommitButtonSectionHeight = 250;
static const int kCommitButtonTopMargin = 40;
static const int kCommitButtonRedius = 200;

static const int kCalendarTopMargin = 30;
static const int kCalendarHeight = 255;
static const int kLineChratTopSpacingToCalendar = 30;
static const int kLineChartHeight = 255;
static const int kChartsSectionHeight = kCalendarTopMargin + kCalendarHeight + kLineChratTopSpacingToCalendar + kLineChartHeight;

static const int kOperationSectionHeight = 100;
static const int kOperationButtonRadius = 80;
static const int kOperationButtonSideMargin = 10;

@interface WYMainContainerViewController ()

@property (strong, nonatomic) UIScrollView *mainContainerScrollView;

@property (strong, nonatomic) NSArray *liveGoalViewModelList;
@property (assign, nonatomic) int currentPageIndex;

// this is not used
//@property (strong, nonatomic) UIPageControl *mainContainerPageControl;

@end

@implementation WYMainContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _liveGoalViewModelList = [[WYDataManager sharedInstance] getMainViewLiveGoalViewModelList];
        _currentPageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainContainerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    self.mainContainerScrollView.pagingEnabled = YES;
    [self.view addSubview:self.mainContainerScrollView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGSize sizeOfScrollView = self.mainContainerScrollView.frame.size;
    self.mainContainerScrollView.contentSize = CGSizeMake(sizeOfScrollView.width * self.liveGoalViewModelList.count, sizeOfScrollView.height);
    self.mainContainerScrollView.delegate = self;
    
    for (int i = 0; i < self.liveGoalViewModelList.count; ++i) {
        CGRect frameOfSingleGoalView = (CGRect){.origin=CGPointMake(sizeOfScrollView.width * i, 0), .size=sizeOfScrollView};
        UIScrollView *singleGoalScrollView = [self drawVerticalScrollViewByGoal:[self.liveGoalViewModelList objectAtIndex:i]];
        singleGoalScrollView.frame = frameOfSingleGoalView;
        [self.mainContainerScrollView addSubview:singleGoalScrollView];
        if (i % 2 == 0) {
            singleGoalScrollView.backgroundColor = [UIColor whiteColor];
        } else {
            singleGoalScrollView.backgroundColor = UI_COLOR_MAIN_BACKGROUND_GRAY_EXSTREAM_LIGHT;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)drawVerticalScrollViewByGoal:(WYGoalInMainViewModel *)goalViewModel {
    UIScrollView *singleGoalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    singleGoalScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, kCommitButtonSectionHeight + kChartsSectionHeight + kOperationSectionHeight);
    
    [self drawCommitButtonOnSingleGoalView:singleGoalScrollView];
    [self drawChartsOnSingleGoalView:singleGoalScrollView];
    [self drawOperationButtonsOnSingleGoalView:singleGoalScrollView];
    
    return singleGoalScrollView;
}

- (void)drawCommitButtonOnSingleGoalView:(UIScrollView *)singleGoalScrollView {
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [singleGoalScrollView addSubview:commitButton];
    //    commitButton.backgroundColor = UI_COLOR_GRAY_LIGHT;
    CGFloat frameOfCommitButtonX = (UI_SCREEN_WIDTH - kCommitButtonRedius) / 2;
    commitButton.frame = CGRectMake(frameOfCommitButtonX, kCommitButtonTopMargin, kCommitButtonRedius, kCommitButtonRedius);
    commitButton.clipsToBounds = YES;
    CALayer *commitButtonLayer = [commitButton layer];
    commitButtonLayer.cornerRadius = kCommitButtonRedius / 2;
    commitButtonLayer.borderWidth = 2.0f;
    commitButtonLayer.borderColor = [UI_COLOR_ORANGE CGColor];
    
    [commitButton setTitle:@"I am kool!" forState:UIControlStateNormal];
    [commitButton setTitleColor:UI_COLOR_ORANGE forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont boldSystemFontOfSize:35];
    
    [commitButton addTarget:self action:@selector(commitGoalOnCurrentPage) forControlEvents:UIControlEventTouchDown];
}

- (void)drawChartsOnSingleGoalView:(UIScrollView *)singleGoalScrollView {
    UIView *chartsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, kCommitButtonSectionHeight, UI_SCREEN_WIDTH, kChartsSectionHeight)];
    [singleGoalScrollView addSubview:chartsContainerView];
    
    UIView *calendarContainerView = [[UIView alloc] initWithFrame:CGRectMake(8, kCalendarTopMargin, 309, kCalendarHeight)];
    [chartsContainerView addSubview:calendarContainerView];
    calendarContainerView.clipsToBounds = YES;
    ITTCalendarView *calendarView = [ITTCalendarView viewFromNib];
    ITTBaseDataSourceImp *dataSource = [[ITTBaseDataSourceImp alloc] init];
    calendarView.date = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
    calendarView.dataSource = dataSource;
    //    calendarView.delegate = self;
    calendarView.frame = CGRectMake(0, 0, 309, 410);
    calendarView.allowsMultipleSelection = YES;
    [calendarView showInView:calendarContainerView];
    
    UIView *lineChartView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarContainerView.frame) +  kLineChratTopSpacingToCalendar, UI_SCREEN_WIDTH, kLineChartHeight)];
    lineChartView.backgroundColor = UI_COLOR_GRAY_LIGHT;
    [chartsContainerView addSubview:lineChartView];
}

- (void)drawOperationButtonsOnSingleGoalView:(UIScrollView *)singleGoalScrollView {
    UIView *operationSectionContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, kCommitButtonSectionHeight + kChartsSectionHeight, UI_SCREEN_WIDTH, kOperationSectionHeight)];
    [singleGoalScrollView addSubview:operationSectionContainerView];
    
    UIButton *finishGoalButton = [[WYUIElementManager sharedInstance] createRoundButtonWithRadius:kOperationButtonRadius];
    finishGoalButton.frame = CGRectMake(kOperationButtonSideMargin, (kOperationSectionHeight - kOperationButtonRadius) / 2, kOperationButtonRadius, kOperationButtonRadius);
    finishGoalButton.layer.borderWidth = 2.0f;
    finishGoalButton.layer.borderColor = [UI_COLOR_ORANGE CGColor];
    [finishGoalButton setTitleColor:UI_COLOR_ORANGE forState:UIControlStateNormal];
    [finishGoalButton setTitle:@"Finish" forState:UIControlStateNormal];
    [operationSectionContainerView addSubview:finishGoalButton];
    
    [finishGoalButton addTarget:self action:@selector(finishGoalOnCurrentPage) forControlEvents:UIControlEventTouchDown];
    
    UIButton *editGoalButton = [[WYUIElementManager sharedInstance] createRoundButtonWithRadius:kOperationButtonRadius];
    editGoalButton.backgroundColor = UI_COLOR_ORANGE;
    [editGoalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editGoalButton.frame = CGRectMake(UI_SCREEN_WIDTH - kOperationButtonRadius - kOperationButtonSideMargin, (kOperationSectionHeight - kOperationButtonRadius) / 2, kOperationButtonRadius, kOperationButtonRadius);
    [editGoalButton setTitle:@"Detail" forState:UIControlStateNormal];
    [operationSectionContainerView addSubview:editGoalButton];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentPageIndex:(scrollView.contentOffset.x / scrollView.frame.size.width)];
}

#pragma mark - GoalOperations

- (void)commitGoalOnCurrentPage {
    NSLog(@"Commit goal on page: %d", self.currentPageIndex);
}

- (void)finishGoalOnCurrentPage {
    NSLog(@"Finish goal on page: %d", self.currentPageIndex);
}

#pragma mark - Other

- (void)updateCurrentPageIndex:(int)pageIndex {
    NSLog(@"Update currentPageIndex: %d", pageIndex);
    self.currentPageIndex = pageIndex;
}
@end