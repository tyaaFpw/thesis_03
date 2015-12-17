//
//  UserFB+CoreDataProperties.h
//  Absent
//
//  Created by Gratia on 12/17/15.
//  Copyright © 2015 Gratia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserFB.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserFB (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *heartRating;
@property (nullable, nonatomic, retain) NSSet<Run *> *pedometering;

@end

@interface UserFB (CoreDataGeneratedAccessors)

- (void)addHeartRatingObject:(NSManagedObject *)value;
- (void)removeHeartRatingObject:(NSManagedObject *)value;
- (void)addHeartRating:(NSSet<NSManagedObject *> *)values;
- (void)removeHeartRating:(NSSet<NSManagedObject *> *)values;

- (void)addPedometeringObject:(Run *)value;
- (void)removePedometeringObject:(Run *)value;
- (void)addPedometering:(NSSet<Run *> *)values;
- (void)removePedometering:(NSSet<Run *> *)values;

@end

NS_ASSUME_NONNULL_END
