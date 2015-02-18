//
//  UCChatTableViewController.m
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCChatTableViewController.h"
#import "UCMessagesViewController.h"

static NSString *const kMessageViewSegueName = @"MessageSegue";

@interface UCChatTableViewController ()

@property (strong, nonatomic) NSArray *chats; //RLMResults *chats;

@end

@implementation UCChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:[UCChatCell nibName] bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:[UCChatCell nibName]];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    _chats = @[@"", @"", @"", @"", @"", @"", @""];
    
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
    return _chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCChatCell* cell = [tableView dequeueReusableCellWithIdentifier:[UCChatCell nibName]];
    [cell setChat:nil]; // TODO: _chats[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:kMessageViewSegueName sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCChatCell height];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCChatCell height];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kMessageViewSegueName]) {
        UCMessagesViewController* controller = [segue destinationViewController];
        NSUInteger selectedIndex = [self.tableView indexPathForSelectedRow].row;
        controller.chat = nil; // TODO :[_chats objectAtIndex:selectedIndex];
    }
}


@end
