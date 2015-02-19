//
//  UCLoginNavigationController.m
//  AlmappUC
//
//  Created by Patricio López on 18-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCLoginNavigationController.h"
#import "OldStyleNavigationControllerAnimatedTransition.h"

@interface UCLoginNavigationController ()

@end

@implementation UCLoginNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame]; //CGRectMake(0, 0, 320, 460)];
    background.image = [UIImage imageNamed:@"background5.jpg"];
    background.clipsToBounds = YES;
    //[self.view addSubview:background];
    //[self.view sendSubviewToBack:background];
    [self.view insertSubview:background atIndex:0];
    
    self.delegate = self;
    // Do any additional setup after loading the view.
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:
(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    OldStyleNavigationControllerAnimatedTransition * animation = [[OldStyleNavigationControllerAnimatedTransition alloc] init];
    animation.operation = operation;
    return animation;
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
