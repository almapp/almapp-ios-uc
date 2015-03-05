//
//  UCThreadViewController.m
//  AlmappUC
//
//  Created by Patricio López on 04-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCThreadViewController.h"
#import "UCEmailDetailViewController.h"
#import "UCAppDelegate.h"
#import "UITableView+Nib.h"
#import "UCEmailCell.h"
#import "UCStyle.h"

static NSString *const kEmailShowSegue = @"EmailViewSegue";

@interface UCThreadViewController () <SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RLMResults *sortedEmails;
@property (strong, nonatomic) ALMEmailThread *thread;

@end

@implementation UCThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClassesNib:@[[UCEmailCell nibName]]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.thread = self.currentThreads[self.selectedThreadIndex];
    self.sortedEmails = self.thread.sortedEmails;
    
    self.title = [NSString stringWithFormat:@"%d mensajes", (int)self.sortedEmails.count];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.thread.emails.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCEmailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[UCEmailCell nibName]];
    cell.delegate = self;
    cell.isEven = indexPath.row % 2 == 0;
    [cell setThread:self.thread email:self.sortedEmails[indexPath.row] state:UCEmailCellStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kEmailShowSegue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCEmailCell height];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCEmailCell height];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSUInteger selectedIndex = [self.tableView indexPathForSelectedRow].row;
    if ([segue.identifier isEqual:kEmailShowSegue]) {
        UCEmailDetailViewController *detail = [segue destinationViewController];
        detail.threadList = self.currentThreads;
        detail.email = self.sortedEmails[selectedIndex];
    }
}


@end
