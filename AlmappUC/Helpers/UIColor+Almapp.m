//
//  UIColor+Almapp.m
//  AlmappUC
//
//  Created by Patricio López on 30-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UIColor+Almapp.h"

@implementation UIColor (Almapp)

+ (UIColor *)myTransparent {
    return [UIColor clearColor];
}

+ (UIColor*)blurriendHighlightedBackground {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
}

+ (UIColor*)blurriendSelectedBackground {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
}

+ (UIColor *)blurriendUnselectedBackground {
    return [UIColor clearColor];
}

+ (UIColor*)lightLayer {
    return [UIColor colorWithWhite:1.0f alpha:0.1f];
}

+ (UIColor *)navbarAccent {
    return [UIColor colorFromHexString:@"D7EAAC"];
}

+ (UIColor *)mainColor {
    return [UIColor colorFromHexString:@"242945"];
}

+ (UIColor *)myBlack {
    return [UIColor colorWithRed:0.11f green:0.11f blue:0.12f alpha:1.0f];
}

@end