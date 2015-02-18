//
//  UCCampusManager.h
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCMapBottomManager.h"

@interface UCCampusManager : UCMapBottomManager

@property (strong, nonatomic) NSObject<RLMCollection>* faculties;
@property (strong, nonatomic) NSObject<RLMCollection>* buildings;

- (void)start;

@end
