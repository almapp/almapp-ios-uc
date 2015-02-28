//
//  UCStyle.m
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCStyle.h"

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

+ (UIColor *)accentColor {
    return [UIColor colorFromHexString:@"D7EAAC"];
}

+ (UIColor *)mainColor {
    return [UIColor colorFromHexString:@"242945"];
}

+ (UIColor *)myBlack {
    return [UIColor colorWithRed:0.11f green:0.11f blue:0.12f alpha:1.0f];
}

+ (UIColor *)myContrast {
    return [UIColor colorFromHexString:@"FFCC33"];
}

@end



@implementation UIImage (Style)

+ (UIImage *)imageNamed:(NSString *)name tint:(UIColor *)tintColor {
    return [[UIImage imageNamed:name] imageTintedWithColor:tintColor];
    //UIImage *image = [self imageNamed:name];
    //return [UIImageEffects imageByApplyingTintEffectWithColor:tintColor toImage:image];
}

- (UIImage *)imageTintedWithColor:(UIColor *)color {
    // This method is designed for use with template images, i.e. solid-coloured mask-like images.
    return [self imageTintedWithColor:color fraction:0.0]; // default to a fully tinted mask of the image.
}

- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction {
    if (color) {
        // Construct new image the same size as this one.
        UIImage *image;
        
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f); // 0.f for scale means "scale for device's main screen".
        } else {
            UIGraphicsBeginImageContext([self size]);
        }

        CGRect rect = CGRectZero;
        rect.size = [self size];
        
        // Composite tint color at its own opacity.
        [color set];
        UIRectFill(rect);
        
        // Mask tint color-swatch to this image's opaque mask.
        // We want behaviour like NSCompositeDestinationIn on Mac OS X.
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        
        // Finally, composite this image over the tinted mask at desired opacity.
        if (fraction > 0.0) {
            // We want behaviour like NSCompositeSourceOver on Mac OS X.
            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    return self;
}

@end



@implementation UCStyle

+ (UIImage *)mainBackgroundImage {
    return [UIImage imageNamed:@"background1.jpg"];
}


+ (UIImage *)bannerBackgroundImage {
    return [UIImage imageNamed:@"navbar1.jpg"];
}

@end
