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
    TouchIdUtil *touchid;
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
        case 0:
            [touchid canEvaluatePolicy];
            break;
        case 1:
            NSLog(@"I'm B");
            break;
        default:
            NSLog(@"Something Error");
            break;
    }
}

@end
