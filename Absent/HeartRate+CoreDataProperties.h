//
//  HeartRate+CoreDataProperties.h
//  Absent
//
//  Created by Gratia on 12/17/15.
//  Copyright © 2015 Gratia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HeartRate.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeartRate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *heartratevalue;
@property (nullable, nonatomic, retain) NSSet<UserFB *> *userRate;

@end

@interface HeartRate (CoreDataGeneratedAccessors)

- (void)addUserRateObject:(UserFB *)value;
- (void)removeUserRateObject:(UserFB *)value;
- (void)addUserRate:(NSSet<UserFB *> *)values;
- (void)removeUserRate:(NSSet<UserFB *> *)values;

@end

NS_ASSUME_NONNULL_END
