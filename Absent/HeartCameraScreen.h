//
//  HeartCameraScreen.h
//  Absent
//
//  Created by Gratia on 12/8/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartCameraScreen : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *cameraScreen;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeCounterLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
