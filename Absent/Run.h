//
//  Run.h
//  Absent
//
//  Created by Gratia on 11/26/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Locations;

NS_ASSUME_NONNULL_BEGIN

@interface Run : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)insertObject:(Locations *)value inLocationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLocationsAtIndex:(NSUInteger)idx;
- (void)insertLocations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLocationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLocationsAtIndex:(NSUInteger)idx withObject:(Locations *)value;
- (void)replaceLocationsAtIndexes:(NSIndexSet *)indexes withLocations:(NSArray *)values;
- (void)addLocationsObject:(Locations *)value;
- (void)removeLocationsObject:(Locations *)value;
- (void)addLocations:(NSOrderedSet *)values;
- (void)removeLocations:(NSOrderedSet *)values;

@end

NS_ASSUME_NONNULL_END

#import "Run+CoreDataProperties.h"
