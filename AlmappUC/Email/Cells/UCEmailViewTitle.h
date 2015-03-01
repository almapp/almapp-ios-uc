//
//  UCEmailViewTitle.h
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCEmailViewCell.h"

@interface UCEmailViewTitle : UCEmailViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
