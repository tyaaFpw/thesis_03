//
//  TestViewController.h
//  Absent
//
//  Created by Gratia on 12/17/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *detectInfoLbl;
@property (weak, nonatomic) IBOutlet UIImageView *infoImgView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *rateValLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
