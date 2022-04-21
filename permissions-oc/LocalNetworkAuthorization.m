//
//  LocalNetworkAuthorization.m
//  permissions-oc
//
//  Created by Yuchen Zhang on 2022/4/20.
//

#import "LocalNetworkAuthorization.h"
#import <Network/Network.h>
#import <UIKit/UIKit.h>

@interface LocalNetworkAuthorization () <NSNetServiceDelegate>

@property (nonatomic) NSNetService *service;
@property (nonatomic) void (^completion)(BOOL);
@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL publishing;

@end

@implementation LocalNetworkAuthorization

- (instancetype)init {
    if (self = [super init]) {
        self.service = [[NSNetService alloc] initWithDomain:@"local." type:@"_permissions._tcp." name:@"LocalNetworkPrivacy" port:1100];
    }
    return self;
}

- (void)dealloc {
    [self.service stop];
}

- (void)checkAccessState:(void (^)(BOOL))completion {
    self.completion = completion;
    NSLog(@"Start to check local network permission");
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
//            NSLog(@"fuck");
            return;
        }
        
        if (self.publishing) {
            [self.timer invalidate];
            self.completion(NO);
        }
        else {
            self.publishing = YES;
            self.service.delegate = self;
            [self.service publish];
        }
    }];
}


#pragma mark - NSNetServiceDelegate

- (void)netServiceDidPublish:(NSNetService *)sender {
    [self.timer invalidate];
    self.completion(YES);
}

@end
