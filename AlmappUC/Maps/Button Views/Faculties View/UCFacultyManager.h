//
//  UCFacultyManager.h
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCMapBottomManager.h"
#import "UCPlaceCell.h"

@interface UCFacultyManager : UCMapBottomManager

@property (strong, nonatomic) NSObject<RLMCollection>* classrooms;
@property (strong, nonatomic) NSObject<RLMCollection>* otherPlaces;


- (void)start;

@end
