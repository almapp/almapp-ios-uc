//
//  UCEmailComposeViewController.m
//  AlmappUC
//
//  Created by Patricio López on 15-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <APAddressBook/APAddressBook.h>
#import <APAddressBook/APContact.h>

#import <AlmappCore/AlmappCore.h>
#import <CLTokenInputView/CLTokenInputView.h>

#import "UCEmailComposeViewController.h"
#import "UCContactCell.h"
#import "UCContactMutableArray.h"
#import "UCNavigationController.h"
#import "UITableView+Nib.h"
#import "UCAppDelegate.h"



@implementation APContact (Named)

- (NSString *)displayName {
    NSMutableString *display = [NSMutableString stringWithString:@""];
    if (self.firstName && self.firstName.length > 0) {
        [display appendString:self.firstName];
        [display appendString:@" "];
    }
    if (self.middleName && self.middleName.length > 0) {
        [display appendString:self.middleName];
        [display appendString:@" "];
    }
    if (self.lastName && self.lastName.length > 0) {
        [display appendString:self.lastName];
    }
    if (display.length <= 1) {
        return nil;
    }
    return display;
}

@end



@implementation CLToken (Quick)

+ (NSString *)truncateString:(NSString *)input {
    const int clipLength = 10;
    if(input.length > clipLength) {
        input = [NSString stringWithFormat:@"%@...",[input substringToIndex:clipLength]];
    }
    return input;
}

+ (instancetype)token:(NSString *)displayName object:(id)object {
    if (displayName && displayName.length > 0) {
        NSArray *parts = [displayName componentsSeparatedByString:@" "];
        displayName = parts.firstObject;
    }
    else {
        displayName = ((UCContact *)object).email;
    }
    displayName = [self truncateString:displayName];
    
    return [[CLToken alloc] initWithDisplayText:displayName context:object];
}

+ (instancetype)tokenFromContact:(UCContact *)contact {
    return [self token:contact.name object:contact];
}

- (UCContact *)contact {
    return (UCContact *)self.context;
}

@end



@interface UCEmailComposeViewController () <UITableViewDataSource, UITableViewDelegate, CLTokenInputViewDelegate>

@property (strong, nonatomic) UCContactMutableArray *loadedContacts;
@property (strong, nonatomic) UCContactMutableArray *selectedContacts;
//@property (strong, nonatomic) NSMutableDictionary *recipients;

@property (strong, nonatomic) APAddressBook *addressBook;

@property (weak, nonatomic) IBOutlet CLTokenInputView *tokenInputView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;

- (IBAction)closeButtonClick:(id)sender;
- (IBAction)sendButtonClick:(id)sender;

@end

@implementation UCEmailComposeViewController

