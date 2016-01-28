//
//  TestViewController.m
//  Absent
//
//  Created by Gratia on 12/17/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import "HeartRateViewController.h"
#import "PulseDetector.h"
#import "Filter.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, CURRENT_STATE) {
    STATE_PAUSED,
    STATE_SAMPLING
};

#define MIN_FRAMES_FOR_FILTER_TO_SETTLE 10

@interface HeartRateViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDevice *camera;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) PulseDetector *pulseDetector;
@property (nonatomic, strong) Filter *filter;
@property (nonatomic, assign) CURRENT_STATE currentState;
@property (nonatomic, assign) int validFrameCounter;

@end

@implementation HeartRateViewController
{
    BOOL TimerBool;
    NSTimer *timer;
    BOOL PubNubBool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingUpDetectionModel];
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self resume];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self pause];
}

- (IBAction)backToPreviousPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savingDetection:(id)sender {
}

- (void)settingUpDetectionModel {
    self.filter = [[Filter alloc]init];
    self.pulseDetector = [[PulseDetector alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTheOperation:(id)sender {
    if ([_startBtn.currentTitle isEqualToString:@"Start"]) {
        
        [_startBtn setTitle:@"Stop" forState:UIControlStateNormal];
        [self startCameraCapture];
        PubNubBool=NO;
    } else{
        
        [_startBtn setTitle:@"Start" forState:UIControlStateNormal];
        [timer invalidate];
        [self stopCameraCapture];
        self.detectInfoLbl.text=@"Please start reading";
    }
}

// start capturing frames
-(void) startCameraCapture {
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                             target: self
                                           selector:@selector(BlinkingMethod)
                                           userInfo: nil repeats:YES];
    
    // Create the AVCapture Session
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // Get default camera device
    self.camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // switch to torch mode
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOn;
        // set the minimum acceptable frame
        [self.camera setActiveVideoMinFrameDuration:CMTimeMake(1, 10)];
        [self.camera setActiveVideoMaxFrameDuration:CMTimeMake(1, 10)];
        [self.camera unlockForConfiguration];
    }
    
    // Create a AVCaptureInput with the camera device
    NSError *error=nil;
    
    AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.camera error:&error];
    if (cameraInput == nil) {
        NSLog(@"Error to create camera capture:%@",error);
    }
    
    // Set output
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // create queue to run the capture on
    dispatch_queue_t captureQueue= dispatch_queue_create("captureQueue", NULL);
    
    // setup ourself up as the capture delegate
    [videoOutput setSampleBufferDelegate:self queue:captureQueue];
    
    // configure the pixel format
    videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey, nil];
    
    // sizing the frames.. use the smallest frame size available
    [self.captureSession setSessionPreset:AVCaptureSessionPresetLow];
    
    // Add input and output
    [self.captureSession addInput:cameraInput];
    [self.captureSession addOutput:videoOutput];
    
    // Start session
    [self.captureSession startRunning];
    
    // get the sampling from the camera
    self.currentState=STATE_SAMPLING;
    
    // awake application from sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // update UI on a timer every 0.1 seconds
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

-(void) stopCameraCapture {
    
    [self.captureSession stopRunning];
    self.captureSession = nil;
}

#pragma mark Pause and Resume of pulse detection
-(void) pause {
    
    if(self.currentState==STATE_PAUSED) return;
    
    // switch off torch
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOff;
        [self.camera unlockForConfiguration];
    }
    self.currentState=STATE_PAUSED;
    // let the application sleep if the phone is idle
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

-(void) resume {
    
    if(self.currentState!=STATE_PAUSED) return;
    
    // switch on the torch
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.camera lockForConfiguration:nil];
        [self.camera unlockForConfiguration];
    }
    self.currentState=STATE_SAMPLING;
    // stop the app from sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}

