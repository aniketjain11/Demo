//
//  HttpService.m
//  Demo
//
//  Created by Aniket Jain on 16/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import "HttpService.h"
#import <AFNetworking.h>

#define HOST @"demohost"


@implementation HttpService{
    AFHTTPSessionManager *demoServices;
}

+ (id) instance {
    static HttpService *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}
- (id)init
{
    self = [super init];
    if (self) {
        
        demoServices = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HOST] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        demoServices.requestSerializer = [AFHTTPRequestSerializer serializer];
        demoServices.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

@end
