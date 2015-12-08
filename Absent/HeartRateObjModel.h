//
//  HeartRateObjModel.h
//  Absent
//
//  Created by Gratia on 12/8/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HeartRateDetectionModelDelegate

- (void)heartRateStart;
- (void)heartRateUpdate:(int)bpm atTime:(int)seconds;
- (void)heartRateEnd;

@end

@interface HeartRateObjModel : NSObject

@property (nonatomic, weak) id<HeartRateDetectionModelDelegate> delegate;

- (void)startDetection;
- (void)stopDetection;
- (instancetype)initWithCameraView:(UIView *)view;

@end