+ (instancetype)presentEmailComposeViewOn:(UIViewController *)controller {
    UCEmailComposeViewController *composeView = [controller.storyboard instantiateViewControllerWithIdentifier:@"EmailComposeView"];
    UCNavigationController *navigationController = [[UCNavigationController alloc] initWithRootViewController:composeView];
    
    [controller presentViewController:navigationController animated:YES completion:nil];
    return composeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchTableView registerClassesNib:[UCContactCell nibName]];
    
    self.tableView.delegate = self.searchTableView.delegate = self;
    self.tableView.dataSource = self.searchTableView.dataSource = self;
    self.tokenInputView.delegate = self;
    
    [self.navigationController.navigationBar setBackgroundImage:[UCStyle bannerBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    
    self.tokenInputView.fieldName = @"Para:";
    self.tokenInputView.placeholderText = @"Buscar contacto";
    UIButton *contactAddButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [contactAddButton addTarget:self action:@selector(onAccessoryContactAddButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.tokenInputView.accessoryView = contactAddButton;
    self.tokenInputView.drawBottomBorder = YES;

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.tokenInputView.editing) {
        [self.tokenInputView beginEditing];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Address book

- (UCContactMutableArray *)selectedContacts {
    if (!_selectedContacts) {
        _selectedContacts = [UCContactMutableArray array];
    }
    return _selectedContacts;
}

- (UCContactMutableArray *)loadedContacts {
    if (!_loadedContacts) {
        _loadedContacts = [UCContactMutableArray array];
    }
    return _loadedContacts;
}

- (APAddressBook *)addressBook {
    if (!_addressBook) {
        _addressBook = [[APAddressBook alloc] init];
        
        _addressBook.filterBlock = ^BOOL(APContact *contact) {
            return contact.emails.count > 0;
        };
        /*
        _addressBook.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
                                         ];
        */
        _addressBook.fieldsMask =   APContactFieldFirstName |
                                    APContactFieldMiddleName |
                                    APContactFieldLastName |
                                    APContactFieldEmails |
                                    APContactFieldThumbnail;
        
    }
    return _addressBook;
}

- (PMKPromise *)searchLocalAddressBookContacts:(NSString *)match {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        self.addressBook.filterBlock = ^BOOL(APContact *contact) {
            if (contact.emails.count == 0) {
                return NO;
            }
            
            NSMutableArray *attributes = [NSMutableArray arrayWithObjects:contact.firstName, contact.middleName, contact.lastName, nil];
            for (NSString *email in contact.emails) {
                [attributes addObject:email];
            }
            
            for (NSString *attribute in attributes) {
                NSRange range = [attribute rangeOfString:match
                                                        options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
                if (range.location != NSNotFound) {
                    return YES;
                }
            }
            return NO;
        };
        
        [self.addressBook loadContacts:^(NSArray *contacts, NSError *error) {
            if (!error) {
                UCContactMutableArray *myContacts = [UCContactMutableArray arrayWithCapacity:contacts.count];
                for (APContact *contact in contacts) {
                    NSString *name = contact.displayName;
                    for (NSString *email in contact.emails) {
                        [myContacts addContact:[UCContact contactNamed:name email:email image:contact.thumbnail]];
                    }
                }
                fulfiller(myContacts);
            }
            else {
                NSLog(@"Error: %@", error);
                rejecter(error);
            }
        }];
    }];
}

- (PMKPromise *)searchLocalApiContacts:(NSString *)match {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        NSString *query = [NSString stringWithFormat:@"%@ CONTAINS '%@' OR %@ BEGINSWITH '%@'", kREmail, match, kRName, match];
        RLMResults *users = [ALMUser objectsInRealm:[RLMRealm defaultRealm] where:query];
        
        UCContactMutableArray *myContacts = [UCContactMutableArray arrayWithCapacity:users.count];
        for (ALMUser *user in users) {
            [myContacts addContact:[UCContact contactNamed:user.name email:user.email image:user.imageThumbPath]];
        }
        fulfiller(myContacts);
    }];
}

- (PMKPromise *)searchServerUsers:(NSString *)match {
    return [[UCAppDelegate controller] SEARCH:match ofType:[ALMUser class]].then( ^(NSArray *users, NSURLSessionDataTask *task) {
        UCContactMutableArray *myContacts = [UCContactMutableArray arrayWithCapacity:users.count];
        for (ALMUser *user in users) {
            [myContacts addContact:[UCContact contactNamed:user.name email:user.email image:user.imageThumbPath]];
        }
        return myContacts;
    });
}

-(void)clearSearchTable {
    [self.loadedContacts clear];
    [self.searchTableView reloadData];
}

-(void)clearSearchTableAnimated {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.loadedContacts.count];
    for(int i = 0; i < self.loadedContacts.count; i++) {
        NSIndexPath *anIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:anIndexPath];
    }
    [self.loadedContacts clear];
    
    [self.searchTableView beginUpdates];
    [self.searchTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.searchTableView endUpdates];
}

#pragma mark - CLTokenInputViewDelegate

- (void)tokenInputView:(CLTokenInputView *)view didChangeText:(NSString *)text {
    [self clearSearchTable];
    
    if (!text || text.length == 0){
        self.searchTableView.hidden = YES;
        self.tableView.hidden = NO;
        
        [self.tableView reloadData];
    } else {
        self.searchTableView.hidden = NO;
        self.tableView.hidden = YES;
        
        [self searchLocalAddressBookContacts:text].then( ^(UCContactMutableArray *contacts) {
            [self.loadedContacts addContacts:contacts];
            [self.searchTableView reloadData];
        });
        
        [self searchLocalApiContacts:text].then( ^(UCContactMutableArray *contacts) {
            [self.loadedContacts addContacts:contacts];
            [self.searchTableView reloadData];
        });
        
        [self searchServerUsers:text].then( ^(UCContactMutableArray *contacts) {
            [self.loadedContacts addContacts:contacts];
            [self.searchTableView reloadData];
        });
        
        self.searchTableView.hidden = NO;
    }
}

- (void)tokenInputView:(CLTokenInputView *)view didAddToken:(CLToken *)token {
    UCContact *contact = token.contact;
    [self.selectedContacts addContact:contact];
}

- (void)tokenInputView:(CLTokenInputView *)view didRemoveToken:(CLToken *)token {
    UCContact *contact = token.contact;
    [self.selectedContacts removeContact:contact];
}


- (CLToken *)tokenInputView:(CLTokenInputView *)view tokenForText:(NSString *)text {
    UCContact *contact = [UCContact contactNamed:nil email:text];
    return [CLToken tokenFromContact:contact];
}



# pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchTableView) {
        return 1;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchTableView) {
        return self.loadedContacts.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView) {
        UCContact *contact = self.loadedContacts[indexPath.row];
        
        UCContactCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCContactCell nibName] forIndexPath:indexPath];
        BOOL checkmark = [self.selectedContacts containsContact:contact];
        [cell setContact:contact checkmark:checkmark];
        
        return cell;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView) {
        return [UCContactCell height];
    }
    else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UCContact *contact = self.loadedContacts[indexPath.row];
    
    if (tableView == self.searchTableView) {
        [self.selectedContacts addContact:contact];
        CLToken *token = [CLToken tokenFromContact:contact];
        [self.tokenInputView addToken:token];
    }
    else {
        
    }
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onAccessoryContactAddButtonTapped:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Accessory View Button"
                                                        message:@"This view is optional and can be a UIButton, etc."
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)closeButtonClick:(id)sender {
       [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
