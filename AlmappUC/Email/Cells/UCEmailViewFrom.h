//
//  UCEmailViewFrom.h
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCEmailViewCell.h"

@interface UCEmailViewFrom : UCEmailViewCell

@property (weak, nonatomic) IBOutlet UILabel *senderName;
@property (weak, nonatomic) IBOutlet UILabel *senderEmail;

@end
