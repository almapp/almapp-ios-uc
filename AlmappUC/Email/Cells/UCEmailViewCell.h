//
//  UCEmailViewCell.h
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/ALMEmailThread.h>

@interface UCEmailViewCell : UITableViewCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (strong, nonatomic) ALMEmail *email;

@end
