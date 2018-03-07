//
//  KeychainItem.h
//  TestCkeyCjain
//
//  Created by Wade H-C Chen on 2018/3/2.
//  Copyright © 2018年 Wade H-C Chen. All rights reserved.
//

#ifndef KeychainItem_h
#define KeychainItem_h


#endif /* KeychainItem_h */
#import <Foundation/Foundation.h>
#import <Security/Security.h>

//Define an Objective-C wrapper class to hold Keychain Services code.
@interface KeychainItem : NSObject

- (id)initWithService: (NSString*)service forKey:(NSString*)key accessGroup:(NSString*)group;
- (NSString*) readKeyChainData; // query
- (BOOL )deleteItem; // del
- (BOOL) updateKeyChainData: (NSString*)encodeStrToData; // add or update

@end
