//
//  Locations+CoreDataProperties.h
//  Absent
//
//  Created by Gratia on 12/17/15.
//  Copyright © 2015 Gratia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Locations.h"

NS_ASSUME_NONNULL_BEGIN

@interface Locations (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) Run *running;

@end

NS_ASSUME_NONNULL_END
