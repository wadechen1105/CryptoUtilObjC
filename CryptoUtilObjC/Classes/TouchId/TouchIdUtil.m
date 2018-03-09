//
//  TouchIdUtil.m
//  CryptoUtilObjC
//
//  Created by Wade H-C Chen on 2018/3/8.
//

#import "TouchIdUtil.h"
@import UIKit;
@import LocalAuthentication;

@implementation TouchIdUtil

- (BOOL)canEvaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    __block  NSString *message;
    NSError *error;
    BOOL success;
    
    // test if we can evaluate the policy, this test will tell us if Touch ID is available and enrolled
    success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (success) {
        message = [NSString stringWithFormat:@"Touch ID / Face ID is available"];
    }
    else {
        message = [NSString stringWithFormat:@"Touch ID / Face ID is not available --> %@", error.description];
    }
    
    NSLog(@"can evaluate? %@", message);
    return success;
}

- (void)evaluatePolicy
{
    [self evaluatePolicy:@""];
}

- (void)evaluatePolicy: (NSString*)description
{
    LAContext *context = [[LAContext alloc] init];
    __block NSString* message;
    
    // Show the authentication UI with our reason string.
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:description reply:^(BOOL success, NSError *authenticationError) {
        if (success) {
            message =  @"evaluatePolicy: succes";
        }
        else {
            message = [NSString stringWithFormat:@"evaluatePolicy: %@", authenticationError.localizedDescription];
        }
        
    }];
    NSLog(@"can evaluate? %@", message);
}

@end
