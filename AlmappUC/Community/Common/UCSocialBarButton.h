//
//  UCSocialBarButton.h
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCSocialBarButton : UIView

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedView;

- (void)setSelected:(BOOL)selected;

@end
