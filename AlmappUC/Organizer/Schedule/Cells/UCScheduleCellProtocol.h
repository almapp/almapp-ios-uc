//
//  UCScheduleCellProtocol.h
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

@protocol UCScheduleCellProtocol <NSObject>

@required

@property (weak, nonatomic) id item;

+ (NSString *)nibName;
+ (CGFloat)height;

@end
