//
//  UCLoginViewController.m
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AlmappCore/AlmappCore.h>
#import <QuartzCore/QuartzCore.h>
#import <THLabel/THLabel.h>
#import <Colours/Colours.h>
#import <POP/POP.h>

#import "UCLoginViewController.h"
#import "NGAParallaxMotion.h"
#import "UCAppDelegate.h"



@interface UCLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
@property (weak, nonatomic) IBOutlet THLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;

@end



@implementation UCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.activityIndicator stopAnimating];

    self.loginButton.showsTouchWhenHighlighted = TRUE;
    
    self.titleLabel.parallaxIntensity = self.contentView.parallaxIntensity = 10.0f;
    
    self.titleLabel.shadowBlur = 10.0f;
    self.titleLabel.innerShadowBlur = 10.0f;
    self.titleLabel.shadowColor = [UIColor blackColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowOffset = CGSizeMake(5, 5);
    self.contentView.layer.shadowRadius = 6;
    self.contentView.layer.shadowOpacity = 0.6;
    self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.velocity = @1000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
    }];
    [self.contentView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Login

- (IBAction)loginButtonTouch:(id)sender {
    [self.view endEditing:YES];
    
    NSString *email = self.userField.text;
    NSString *password = self.passwordField.text;
    
    if (email && email.length > 0 && password && password.length > 0) {
        [self onOperationStart];
        
        if ([email rangeOfString:@"@"].location == NSNotFound) {
            email = [email stringByAppendingString:@"@uc.cl"];
            self.userField.text = email;
        }
        
        [[ALMUserController controller] login:email password:password realm:[RLMRealm defaultRealm]].then(^(ALMSession *session) {
            [UCAppDelegate didLoginWithSession:session];
            [self performSegueWithIdentifier:@"PostLoginSegue" sender:self];
            
        }).catch( ^(NSError *error) {
            [self onOperationEnd];
            [self onOperationFail:error.localizedDescription];
         
        });
    }
    else {
        [self onOperationEnd];
        [self onOperationFail:@"Campos incompletos"];
    }
}

- (void)onOperationStart {
    [self.activityIndicator startAnimating];
    
    self.userField.enabled = NO;
    self.passwordField.enabled = NO;
    self.loginButton.enabled = NO;
    self.privacyButton.enabled = NO;
    
    for (UITextField *field in @[self.userField, self.passwordField]) {
        [field setTextColor:[UIColor black50PercentColor]];
    }
    
    [self.loginButton setTitleColor:[UIColor ghostWhiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"Ingresando..." forState:UIControlStateNormal];
}

- (void)onOperationEnd {
    [self.activityIndicator stopAnimating];
    
    self.userField.enabled = YES;
    self.passwordField.enabled = YES;
    self.loginButton.enabled = YES;
    self.privacyButton.enabled = YES;
    
    for (UITextField *field in @[self.userField, self.passwordField]) {
        [field setTextColor:[UIColor blackColor]];
    }
    
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"Ingresar" forState:UIControlStateNormal];
}

- (void)onOperationFail:(NSString *)message {
    [self shake];
    [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil] show];
}

- (void)shake {
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
    }];
    [self.contentView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}


#pragma mark - Notification center

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma mark - Keyboard

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat buttonHeight = self.loginButton.frame.size.height;
    CGRect buttonOriginRect = [self.loginButton convertRect:self.view.bounds toView:nil];
    CGPoint buttonOrigin = CGPointMake(buttonOriginRect.origin.x, buttonOriginRect.origin.y + buttonHeight);
    
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}


#pragma mark - Text fields

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:_scrollView.contentOffset animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userField) {
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
        
    } else if (textField == self.passwordField) {
        [textField resignFirstResponder];
        [self loginButtonTouch:self.loginButton];
    }
    return YES;
}





/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
 */

/*
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    UIView *activeField = self.privacyButton;
    
 
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
     
}
*/
/*
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
