//
//  UCApiKey.m
//  AlmappUC
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCApiKey.h"

NSString *const API_KEYS_FILE = @"ApiKeys";

NSString *const kGoogleMapsApiKey = @"GoogleMaps";
NSString *const kAlmappApiKey = @"Almapp";
NSString *const kGoogleApiKey = @"GoogleApi";

static NSDictionary *apiKeyFile = nil;

@implementation UCApiKey

+ (instancetype)OauthApiKey:(NSString *)uid secret:(NSString *)secret {
    UCApiKey *key = [[self alloc] init];
    key.uid = uid;
    key.secret = secret;
    return key;
}

+ (NSDictionary *)apiKeyFile {
    if (!apiKeyFile) {
        NSString *path = [[NSBundle mainBundle] pathForResource:API_KEYS_FILE ofType:@"plist"];
        NSAssert(path != nil, @"You must create a file with every api key, see UCApiKey class for more info.");
        
        apiKeyFile = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    }
    return apiKeyFile;
}

+ (NSString *)apiKeyFor:(NSString *)service {
    return [[self apiKeyFile] objectForKey:service];
}

+ (instancetype)OAuthApiKeyFor:(NSString *)service {
    NSDictionary *values = [[self apiKeyFile] objectForKey:service];
    return (values && values.count > 0) ? [self OauthApiKey:values[@"uid"] secret:values[@"secret"]] : nil;
}

@end
