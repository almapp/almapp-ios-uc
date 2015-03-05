//
//  UCEmailCell.h
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>
#import "UCEmailViewCell.h"

typedef NS_ENUM(NSInteger, UCEmailCellState) {
    UCEmailCellStateNormal,
    UCEmailCellStateError,
    UCEmailCellStateDeleting,
    UCEmailCellStateSeeing,
    UCEmailCellStateStaring
};


@interface ALMEmailThread (Show)

- (ALMEmail *)displayEmail;

@end


@interface UCEmailCell : SWTableViewCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starredDotImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (assign, nonatomic) BOOL isEven;
@property (assign, nonatomic) UCEmailCellState state;
@property (strong, nonatomic) ALMEmailThread *thread;
@property (strong, nonatomic) ALMEmail *primaryEmail;

@property (assign, nonatomic) BOOL isTasking;

- (void)setThread:(ALMEmailThread *)thread emailAtIndex:(NSInteger)emailIndex state:(UCEmailCellState)state;
- (void)setThread:(ALMEmailThread *)thread email:(ALMEmail *)email state:(UCEmailCellState)state;
- (void)setThread:(ALMEmailThread *)thread state:(UCEmailCellState)state;

- (void)willUpdateFromServer:(BOOL)willDelete;

@end
