//
//  HomeViewController.m
//  RunMaster
//
//  Created by Matt Luedke on 5/19/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "HomeViewController.h"
#import "NewRunViewController.h"
#import "PastRunsViewController.h"
#import "BadgesTableViewController.h"
#import "BadgeController.h"
#import "MainNavC.h"
#import <CoreData/CoreData.h>

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *runArray;
@property (nonatomic, strong) MainNavC *mainNav;

@end

@implementation HomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    //[self setUpNavigationBar];
}

- (void)setUpNavigationBar
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"aaa";
    label.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.text = @"Back";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (IBAction)backToAppsMainMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.mainNav = [[MainNavC alloc]init];
    //[self.mainNav saveContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
        
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    self.runArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if (self.navigationController.visibleViewController == self) {
        //[self performSegueWithIdentifier:@"thankyou" sender:self];
        UIViewController *nextController = [segue destinationViewController];
        if ([nextController isKindOfClass:[NewRunViewController class]]) {
            ((NewRunViewController *) nextController).managedObjectContext = self.managedObjectContext;
        } else if ([nextController isKindOfClass:[PastRunsViewController class]]) {
            ((PastRunsViewController *) nextController).runArray = self.runArray;
        } else if ([nextController isKindOfClass:[BadgesTableViewController class]]) {
            ((BadgesTableViewController *) nextController).earnStatusArray = [[BadgeController defaultController] earnStatusesForRuns:self.runArray];
        }
    //}
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
//    NSString *storePath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"Model.sqlite"];
//    
//    // set up the backing store
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    // If the expected store doesn't exist, copy the default store.
//    if (![fileManager fileExistsAtPath:storePath]) {
//        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"sqlite"];
//        if (defaultStorePath) {
//            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
//        }
//    }
//    
//    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
//    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    
    NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
 //       abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
