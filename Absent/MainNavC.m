//
//  MainNavC.m
//  Absent
//
//  Created by Gratia on 11/10/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import "MainNavC.h"
#import "LoginVC.h"
//#import "PedoHomeViewController.h"
#import "TestViewController.h"
#import "HomeViewController.h"
#import <CoreData/CoreData.h>

@interface MainNavC ()

@property (nonatomic, strong) LoginVC *loginVC;
@property (nonatomic, strong) UIImage *image;
//@property (nonatomic, strong) PedoHomeViewController *pedometerVC;
@property (nonatomic, strong) TestViewController *testVC;
@property (nonatomic, strong) HomeViewController *runHome;

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
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainRunNavC = (UINavigationController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    //[[self runHome]setManagedObjectContext:self.runHome.managedObjectContext];
    //UINavigationController *navigationController = (UINavigationController *)self;
//    self.runHome = [self.navigationController viewControllers][3];
//    
//    self.managedObjectContext = self.runHome.managedObjectContext;
//    [self saveContext];
    [self.navigationController pushViewController:mainRunNavC animated:YES];
//    self.pedometerVC = [[PedoHomeViewController alloc]initWithNibName:@"PedoHomeViewController" bundle:nil];
//    [self presentViewController:self.pedometerVC animated:YES completion:nil];
//    homeViewController.managedObjectContext = self.managedObjectContext;
}

- (IBAction)goingToHeartRateMenu:(id)sender {
//    self.heartScreen = [[HeartCameraScreen alloc]initWithNibName:@"HeartCameraScreen" bundle:nil];
//    [self presentViewController:self.heartScreen animated:YES completion:nil];
    
    self.testVC = [[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
    [self presentViewController:self.testVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
