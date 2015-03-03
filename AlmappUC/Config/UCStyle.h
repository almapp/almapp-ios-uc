//
//  UCStyle.h
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Colours.h"
#import "UIImageEffects.h"

@interface UIColor (Style)

+ (UIColor*)myTransparent;
+ (UIColor*)blurriendHighlightedBackground;
+ (UIColor*)blurriendSelectedBackground;
+ (UIColor*)blurriendUnselectedBackground;
+ (UIColor*)lightLayer;

+ (UIColor*)accentColor;
+ (UIColor *)mainColor;
+ (UIColor *)mainColorTone1;
+ (UIColor *)mainColorTone2;
+ (UIColor *)mainColorTone3;
+ (UIColor *)mainColorTone4;
+ (UIColor *)mainColorTone5;

+ (UIColor *)myBlack;
+ (UIColor *)myContrast;
+ (UIColor *)alertColor;
+ (UIColor *)starColor;

@end

@interface UIImage (Style)

+ (UIImage *)imageNamed:(NSString *)name tint:(UIColor *)tintColor;

@end

@interface UCStyle : NSObject

+ (UIImage *)mainBackgroundImage;
+ (UIImage *)bannerBackgroundImage;

@end
