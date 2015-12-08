//
//  Run+CoreDataProperties.h
//  Absent
//
//  Created by Gratia on 11/26/15.
//  Copyright © 2015 Gratia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Run.h"

@class Locations;

NS_ASSUME_NONNULL_BEGIN

@interface Run (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) Locations *locations;
@property (nonatomic, retain) NSOrderedSet *locationOrderedSet;



@end

NS_ASSUME_NONNULL_END
