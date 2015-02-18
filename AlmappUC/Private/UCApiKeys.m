//
//  UCApiKeys.m
//  AlmappUC
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCApiKeys.h"

NSString *const API_KEYS_FILE = @"ApiKeys";

NSString *const kGoogleMapsApiKey = @"GoogleMaps";

@implementation UCApiKeys

+ (NSString *)apiKeyFor:(NSString *)service {
    NSString *path = [[NSBundle mainBundle] pathForResource:API_KEYS_FILE ofType:@"plist"];
    NSAssert(path != nil, @"You must create a file with every api key, see UCApiKey class for more info.");
    
    NSDictionary* pairs = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    return (pairs != nil) ? [pairs objectForKey:service] : nil;
}

+ (ALMApiKey *)almappApiKey {
    //return [ALMApiKey apiKeyWithClient:@"c970e1f8282992baa673e3609753dc8bd746c4d7931b9a65ab1cab073be1f03e"
    //                            secret:@"3d834a31a2a65a8a0aa5a7c46d25a149b4c7282fc7d6d04977375ad4ae469459"];
    
    return [ALMApiKey apiKeyWithClient:@"d7d7613422a9cb2700d3bc9480289c806cee47805b3b8630139736db3627baa7"
                                secret:@"1dc112e063a38cebd76e3235e997318e4c724f9d27cf3b3df3def0e7355bd8a2"];
}

@end
