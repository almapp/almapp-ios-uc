//
//  UCPostsTableViewController.m
//  AlmappUC
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCPostsTableViewController.h"
#import "UCPostCell.h"
#import "UCAppDelegate.h"
#import "UITableView+Nib.h"


@interface UCPostsTableViewController ()

@property (strong, nonatomic) RLMResults* posts;
@property (nonatomic, strong) UCPostCell *prototypeCell;

@end

@implementation UCPostsTableViewController

- (void)fetch {
    [self.navigationController showProgress];
    
    ALMController *controller = [UCAppDelegate controller];
    [controller GETResources:[ALMPost class] path:@"campuses/1/posts" parameters:nil realm:[RLMRealm defaultRealm]].then( ^(id jsonResult, NSURLSessionDataTask *task, id result) {
        self.posts = [result sortedResultsUsingProperty:kRResourceID ascending:YES];
        [self.tableView reloadData];
        
    }).catch( ^(NSError *error) {
        [self.navigationController showError:error];
    });
}

- (UCPostCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:[UCPostCell nibName]];
    }
    return _prototypeCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClassesNib:[UCPostCell nibName]];
    
    [self fetch];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)_posts.count);
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCPostCell* cell = [tableView dequeueReusableCellWithIdentifier:[UCPostCell nibName] forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[UCPostCell class]]) {
        UCPostCell *postCell = (UCPostCell *)cell;
        postCell.post = self.posts[indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static UCPostCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[UCPostCell nibName]];
    });
    
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
    return kPostCellEstimatedHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
