//
//  UCEmailDetailViewController.m
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailDetailViewController.h"
#import "UCStyle.h"
#import "UCEmailViewFrom.h"
#import "UCEmailViewTitle.h"
#import "UITableView+Nib.h"

@interface UCEmailDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) NSArray *cellClasses;

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

- (void)setThreadAtIndex:(NSInteger)index {
    RLMResults *threads = self.folder.sortedThreads;
    
    self.downButton.enabled = index < threads.count - 2;
    self.upButton.enabled = index > 0;
    
    self.thread = threads[index];
}

- (void)setThread:(ALMEmailThread *)thread {
    _thread = thread;
    [self.tableView reloadData];
}

- (void)upButtonTouch:(UIBarButtonItem *)sender {
    self.selectedThreadIndex -= 1;
    [self setThreadAtIndex:self.selectedThreadIndex];
}

- (void)downButtonTouch:(UIBarButtonItem *)sender {
    self.selectedThreadIndex += 1;
    [self setThreadAtIndex:self.selectedThreadIndex];
}



- (NSArray *)cellClasses {
    if (!_cellClasses) {
        _cellClasses = @[[UCEmailViewTitle class], [UCEmailViewFrom class]];
    }
    return _cellClasses;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    ((UCEmailViewCell *)cell).email = self.thread.sortedEmails[indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
