//
//  MainNavC.m
//  Absent
//
//  Created by Gratia on 11/10/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import "MainNavC.h"
#import "LoginVC.h"
#import "PedoHomeViewController.h"
#import "HeartCameraScreen.h"
#import "TestViewController.h"

@interface MainNavC ()

@property (nonatomic, strong) LoginVC *loginVC;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PedoHomeViewController *pedometerVC;
@property (nonatomic, strong) HeartCameraScreen *heartScreen;
@property (nonatomic, strong) TestViewController *testVC;

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
    self.pedometerVC = [[PedoHomeViewController alloc]initWithNibName:@"PedoHomeViewController" bundle:nil];
    [self presentViewController:self.pedometerVC animated:YES completion:nil];
}

- (IBAction)goingToHeartRateMenu:(id)sender {
//    self.heartScreen = [[HeartCameraScreen alloc]initWithNibName:@"HeartCameraScreen" bundle:nil];
//    [self presentViewController:self.heartScreen animated:YES completion:nil];
    
    self.testVC = [[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
    [self presentViewController:self.testVC animated:YES completion:nil];
}

- (IBAction)goingToMyHistoryMenu:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
