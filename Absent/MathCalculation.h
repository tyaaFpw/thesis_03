//
//  MathCalculation.h
//  Absent
//
//  Created by Gratia on 11/26/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathCalculation : NSObject

+ (NSString *)stringTheDistance: (float)meters;
+ (NSString *)stringTheSecondCount: (int)seconds inLongFormat: (BOOL)longFormat;
+ (NSString *)stringAveragePaceFromDistance: (float)meters overTime:(int)seconds;
+ (NSArray *)colorForLocations: (NSArray *)location;

@end
