//
//  UCButtonHelper.m
//  AlmappUC
//
//  Created by Patricio López on 30-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCButtonHelper.h"

@implementation UCButtonHelper

+ (MRoundedButton*)roundButtonForImageName:(NSString *)image size:(float)size {
    return [self roundButtonForImageName:image x:0.0f y:0.0f size:size];
}

+(MRoundedButton*)roundButtonForImageName:(NSString *)image x:(float)x y:(float)y size:(float)size {
    NSDictionary *appearanceProxy3 = @{kMRoundedButtonCornerRadius : @40,
                                       kMRoundedButtonBorderWidth  : @2,
                                       kMRoundedButtonRestoreHighlightState : @YES,
                                       kMRoundedButtonBorderColor : [UIColor clearColor],
                                       kMRoundedButtonBorderAnimationColor : [UIColor whiteColor],
                                       kMRoundedButtonContentColor : [UIColor whiteColor],
                                       kMRoundedButtonContentAnimationColor : [UIColor blackColor],
                                       kMRoundedButtonForegroundColor : [[UIColor blackColor] colorWithAlphaComponent:0.5],
                                       kMRoundedButtonForegroundAnimationColor : [UIColor whiteColor]};
    
    [MRoundedButtonAppearanceManager registerAppearanceProxy:appearanceProxy3 forIdentifier:@"3"];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size/2, size/2)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *img = [UIImage imageNamed:image];
    
    MRoundedButton *button = [[MRoundedButton alloc] initWithFrame:CGRectMake(x, y, size, size)
                                                       buttonStyle:MRoundedButtonCentralImage
                                              appearanceIdentifier:@"3"];
    
    button.backgroundColor = [UIColor clearColor];
    button.imageView.image = img;
    return button;
}

@end
