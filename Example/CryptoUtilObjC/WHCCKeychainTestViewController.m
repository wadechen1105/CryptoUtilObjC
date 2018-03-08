//
//  WHCCKeychainTestViewController.m
//  CryptoUtilObjC_Example
//
//  Created by Wade H-C Chen on 2018/3/8.
//  Copyright © 2018年 wadechen1105@gmail.com. All rights reserved.
//

#import "WHCCKeychainTestViewController.h"

@interface WHCCKeychainTestViewController ()

@end

@implementation WHCCKeychainTestViewController {
    KeychainItem *keychain;
    
    __weak IBOutlet UITextField *inputdata;
    __weak IBOutlet UILabel *keychainStatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    keychain = [[KeychainItem alloc] initWithService:@"wade.test.service" forKey:@"wade.chen_2" accessGroup:nil];
    NSString* result = [keychain readKeyChainData];
    
    NSLog(@"viewWillAppear get keychain ---> %@", result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)saveData:(id)sender {
    BOOL r = [keychain updateKeyChainData: inputdata.text];
    if (r) {
        keychainStatus.text = @"add / update success!";
    } else {
        keychainStatus.text = @"add / update fail!";
    }
    NSLog(@"pwd: %@", inputdata.text);
}

- (IBAction)delData:(id)sender {
    BOOL r = [keychain deleteItem];
    
    if (r) {
        keychainStatus.text = @"del success!";
    } else {
        keychainStatus.text = @"del fail , no data should be del!";
    }
    
    NSLog(@"del succes? %d", r);
}

- (IBAction)getData:(id)sender {
    NSString* result = [keychain readKeyChainData];
    keychainStatus.text = result == nil ? @"pwd not found ": result;
    NSLog(@"pwd: %@", result);}
@end
