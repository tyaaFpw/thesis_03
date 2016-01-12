//
//  MainNavC.h
//  Absent
//
//  Created by Gratia on 11/10/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MainNavC : UIViewController

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *accountID;

@property (weak, nonatomic) IBOutlet UILabel *facebookName;
@property (weak, nonatomic) IBOutlet UILabel *facebookEmail;
@property (weak, nonatomic) IBOutlet UIImageView *facebookProfilePict;
@property (weak, nonatomic) IBOutlet UIButton *pedoBtn;
@property (weak, nonatomic) IBOutlet UIButton *heartBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@property (nonatomic, strong) FBSDKProfilePictureView *profilePictureView;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
