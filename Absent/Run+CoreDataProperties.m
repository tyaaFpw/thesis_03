//
//  Run+CoreDataProperties.m
//  Absent
//
//  Created by Gratia on 11/26/15.
//  Copyright © 2015 Gratia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Run+CoreDataProperties.h"
#import "Locations.h"

@implementation Run (CoreDataProperties)

@dynamic timestamp;
@dynamic duration;
@dynamic distance;
@dynamic locations;
@dynamic locationOrderedSet;

@end
