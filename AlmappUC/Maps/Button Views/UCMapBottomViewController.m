//
//  UCMapBottomViewController.m
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCMapBottomViewController.h"
#import "UCMapMainViewController.h"
#import "UIColor+Almapp.h"
#import <PromiseKit.h>

#import "UCCampusManager.h"
#import "UCFacultyManager.h"


@interface UCMapBottomViewController ()

@property (strong, nonatomic) DZNSegmentedControl *segmentedController;
@property (strong, nonatomic) UCCampusManager *campusManager;
@end


@implementation UCMapBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupArea:self.area];
    
    self.segmentedController.selectedSegmentIndex = 0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _manager = nil;
    
}



- (void)didSelect:(ALMArea *)area {
    [self setupArea:area];
}

- (void)setupArea:(ALMArea *)area {
    [self setViewTitle:area.shortName];
    
    [self scrollAndShow:area.localization mark:NO zoom:YES].then(^{
        self.manager = [self managerForArea:area];
        [self setSegmentedControllerResource:area];
        [self.manager start];
        
    });
}

- (void)setManager:(UCMapBottomManager *)manager {
    _manager = manager;
    _manager.delegate = self;
}

- (UCMapBottomManager *)managerForArea:(ALMArea *)area {
    UCMapBottomManager *manager = nil;
    if ([area isKindOfClass:[ALMCampus class]]) {
        manager = self.campusManager;
    }
    else if([area isKindOfClass:[ALMFaculty class]]){
        manager = [[UCFacultyManager alloc] initWithArea:area delegate:self];
    }
    
    self.tableView.delegate = manager;
    self.tableView.dataSource = manager;
    
    return manager;
}

- (UCCampusManager *)campusManager {
    if (!_campusManager) {
        _campusManager = [[UCCampusManager alloc] initWithArea:self.area delegate:self];
    }
    return _campusManager;
}



- (void)scrollToTop {
    UIScrollView *scrollView = [self.mainView parallaxScrollView];
    [scrollView setContentOffset: CGPointMake(0, -scrollView.contentInset.top) animated:YES];
}

- (PMKPromise *)scrollAndShow:(ALMPlace *)place mark:(BOOL)markIt zoom:(BOOL)zoomIt {
    UIScrollView *scrollView = [self.mainView parallaxScrollView];
    return [UIView promiseWithDuration:1 animations:^{
        [scrollView setContentOffset: CGPointMake(0, -scrollView.contentInset.top) animated:NO];
    }].then (^ {
        [self.mapHeader showArea:place withMarker:markIt withFocus:zoomIt];
    });
}

- (void)setViewTitle:(NSString *)title {
    [self.mainView setMapTitle:title];
}



- (UCMapHeaderViewController *)mapHeader {
    return _mainView.mapViewController;
}

- (DZNSegmentedControl *)segmentedController {
    if (!_segmentedController) {
        [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:4.0f];
        
        NSArray *items = @[@"Likes", @"Comentarios", @"Eventos"];
        _segmentedController= [[DZNSegmentedControl alloc] initWithItems:items];
        _segmentedController.tintColor = [UIColor mainColor];
        _segmentedController.bouncySelectionIndicator = YES;
        _segmentedController.autoAdjustSelectionIndicatorWidth = NO;
        _segmentedController.delegate = self;
        [_segmentedController addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
        [self.tableView setTableHeaderView:_segmentedController];
    }
    return _segmentedController;
}

- (UCSegmentedIndex)selectedSegment {
    return self.segmentedController.selectedSegmentIndex;
}

- (void)setSegmentedControllerResource:(ALMSocialResource<ALMEventHost> *)resource {
    [self setSegmentedControllerLikes:resource];
    [self setSegmentedControllerComments:resource];
    [self setSegmentedControllerEvents:resource];
}

- (void)setSegmentedControllerLikes:(id<ALMLikeable>)likeable {
    [self.segmentedController setCount:@(likeable.likesCount) forSegmentAtIndex:UCSegmentedIndexLikes];
}

- (void)setSegmentedControllerComments:(id<ALMCommentable>)commentable {
    [self.segmentedController setCount:@(commentable.commentsCount) forSegmentAtIndex:UCSegmentedIndexComments];
}

- (void)setSegmentedControllerEvents:(id<ALMEventHost>)eventHost {
    // [self.segmentedController setCount:@(eventHost.events.count) forSegmentAtIndex:UCSegmentedIndexEvents];
}

- (void)selectedSegment:(id)sender {
    switch (self.segmentedController.selectedSegmentIndex) {
        case UCSegmentedIndexLikes:
            [self.manager showLikes];
            break;
            
        case UCSegmentedIndexComments:
            [self.manager showComments];
            break;
            
        case UCSegmentedIndexEvents:
            [self.manager showEvents];
            break;
            
        default:
            break;
    }
}


- (BOOL)navigationShouldPopOnBackButton {
    if ([self.manager.area isKindOfClass:[ALMCampus class]]) {
        return YES;
    }
    else if ([self.manager.area isKindOfClass:[ALMFaculty class]]) {
        [self setupArea:self.area];
        return NO;
    }
    else if ([self.manager.area isKindOfClass:[ALMBuilding class]]) {
        
        return NO;
    }
    else {
        return NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (UIScrollView *)scrollViewForParallaxController {
    return self.tableView;
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view {
    return UIBarPositionBottom;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
