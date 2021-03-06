//
//  WHCCTouchIdTestViewController.m
//  CryptoUtilObjC_Example
//
//  Created by Wade H-C Chen on 2018/3/8.
//  Copyright © 2018年 wadechen1105@gmail.com. All rights reserved.
//

#import "WHCCTouchIdTestViewController.h"

@interface WHCCTouchIdTestViewController ()

@end

@implementation WHCCTouchIdTestViewController {
    __weak IBOutlet UILabel *text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear ***");
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
- (IBAction)handleTouchId:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0: {
            BOOL result = [TouchIdUtil canEvaluatePolicy];
            if(result) {
                text.text = @"Touch ID / Face ID is available";
            } else {
                text.text = @"[WARN] Touch ID / Face ID is unavailable";
            }
            break;
        }
        case 1:{
            [TouchIdUtil evaluatePolicy];
            break;
        }
        default:
            NSLog(@"Something Error");
            break;
    }
}

@end
