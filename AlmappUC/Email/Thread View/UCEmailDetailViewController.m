//
//  UCEmailDetailViewController.m
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <PromiseKit/Promise.h>

#import "UCEmailDetailViewController.h"
#import "UCStyle.h"
#import "UITableView+Nib.h"

@interface UCEmailDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) NSArray *cellClasses;
@property (strong, nonatomic) NSMutableDictionary *bodyCellHeights;

@property (strong, nonatomic) UIBarButtonItem *upButton;
@property (strong, nonatomic) UIBarButtonItem *downButton;

@end

@implementation UCEmailDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowUp" tint:[UIColor accentColor]] style:UIBarButtonItemStylePlain target:self action:@selector(upButtonTouch:)];
    
    self.downButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowDown" tint:[UIColor accentColor]] style:UIBarButtonItemStylePlain target:self action:@selector(downButtonTouch:)];

    self.navigationItem.rightBarButtonItems = @[self.downButton, self.upButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    for (Class cellClass in self.cellClasses) {
        [self.tableView registerClassesNib:[cellClass nibName]];
    }
    
    [self setThreadAtIndex:self.selectedThreadIndex];
}

- (NSMutableDictionary *)bodyCellHeights {
    if (!_bodyCellHeights) {
        _bodyCellHeights = [NSMutableDictionary dictionary];
    }
    return _bodyCellHeights;
}

- (NSMutableDictionary *)titlesCache {
    static NSMutableDictionary *titlesCache = nil;
    if (!titlesCache) {
        titlesCache = [NSMutableDictionary dictionary];
    }
    return titlesCache;
}

- (void)setThreadAtIndex:(NSInteger)index {
    self.downButton.enabled = index < self.threadList.count - 2;
    self.upButton.enabled = index > 0;
    
    self.thread = self.threadList[index];
}

- (void)setThread:(ALMEmailThread *)thread {
    _thread = thread;
    self.emails = thread.sortedEmails;
    [self.bodyCellHeights removeAllObjects];
    for (ALMEmail *email in thread.emails) {
        self.bodyCellHeights[email.identifier] = @([UCEmailViewBody height]);
    }
    [self scrollToTop].then(^{
        [self.tableView reloadData];
    });
}

- (ALMEmail *)emailAtIndex:(NSInteger)index {
    return self.emails[index];
}

- (NSInteger)indexOfEmail:(ALMEmail *)email {
    return [self.emails indexOfObject:email];
}


- (void)upButtonTouch:(UIBarButtonItem *)sender {
    self.selectedThreadIndex -= 1;
    [self setThreadAtIndex:self.selectedThreadIndex];
}

- (void)downButtonTouch:(UIBarButtonItem *)sender {
    self.selectedThreadIndex += 1;
    [self setThreadAtIndex:self.selectedThreadIndex];
}

- (PMKPromise *)scrollToTop {
    return [UIView promiseWithDuration:0.3 animations:^{
        [self.tableView setContentOffset:CGPointZero animated:NO];
    }];
}

- (NSArray *)cellClasses {
    if (!_cellClasses) {
        _cellClasses = @[[UCEmailViewTitle class], [UCEmailViewFrom class], [UCEmailViewBody class]];
    }
    return _cellClasses;
}

- (NSInteger)indexOfBodyCell {
    return [self.cellClasses indexOfObject:[UCEmailViewBody class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.titlesCache removeAllObjects];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.thread.emails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellClasses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self.cellClasses[indexPath.row] nibName] forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[UCEmailViewBody class]]) {
        ((UCEmailViewBody *)cell).delegate = self;
    }
    else if ([cell isKindOfClass:[UCEmailViewTitle class]]) {
        ((UCEmailViewTitle *)cell).delegate = self;
    }
    ((UCEmailViewCell *)cell).email = [self emailAtIndex:indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.indexOfBodyCell) {
        ALMEmail *email = [self emailAtIndex:indexPath.section];
        return [self.bodyCellHeights[email.identifier] floatValue];
    }
    else {
        return [self heightForBasicCellAtIndexPath:indexPath];
    }
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    UCEmailViewCell *sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[self.cellClasses[indexPath.row] nibName]];
    
    [self configureCell:sizingCell forRowAtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellClasses[indexPath.row] height];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger numberOfSections = self.thread.emails.count;
    if (numberOfSections <= 1) {
        return nil;
    }
    else {
        return [NSString stringWithFormat:@"Email %d de %d en la conversación", (int)section + 1, (int)numberOfSections];
    }
}

- (void)setCacheTitle:(NSString *)title forEmail:(ALMEmail *)email {
    self.titlesCache[email.identifier] = title;
}

- (NSString *)cacheTitleForEmail:(ALMEmail *)email {
    return self.titlesCache[email.identifier];
}

- (void)reloadEmailCell:(ALMEmail *)email height:(NSInteger)height {
    if ([self.thread.emails indexOfObject:email] != NSNotFound) {
        self.bodyCellHeights[email.identifier] = @(height);
        
        NSInteger index = [self indexOfEmail:email];
        NSInteger webCellIndex = self.indexOfBodyCell;
        
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:webCellIndex inSection:index];
        [self.tableView reloadRowsAtIndexPaths:@[rowToReload] withRowAnimation:UITableViewRowAnimationNone];
    }
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
