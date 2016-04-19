//
//  LoginVC.m
//  Absent
//
//  Created by Triyakom PT on 4/1/16.
//  Copyright © 2016 Gratia. All rights reserved.
//

#import "LoginVC.h"
#import "MainNavC.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface LoginVC ()

@property (nonatomic, strong)MainNavC *mainHall;
@property (nonatomic, strong)AppDelegate *appDelegate;
@property (nonatomic, strong)UINavigationController *navigationC;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self navigationController]setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchingUserInfo {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is Available:%@", [[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, email, picture.type(normal)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error) {
                NSLog(@"Results:%@", result);
                
                self.userEmail = [result objectForKey:@"email"];
                self.userID = [result objectForKey:@"id"];
                self.userName = [result objectForKey:@"name"];
                self.pictureURL = [NSString stringWithFormat:@"%@", [result objectForKey:@"picture"]];
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pictureURL]];
                
                self.mainHall.facebookProfilePict.image = [UIImage imageWithData:data];
                self.mainHall.profilePictureView = [[FBSDKProfilePictureView alloc]initWithFrame:self.mainHall.facebookProfilePict.frame];
                
                if (self.userEmail.length > 0) {
                    NSLog(@"%@", self.userName);
                    NSLog(@"%@", self.userEmail);
                    NSLog(@"%@", self.userID);
                    
                    self.mainHall = [[MainNavC alloc]initWithNibName:@"MainNavC" bundle:nil];
                    self.mainHall.name = self.userName;
                    self.mainHall.email = self.userEmail;
                    self.mainHall.accountID = self.userID;
                    
                    [self.navigationController pushViewController:self.mainHall animated:YES];
                } else {
                    NSLog(@"Facebook email is not verified yet..!!");
                }
            } else {
                NSLog(@"ERROR: %@", error);
            }
        }];
    }
}

- (IBAction)didTappedFacebookButton:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc]init];
    [loginManager logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if ([FBSDKAccessToken currentAccessToken]) {
            NSLog(@"Token is available: %@", [[FBSDKAccessToken currentAccessToken]tokenString]);
            
            [self fetchingUserInfo];
        } else {
            [loginManager logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                    NSLog(@"Login process error. Desc: %@", error);
                } else if (result.isCancelled) {
                    NSLog(@"User Cancelled login");
                } else {
                    NSLog(@"Login Success..!!");
                }
                
                if ([result.grantedPermissions containsObject:@"email"]) {
                    NSLog(@"result is: %@", result);
                    if (result.token) {
                        [self fetchingUserInfo];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"Facebook email permission error..!!"];
                    }
                }
            }];
        }
    }];
}

- (IBAction)didTappedGmailBtn:(id)sender {
}

@end
