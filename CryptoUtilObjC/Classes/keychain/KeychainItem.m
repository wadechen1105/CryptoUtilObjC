//
//  KeychainItem.m
//  TestCkeyCjain
//
//  Created by Wade H-C Chen on 2018/3/2.
//  Copyright © 2018年 Wade H-C Chen. All rights reserved.
//

#import "KeychainItem.h"

//Unique string used to identify the keychain item:
static const UInt8 kKeychainItemIdentifier[] = "com.apple.dts.KeychainUI\0";

@interface KeychainItem (PrivateMethods)

// throw Sec error
- (void) checkError: (OSStatus) status;

// setup query item
+ (NSMutableDictionary *)keychainQuery:(NSString*)service forKey:(NSString*)key accessGroup:(NSString*)group;

@end

@implementation KeychainItem {
    NSString* _service;
    NSString* _key;
    NSString* _group;
}

- (id)initWithService: (NSString*)service forKey:(NSString*)key accessGroup:(NSString*)group
{
    if((self = [super init])) {
        _service = service;
        _key = key;
        _group = group;
    };
    
    return self;
}

- (NSException*) getError: (NSString*) msg
{
    return [NSException
            exceptionWithName: @"Check keychain error."
            reason:msg
            userInfo:nil];
}

/// save keychain or update, if success return YES otherwise NO
- (BOOL) updateKeyChainData: (NSString*)encodeStrToData
{
    // Encode the string into an Data object.
    NSData* encodeData = [encodeStrToData dataUsingEncoding: NSUTF8StringEncoding];
    
    // get should query data
    NSMutableDictionary* item = [KeychainItem keychainQuery:_service forKey:_key accessGroup:_group];
    
    // query if data exist
    if([self readKeyChainData]){
        NSMutableDictionary* attrToUpdate = [NSMutableDictionary new];
        
        // add new keychain data
        [attrToUpdate setObject: (id)encodeData forKey: (__bridge id)kSecValueData];
        
        // You can update only a single keychain item at a time.
        OSStatus errorcode = SecItemUpdate((__bridge CFDictionaryRef)item,
                                           (__bridge CFDictionaryRef)attrToUpdate);
        NSAssert(errorcode == noErr, @"Couldn't update the Keychain Item." );
        return YES;
    } else {
        // not found, and add new
        [item setObject: (id)encodeData forKey:(__bridge id)kSecValueData];
        
        // Add a the new item to the keychain.
        // No previous item found; add the new item.
        // The new value was added to the keychainData dictionary in the mySetObject routine,
        // and the other values were added to the keychainData dictionary previously.
        // No pointer to the newly-added items is needed, so pass NULL for the second parameter:
        OSStatus errorcode = SecItemAdd((__bridge CFDictionaryRef)item, NULL);
        
        NSLog(@"[save data] error code : %d", errorcode);
    }
    return NO;
}

/// query keychain
- (NSString*) readKeyChainData
{
    /*
     Build a query to find the item that matches the service, account and
     access group.
     */
    
    NSMutableDictionary* query = [KeychainItem keychainQuery:_service forKey:_key accessGroup:_group];
    // Return the attributes of the first match only:
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    // Return the attributes of the keychain item (the password is
    // acquired in the secItemFormatToDictionary: method):
    [query setObject: (__bridge id)kCFBooleanTrue forKey: (__bridge id)kSecReturnData];
    
    OSStatus keychainErr = noErr;
    // query
    CFTypeRef result = NULL;
    // If the keychain item exists, return the attributes of the item:
    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)query,
                                      (CFTypeRef *)&result);
    
    @try {
        [self checkError: keychainErr];
        
        // remove kSecReturnData val, we dont need it
        [query removeObjectForKey:(__bridge id)kSecReturnData];
        
        // return data and convert to string
        NSString *resultData = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData *)result bytes] length:[(__bridge NSData *)result length] encoding:NSUTF8StringEncoding];
        
        [query setObject: resultData forKey:(__bridge id)kSecValueData];
        
        NSLog(@"query result : %@", query);
        
        return resultData;
    }
    @catch(NSException *e) {
        NSLog(@"ERROR --> %@", e.description);
        if (result) CFRelease(result);
        return nil;
    }
    
}

// del keychain data
- (BOOL) deleteItem
{
    NSMutableDictionary* query = [KeychainItem keychainQuery:_service forKey:_key accessGroup:_group];
    return (SecItemDelete((CFDictionaryRef)query) == errSecSuccess);
}

/// check keychain status
- (void) checkError: (OSStatus) status
{
    NSLog(@"check --> error code: %d", status);
    if (status == errSecSuccess) {
        // match success
        return;
    }
    
    // Don't do anything if nothing is found.
    if (status == errSecItemNotFound) {
        @throw [self getError:@"Nothing was found in the keychain.\n"];
    }
    // Any other error is unexpected.
    else
    {
        @throw [self getError: @"Serious error.\n"];
    }
}

+ (NSMutableDictionary*) keychainQuery:(NSString *)service forKey:(NSString *)key accessGroup:(NSString *)group
{
    NSMutableDictionary* query = [NSMutableDictionary new];
    // Set up the keychain search dictionary:
    query = [[NSMutableDictionary alloc] init];
    // This keychain item is a generic password.
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    // The kSecAttrGeneric attribute is used to store a unique string that is used
    // to easily identify and find this keychain item. The string is first
    // converted to an NSData object:
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
                                            length:strlen((const char *)kKeychainItemIdentifier)];
    [query setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    
    if(service != nil) {
        [query setObject:service forKey:(__bridge id)kSecAttrService];
    }
    
    if(key != nil) {
        [query setObject: (id)key forKey: (__bridge id)kSecAttrAccount];
    }
    
    if(group != nil) {
        [query setObject: (id)group forKey: (__bridge id)kSecAttrAccessGroup];
    }
    
    return query;
}

// unuse
+ (NSMutableArray<KeychainItem *> *) getkeychainItems: (NSString*)service accessGroup:(NSString*)group
{
    NSMutableDictionary* dic = [KeychainItem keychainQuery:service forKey:nil accessGroup:group];
    // Return the attributes of the first match only:
    [dic setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    // Return the attributes of the keychain item (the password is
    // acquired in the secItemFormatToDictionary: method):
    [dic setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    [dic setObject: (__bridge id)kCFBooleanFalse forKey: (__bridge id)kSecReturnData];
    
    // Try to fetch the existing keychain item that matches the query.
    CFMutableDictionaryRef outDictionary = NULL;
    // If the keychain item exists, return the attributes of the item:
    OSStatus keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)dic,
                                               (CFTypeRef *)&outDictionary);
    
    NSMutableArray<KeychainItem *> *items = [[NSMutableArray alloc] init];
    
    if(keychainErr == noErr) {
        NSMutableArray<NSMutableDictionary *> *resultData = (__bridge_transfer NSMutableArray *) outDictionary;
        for (NSMutableDictionary* dic in resultData) {
            NSString* account = [dic objectForKey:(__bridge id)kSecAttrAccount];
            NSLog(@"account = %@",account);
            if(account) {
                KeychainItem* item = [[KeychainItem alloc] initWithService:service forKey:account accessGroup:group];
                [items addObject:item];
            }
        }
        
    } else {
        if (outDictionary) CFRelease(outDictionary);
        NSLog(@"No items in keychain");
    }
    
    return items;
}

@end
