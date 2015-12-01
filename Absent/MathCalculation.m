//
//  MathCalculation.m
//  Absent
//
//  Created by Gratia on 11/26/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import "MathCalculation.h"
#import "Locations+CoreDataProperties.h"
#import "MulticolorPolylineRoute.h"

static BOOL const isMetric = YES;
static float const meterinKM = 1000;
static float const meterInMiles = 1609.344;
static const int idealSmoothReachSize = 33;

@implementation MathCalculation

+ (NSString *)stringTheDistance: (float)meters {
    float divider;
    NSString *name;
    
    if (isMetric) {
        name = @"Km";
        divider = meterinKM;
    } else {
        name = @"miles";
        divider = meterInMiles;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", (meters / divider), name];
}

+ (NSString *)stringTheSecondCount: (int)seconds inLongFormat: (BOOL)longFormat {
    int remainingSecond = seconds;
    int hours = remainingSecond / 3600;
    remainingSecond = remainingSecond - hours * 3600;
    int minutes = remainingSecond / 60;
    remainingSecond = remainingSecond - minutes * 60;
    
    if (longFormat) {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSecond];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSecond];
        } else {
            return [NSString stringWithFormat:@"%isec", remainingSecond];
        }
    } else {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSecond];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSecond];
        } else {
            return [NSString stringWithFormat:@"00:%02i", remainingSecond];
        }
    }
}

+ (NSString *)stringAveragePaceFromDistance: (float)meters overTime:(int)seconds {
    
    if (seconds == 0 || meters == 0) {
        return @"0";
    }
    float avgPaceSecMeters = seconds / meters;
    
    float multiplier;
    NSString *name;
    
    if (isMetric) {
        name = @"min/Km";
        multiplier = meterinKM;
    } else {
        name = @"min/miles";
        multiplier = meterInMiles;
    }
    
    int paceMinutes = (int) ((avgPaceSecMeters * multiplier) / 60);
    int paceSeconds = (int) (avgPaceSecMeters * multiplier - (paceMinutes * 60));
    
    return [NSString stringWithFormat:@"%i:%02i %@", paceMinutes, paceSeconds, name];
}

+ (NSArray *)colorForLocations: (NSArray *)location {
    if (location.count == 1) {
        Locations *locations = [location firstObject];
        CLLocationCoordinate2D coords[2];
        coords[0].latitude = locations.latitude.doubleValue;
        coords[0].longitude = locations.longitude.doubleValue;
        coords[1].latitude = locations.latitude.doubleValue;
        coords[1].longitude = locations.longitude.doubleValue;
        
        MulticolorPolylineRoute *route = [MulticolorPolylineRoute polylineWithCoordinates:coords count:2];
        route.color = [UIColor blackColor];
        
        return @[route];
    }
    
    NSMutableArray *rawSpeeds = [NSMutableArray array];
    
    for (int i = 1; i < location.count; i++) {
        Locations *firstLocation = [location objectAtIndex:(i-1)];
        Locations *secondLocation = [location objectAtIndex:i];
        
        CLLocation *firstLocCL = [[CLLocation alloc]initWithLatitude:firstLocation.latitude.doubleValue longitude:firstLocation.longitude.doubleValue];
        CLLocation *secondLocCL = [[CLLocation alloc]initWithLatitude:secondLocation.latitude.doubleValue longitude:secondLocation.longitude.doubleValue];
        
        double distance = [secondLocCL distanceFromLocation:firstLocCL];
        double time = [secondLocation.timestamp timeIntervalSinceDate:firstLocation.timestamp];
        double speed = distance / time;
        
        [rawSpeeds addObject:[NSNumber numberWithDouble:speed]];
    }
    
    NSMutableArray *smoothSpeeds = [NSMutableArray array];
    for (int i = 1; i < rawSpeeds.count; i++) {
        int lowerBound = i - idealSmoothReachSize / 2;
        int upperBound = i + idealSmoothReachSize / 2;
        
        if (lowerBound < 0) {
            lowerBound = 0;
        }
        
        if (upperBound > ((int)rawSpeeds.count - 1)) {
            upperBound = (int)rawSpeeds.count - 1;
        }
        
        NSRange range;
        range.location = lowerBound;
        range.length = upperBound - lowerBound;
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray *relevantSpeeds = [rawSpeeds objectsAtIndexes:indexSet];
        double total = 0.0;
        
        for (NSNumber *speed in relevantSpeeds) {
            total += speed.doubleValue;
        }
        
        double smoothAverage = total / (double)(upperBound - lowerBound);
        [smoothSpeeds addObject:[NSNumber numberWithDouble:smoothAverage]];
    }
    
    NSArray *sortedArray = [smoothSpeeds sortedArrayUsingSelector:@selector(compare:)];
    double medianSpeed = ((NSNumber *)[sortedArray objectAtIndex:(location.count/2)]).doubleValue;
    
    // RGB for red (slowest)
    CGFloat r_red = 1.0f;
    CGFloat r_green = 20/255.0f;
    CGFloat r_blue = 44/255.0f;
    
    // RGB for yellow (middle)
    CGFloat y_red = 1.0f;
    CGFloat y_green = 215/255.0f;
    CGFloat y_blue = 0.0f;
    
    // RGB for green (fastest)
    CGFloat g_red = 0.0f;
    CGFloat g_green = 146/255.0f;
    CGFloat g_blue = 78/255.0f;
    
    NSMutableArray *colorSegment = [NSMutableArray array];
    
    for (int i = 1; i < location.count; i++) {
        Locations *firstLoc = [location objectAtIndex:(i-1)];
        Locations *secondLoc = [location objectAtIndex:i];
        
        CLLocationCoordinate2D coords[2];
        coords[0].latitude = firstLoc.latitude.doubleValue;
        coords[0].longitude = firstLoc.longitude.doubleValue;
        
        coords[1].latitude = secondLoc.latitude.doubleValue;
        coords[1].longitude = secondLoc.longitude.doubleValue;
        
        NSNumber *speed = [smoothSpeeds objectAtIndex:(i-1)];
        UIColor *color = [UIColor blackColor];
        
        // between red and yellow
        if (speed.doubleValue < medianSpeed) {
            NSUInteger index = [sortedArray indexOfObject:speed];
            double ratio = (int)index / ((int)location.count/2.0);
            CGFloat red = r_red + ratio * (y_red - r_red);
            CGFloat green = r_green + ratio * (y_green - r_green);
            CGFloat blue = r_blue + ratio * (y_blue - r_blue);
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
            
            // between yellow and green
        } else {
            NSUInteger index = [sortedArray indexOfObject:speed];
            double ratio = ((int)index - (int)location.count/2.0) / ((int)location.count/2.0);
            CGFloat red = y_red + ratio * (g_red - y_red);
            CGFloat green = y_green + ratio * (g_green - y_green);
            CGFloat blue = y_blue + ratio * (g_blue - y_blue);
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        }
        
        MulticolorPolylineRoute *polylineRoute = [MulticolorPolylineRoute polylineWithCoordinates:coords count:2];
        polylineRoute.color = color;
        
        [colorSegment addObject:polylineRoute];
    }
    
    return colorSegment;
}

@end
