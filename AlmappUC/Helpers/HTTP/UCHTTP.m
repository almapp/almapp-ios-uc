//
//  UCHTTP.m
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCHTTP.h"
#import "Ono.h"


@implementation UCHTTP

- (AFHTTPRequestOperationManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [AFHTTPRequestOperationManager manager];
        _requestManager.responseSerializer = [AFCompoundResponseSerializer serializer];
        _requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    return _requestManager;
}

- (PMKPromise *)loginToMainWebServiceWith:(ALMCredential *)credential {
    [self activeCookies];
    
    NSString *url = @"https://sso.uc.cl/cas/login";
    NSString *headUrl = @"https://portal.uc.cl/";
    
    __weak __typeof(self) weakSelf = self;
    
    [self.requestManager HEAD:headUrl parameters:nil success:^(AFHTTPRequestOperation *operation) {
        NSInteger code = operation.response.statusCode;
        NSLog(@"Status code for mainservice: %d", (int)code);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger code = operation.response.statusCode;
        NSLog(@"Status code for mainservice: %d", (int)code);
    }];
    
    return [self.requestManager GET:url parameters:nil].then(^(id responseObject, AFHTTPRequestOperation *operation) {
        [self addCookiesFromOperation:operation onUrl:url];
        
        NSError *error;
        
        ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithData:responseObject error:&error];
        ONOXMLElement *form = [document firstChildWithCSS:@"#fm1"];
        
        NSString *token = [form firstChildWithXPath:@"//input[@name='lt']"][@"value"];
        NSString *execution = [form firstChildWithXPath:@"//input[@name='execution']"][@"value"];
        NSString *eventId = [form firstChildWithXPath:@"//input[@name='_eventId']"][@"value"];
        
        NSDictionary *params = @{@"username"    : credential.username,
                                 @"password"    : credential.password,
                                 @"execution"   : execution,
                                 @"lt"          : token,
                                 @"_eventId"    : eventId};
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf.requestManager POST:url parameters:params];
        
    }).then(^(__unused id responseObject, AFHTTPRequestOperation *operation) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf addCookiesFromOperation:operation onUrl:url];
        }
        
    }).catch(^(NSError *error){
        NSLog(@"error happened: %@", error.localizedDescription);
        NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
    });
}

- (PMKPromise *)loginToWebMail:(ALMCredential *)credential {
    NSString *url = @"https://webaccess.uc.cl/";
    // NSString *url = @"https://webaccess.uc.cl/simplesaml/module.php/core/loginuserpass.php";
    
    __weak __typeof(self) weakSelf = self;
    
    return [self.requestManager GET:url parameters:nil].then(^(id responseObject, AFHTTPRequestOperation *operation) {
        [self addCookiesFromOperation:operation onUrl:url];
        
        NSDictionary *params = @{@"username"    : credential.username,
                                 @"password"    : credential.password,
                                 @"bsubmit"   : @"Iniciar Sesión",
                                 @"reset"          : @"Limpiar",
                                 @"_"    : @"",
                                 @"just_logged_in" : @"1",
                                 @"js_autodetect_results" : @"0",
                                 @"secretkey" : @"",
                                 @"login_username" : @"0",
                                 @"trusted" : @"0",
                                 @"forcedownlevel" : @"1",
                                 @"flags" : @"0", };
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf.requestManager POST:url parameters:params];
        
    }).then(^(__unused id responseObject, AFHTTPRequestOperation *operation) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf addCookiesFromOperation:operation onUrl:url];
        }
        
        // NSString* encodedString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        // NSLog(@"%@", encodedString);
        
    }).catch(^(NSError *error){
        NSLog(@"error happened: %@", error.localizedDescription);
        NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
    });
}

- (PMKPromise *)loginToSiding:(ALMCredential *)credential {
    NSString *sidingUrl = @"https://intrawww.ing.puc.cl/siding/index.phtml";
    NSDictionary *params = @{@"login" : credential.username,
                             @"passwd" : credential.password,
                             @"sw" : @"",
                             @"sh" : @"",
                             @"cd" : @""};
    
    __weak __typeof(self) weakSelf = self;
    
    return [self.requestManager POST:sidingUrl parameters:params].then(^(id responseObject, AFHTTPRequestOperation *operation) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf addCookiesFromOperation:operation onUrl:sidingUrl];
        }
    });
}

- (PMKPromise *)loginToLabmat:(ALMCredential *)credential {
    NSString *labmatUrl = @"http://www.labmat.puc.cl/index.php";
    NSDictionary *params = @{@"accion" : @"ingreso",
                             @"usuario" : credential.email,
                             @"clave" : credential.password};
    
    __weak __typeof(self) weakSelf = self;
    
    return [self.requestManager POST:labmatUrl parameters:params].then(^(id responseObject, AFHTTPRequestOperation *operation) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf addCookiesFromOperation:operation onUrl:labmatUrl];
        }
    });
}


- (void)activeCookies {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
}

- (void)addCookiesFromOperation:(AFHTTPRequestOperation *)operation onUrl:(NSString *)url {
    NSHTTPURLResponse *response = operation.response;
    NSArray* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:url]];
    [self addCookies:cookies];
}

- (void)addCookies:(NSArray *)cookies {
    for (NSHTTPCookie *cookie in cookies) {
        [self addCookie:cookie];
    }
}

- (void)addCookie:(NSHTTPCookie *)cookie {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

@end
