//
//  UIColor+Almapp.h
//  AlmappUC
//
//  Created by Patricio López on 30-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Colours.h"

@interface UIColor (Almapp)

+ (UIColor*)myTransparent;
+ (UIColor*)blurriendHighlightedBackground;
+ (UIColor*)blurriendSelectedBackground;
+ (UIColor*)blurriendUnselectedBackground;
+ (UIColor*)lightLayer;

+ (UIColor*)accentColor;
+ (UIColor *)mainColor;
+ (UIColor *)myBlack;

@end