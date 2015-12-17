//
//  HeartCameraScreen.h
//  Absent
//
//  Created by Gratia on 12/8/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HeartCameraScreen : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *detectInfoBtn;
@property (strong, nonatomic) IBOutlet UIImageView *pictImgView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *frameValLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@end
