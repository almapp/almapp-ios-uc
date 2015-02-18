//
//  UCButtonHelper.h
//  AlmappUC
//
//  Created by Patricio López on 30-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRoundedButton.h"

@interface UCButtonHelper : NSObject

+ (MRoundedButton*)roundButtonForImageName:(NSString*)image size:(float)size;
+ (MRoundedButton*)roundButtonForImageName:(NSString*)image x:(float)x y:(float)y size:(float)size;

@end
