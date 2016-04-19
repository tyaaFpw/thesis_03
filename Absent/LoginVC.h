//
//  LoginVC.h
//  Absent
//
//  Created by Triyakom PT on 4/1/16.
//  Copyright © 2016 Gratia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginVC : UIViewController

@property (weak, nonatomic)IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic)IBOutlet UIButton *gmailBtn;
@property (nonatomic, strong)NSString *userID;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *userEmail;
@property (nonatomic, strong)NSString *pictureURL;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong) FBSDKProfilePictureView *profilePictureView;

@end
