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
@property (assign, nonatomic) CGFloat bodyCellHeight;

@property (strong, nonatomic) UIBarButtonItem *upButton;
@property (strong, nonatomic) UIBarButtonItem *downButton;

@end


@implementation NSArray (NextPrevious)

- (id)nextOf:(id)object {
    NSInteger index = [self indexOfObject:object];
    return (index + 1 < self.count) ? [self objectAtIndex:index + 1] : nil;
}

- (id)previousOf:(id)object {
    NSInteger index = [self indexOfObject:object];
    return (index - 1 >= 0) ? [self objectAtIndex:index - 1] : nil;
}

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
    
    [self showEmailDetail:self.email];
}

- (NSMutableDictionary *)titlesCache {
    static NSMutableDictionary *titlesCache = nil;
    if (!titlesCache) {
        titlesCache = [NSMutableDictionary dictionary];
    }
    return titlesCache;
}

- (void)setEmail:(ALMEmail *)email {
    _email = email;
    self.bodyCellHeight = [UCEmailViewBody height];
}

- (void)showEmailDetail:(ALMEmail *)email {
    [self scrollToTop].then(^{
        self.email = email;
        self.nextEmail = self.previousEmail = nil;
        
        ALMEmailThread *thread = email.threads.firstObject;
        RLMResults *emails = thread.sortedEmails;
        
        NSInteger emailIndexInThread = [emails indexOfObject:email];
        
        if (emailIndexInThread == 0) {
            ALMEmailThread *previousThread = [self.threadList previousOf:thread];
            if (previousThread) {
                self.previousEmail = [previousThread.sortedEmails lastObject];
            }
        }
        else {
            self.previousEmail = [emails objectAtIndex:emailIndexInThread - 1];
        }
        
        if (emailIndexInThread == thread.emails.count - 1) {
            ALMEmailThread *nextThread = [self.threadList nextOf:thread];
            if (nextThread) {
                self.nextEmail = [nextThread.sortedEmails firstObject];
            }
        }
        else {
            self.nextEmail = [emails objectAtIndex:emailIndexInThread + 1];
        }
        
        self.downButton.enabled = (self.nextEmail != nil);
        self.upButton.enabled = (self.previousEmail != nil);
        
        [self.tableView reloadData];
    });
}


- (void)upButtonTouch:(UIBarButtonItem *)sender {
    [self showEmailDetail:self.nextEmail];
}

- (void)downButtonTouch:(UIBarButtonItem *)sender {
    [self showEmailDetail:self.previousEmail];
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
    return 1;
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
    ((UCEmailViewCell *)cell).email = self.email;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.indexOfBodyCell) {
        return MAX(self.bodyCellHeight, [UCEmailViewBody height]);
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
    ALMEmailThread *thread = self.email.threads.firstObject;
    RLMResults *sortedEmail = thread.sortedEmails;
    
    NSInteger emailsInThread = sortedEmail.count;
    if (emailsInThread <= 1) {
        return nil;
    }
    else {
        return [NSString stringWithFormat:@"Email %d de %d en la conversación", (int)[sortedEmail indexOfObject:self.email], (int)emailsInThread];
    }
}

- (void)setCacheTitle:(NSString *)title forEmail:(ALMEmail *)email {
    self.titlesCache[email.identifier] = title;
}

- (NSString *)cacheTitleForEmail:(ALMEmail *)email {
    return self.titlesCache[email.identifier];
}

- (void)reloadEmailCell:(ALMEmail *)email height:(NSInteger)height {
    self.bodyCellHeight = height;
    
    NSInteger webCellIndex = self.indexOfBodyCell;
    
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:webCellIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[rowToReload] withRowAnimation:UITableViewRowAnimationNone];
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
