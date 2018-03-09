//
//  TouchIdUtil.h
//  Pods
//
//  Created by Wade H-C Chen on 2018/3/8.
//
@import Foundation;

@interface TouchIdUtil : NSObject

+ (BOOL)canEvaluatePolicy;
+ (void)evaluatePolicy;
+ (void)evaluatePolicy: (NSString*)description;

@end
