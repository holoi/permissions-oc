//
//  LocalNetworkAuthorization.h
//  permissions-oc
//
//  Created by Yuchen Zhang on 2022/4/20.
//

#import <Foundation/Foundation.h>

@interface LocalNetworkAuthorization : NSObject

- (void)checkAccessState:(void (^)(BOOL))completion;

@end
