//
//  HeartCounterMainHall.m
//  Absent
//
//  Created by Gratia on 12/8/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import "HeartCounterMainHall.h"

@interface HeartCounterMainHall ()

@end

@implementation HeartCounterMainHall

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMainHall:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
