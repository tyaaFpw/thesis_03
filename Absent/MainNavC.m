//
//  MainNavC.m
//  Absent
//
//  Created by Gratia on 11/10/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import "MainNavC.h"
#import "LoginVC.h"

@interface MainNavC ()

@property (nonatomic, strong) LoginVC *loginVC;
@property (nonatomic, strong) UIImage *image;

@end

@implementation MainNavC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [self settingUpLabelUI];
    
    NSLog(@"%@", self.name);
    NSLog(@"%@", self.email);
    
    [self currentLoggedInUser];
}

- (void)settingUpLabelUI {
    self.facebookName.text = self.name;
    NSLog(@"%@", self.facebookName.text);
    
    self.facebookEmail.text = self.email;
    NSLog(@"%@", self.facebookEmail.text);
}

- (void)currentLoggedInUser {
    
    [self.view addSubview:self.loginVC.profilePictureView];
}

- (IBAction)backButtonTapped:(id)sender {
    NSLog(@"SHOULD bring back to previous controller");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)logoutButtonTapped:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc]init];
    [loginManager logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSLog(@"SHOULD Loging out the active FB acc");
}

- (IBAction)goingToPedometerMenu:(id)sender {
}

- (IBAction)goingToHeartRateMenu:(id)sender {
}

- (IBAction)goingToMyHistoryMenu:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
