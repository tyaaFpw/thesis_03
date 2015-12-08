//
//  HeartCameraScreen.m
//  Absent
//
//  Created by Gratia on 12/8/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import "HeartCameraScreen.h"
#import "HeartRateObjModel.h"

@interface HeartCameraScreen ()

@property (nonatomic, strong) HeartRateObjModel *heartObject;

@end

@implementation HeartCameraScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupCameraView];
}

- (void)setupCameraView {
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UIView *cameraView = [[UIView alloc]initWithFrame:frame];
    cameraView.clipsToBounds = NO;
    
    [self.view addSubview:cameraView];
    self.heartObject = [[HeartRateObjModel alloc]initWithCameraView:cameraView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savingTheProgress:(id)sender {
}

- (IBAction)cancelingTheOperation:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
