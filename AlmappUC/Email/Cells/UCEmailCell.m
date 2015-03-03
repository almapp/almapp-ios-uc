//
//  UCEmailCell.m
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailCell.h"
#import "UCStyle.h"
#import <DateTools/NSDate+DateTools.h>

@implementation UCEmailCell

+ (NSString *)nibName {
    return @"UCEmailCell";
}

+ (CGFloat)height {
    return 115.0f;
}

- (void)awakeFromNib {
    // Initialization code
    [self.arrowImageView setTintColor:[UIColor darkGrayColor]];
    
    self.rightUtilityButtons = [UCEmailCell rightButtons];
    self.leftUtilityButtons = [UCEmailCell leftButtons];
    
    [self.activityIndicator stopAnimating];
    
    [self.dotImageView setTintColor:[UIColor mainColor]];
    [self.starredDotImageView setTintColor:[UIColor starColor]];
    
    [self setTintColor:[UIColor mainColor]];
    
    
    // self.dateLabel.text = item.createdAt.shortTimeAgoSinceNow;
}

- (void)setThread:(ALMEmailThread *)thread state:(UCEmailCellState)state {
    _thread = thread;
    _state = state;
    
    ALMEmail *email = thread.newestEmail;

    self.subjectLabel.text = [NSString stringWithFormat:@"%d - %@", (int)thread.emails.count, email.subject]; //email.subject;
    self.bodyLabel.text = email.snippet;
    self.dateLabel.text = email.date.shortTimeAgoSinceNow;
    
    NSDictionary *from = email.from;
    NSString *senderEmail = [from allKeys].firstObject;
    self.senderLabel.text = ([from[senderEmail] isKindOfClass:[NSNull class]]) ? senderEmail : from[senderEmail];
    
    [self setCorrespondientColor];
    
    [self willUpdateFromServer:(state == UCEmailCellStateDeleting)];
}

- (void)willUpdateFromServer:(BOOL)willUpdate {
    if (willUpdate) {
        self.isTasking = YES;
        //self.dotImageView.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
    }
    else {
        self.isTasking = NO;
        //self.dotImageView.hidden = NO;
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }
}

- (void)setIsEven:(BOOL)isEven {
    _isEven = isEven;
    //[self setCorrespondientColor];
}

- (void)setCorrespondientColor {
    if(self.isEven) {
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:249/255.0 blue:249/255.0 alpha:1.0f];
        //self.backgroundColor = [[UIColor accentColor] colorWithAlphaComponent:0.1f];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.thread.newestEmail.labels & ALMEmailLabelUnread) {
        self.dotImageView.hidden = NO;
    }
    else {
        self.dotImageView.hidden = YES;
    }
    
    if (self.thread.newestEmail.labels & ALMEmailLabelStarred) {
        self.starredDotImageView.hidden = NO;
    }
    else {
        self.starredDotImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setCorrespondientColor];
    // Configure the view for the selected state
}

+ (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor lightGrayColor]
                                                title:@"Más"];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor alertColor]
                                                title:@"Borrar"];
    return rightUtilityButtons;
}

+ (NSArray *)leftButtons {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor mainColorTone4]
                                                icon:[UIImage imageNamed:@"Eye" tint:[UIColor whiteColor]]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor mainColorTone3]
                                                icon:[UIImage imageNamed:@"Star" tint:[UIColor whiteColor]]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor mainColorTone2]
                                                icon:[UIImage imageNamed:@"Reply" tint:[UIColor whiteColor]]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor mainColorTone1]
                                                icon:[UIImage imageNamed:@"Forward" tint:[UIColor whiteColor]]];
    return leftUtilityButtons;
}

@end