// r,g,b values are from 0 to 1 // h = [0,360], s = [0,1], v = [0,1]
//	if s == 0, then h = -1 (undefined)
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ) {
    
    float min, max, delta;
    min = MIN( r, MIN(g, b ));
    max = MAX( r, MAX(g, b ));
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        // r = g = b = 0
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h=2+(b-r)/delta;
    else
        *h=4+(r-g)/delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // if paused don't do anything
    if(self.currentState==STATE_PAUSED) {
        // reset frame counter
        self.validFrameCounter=0;
        return;
    }
    
    // image buffer
    CVImageBufferRef cvimgRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the image buffer
    CVPixelBufferLockBaseAddress(cvimgRef,0);
    // access the data
    size_t width=CVPixelBufferGetWidth(cvimgRef);
    size_t height=CVPixelBufferGetHeight(cvimgRef);
    // get the raw image bytes
    uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);
    size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef);
    // pull out the average rgb value of the frame
    float r=0,g=0,b=0;
    
    for(int y=0; y<height; y++) {
        for(int x=0; x<width*4; x+=4) {
            b+=buf[x];
            g+=buf[x+1];
            r+=buf[x+2];
        }
        buf+=bprow;
    }
    r/=255*(float) (width*height);
    g/=255*(float) (width*height);
    b/=255*(float) (width*height);
    
    // convert from rgb to hsv colourspace
    float h,s,v;
    RGBtoHSV(r, g, b, &h, &s, &v);
    // do sanity check to see if a finger is placed over the camera
    if(s>0.5 && v>0.5) {
        
        
        NSLog(@"RatePulse: %@",self.detectInfoLbl.text);
        
        // increment the valid frame count
        self.validFrameCounter++;
        // filter the hue value - a simple band pass filter, removes any DC component and high frequency noise
        float filtered=[self.filter processValue:h];
        // check the collection of the frame for filter
        if(self.validFrameCounter > MIN_FRAMES_FOR_FILTER_TO_SETTLE) {
            // add new value to pulse detector
            [self.pulseDetector addNewValue:filtered atTime:CACurrentMediaTime()];
        }
        
        TimerBool=YES;
        
        
    } else {
        
        
        TimerBool=NO;
        
        
        
        self.validFrameCounter = 0;
        // clear the pulse detector
        [self.pulseDetector reset];
    }
}

-(void)BlinkingMethod{
    
    if (!TimerBool) { [_infoImgView setImage:[UIImage imageNamed:@"Black1_heart.png"]];
        self.detectInfoLbl.text=@"PLACE FINGER ON CAMERA LENS";
        return; }
    
    if ([self.detectInfoLbl.text isEqualToString:@"DETECTING PULSE ...         "]||[self.detectInfoLbl.text isEqualToString:@"PLACE FINGER ON CAMERA LENS"]) {
        self.detectInfoLbl.text=@"DETECTING PULSE ...         ";
    }
    
    
    
    UIImage *picture = [UIImage imageNamed:@"Black1_heart.png"];
    
    if ([_infoImgView.image isEqual:picture] ) {
        
        [_infoImgView setImage:[UIImage imageNamed:@"Red_heart.png"]];
    }else{
        
        [_infoImgView setImage:[UIImage imageNamed:@"Black1_heart.png"]];
    }
}

-(void) update {
    
    self.rateValLbl.text = [NSString stringWithFormat:@"Captured Frames: %d%%", MIN(100, (100 * self.validFrameCounter)/MIN_FRAMES_FOR_FILTER_TO_SETTLE)];
    
    
    
    // if paused dont do anything
    if(self.currentState==STATE_PAUSED) return;
    
    // get average period of the pulse rate from the pulse detector
    float avePeriod = [self.pulseDetector getAverage];
    if(avePeriod == INVALID_PULSE_PERIOD) {
        // no value available
        
    } else {
        // got a value
        
        float pulse=60.0/avePeriod;
        self.detectInfoLbl.text=[NSString stringWithFormat:@"%0.0f", pulse];
        
        if (!PubNubBool) {
            [self result:self.detectInfoLbl.text];
        }
    }
}

- (void)result:(NSString *)pulseRate {
    [self stopCameraCapture];
    
    [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
    [timer invalidate];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ bpm", pulseRate] message:@"Are you satisfy enough?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)savingTheOperation:(id)sender {
}

- (IBAction)cancellingTheOperation:(id)sender {
}


@end
