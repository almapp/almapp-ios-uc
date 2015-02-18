//
//  UCScheduleEndCell.h
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCScheduleBaseCell.h"
#import <AlmappCore/ALMScheduleModule.h>

@interface UCScheduleEndCell : UCScheduleBaseCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) ALMScheduleModule *lastModule;

@property (weak, nonatomic) IBOutlet UIImageView *dotImage;
@property (weak, nonatomic) IBOutlet UIView *upLineView;
@property (weak, nonatomic) IBOutlet UIView *downLineView;

@end
