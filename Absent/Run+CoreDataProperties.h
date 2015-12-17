//
//  Run+CoreDataProperties.h
//  Absent
//
//  Created by Gratia on 12/17/15.
//  Copyright © 2015 Gratia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Run.h"

NS_ASSUME_NONNULL_BEGIN

@interface Run (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) Locations *locations;
@property (nullable, nonatomic, retain) NSSet<UserFB *> *userRunning;

@end

@interface Run (CoreDataGeneratedAccessors)

- (void)addUserRunningObject:(UserFB *)value;
- (void)removeUserRunningObject:(UserFB *)value;
- (void)addUserRunning:(NSSet<UserFB *> *)values;
- (void)removeUserRunning:(NSSet<UserFB *> *)values;

@end

NS_ASSUME_NONNULL_END
