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
    return [ALMApiKey apiKeyWithClient:@"0a6e77365356c94f322ebdc2819de92600dd821e48072a921e1f671276efac56"
                                secret:@"c221f9d0df564a26bfda08196cc9cc221df856ee5ee71e51c348ad105deabd13"];
    
    //return [ALMApiKey apiKeyWithClient:@"102752c7272f1cd5da2535a08acc8145347eef1ac6332b8550bf1f079446879a"
    //                            secret:@"14ff2ff1002f53f8b797efccf04bf3082f6eb854ac20f4af9b3563eb2072322e"];
}

@end
