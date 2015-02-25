//
//  UCWebPagesCollectionViewCell.h
//  AlmappUC
//
//  Created by Patricio López on 12-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/ALMWebPage.h>


@interface UCWebPagesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel* title;
@property (weak, nonatomic) IBOutlet UIImageView* icon;
@property (weak, nonatomic) IBOutlet UIImageView* backgroundBlurred;
@property (weak, nonatomic) IBOutlet UIView* backgroundLayer;

@property (weak, nonatomic) ALMWebPage *webpage;

@end
