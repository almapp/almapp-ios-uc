//
//  UCExternalApiTests.m
//  AlmappUC
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UCApiKey.h"

@interface UCExternalApiTests : XCTestCase

@end

@implementation UCExternalApiTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGoogleMapsApiKey {
    [self testApiKeyFor:kGoogleMapsApiKey];
}

- (void)testApiKeyFor:(NSString*)service {
    NSString* key = [UCApiKey apiKeyFor:service];
    NSString* message = [NSString stringWithFormat:@"If this is returning nil, you are missing %@.plist file.", API_KEYS_FILE];
    NSLog(@"Api key for %@: %@", service, key);
    XCTAssertNotNil(key, @"%@", message);
    XCTAssert(key.length != 0, @"NSString must not be empty");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
