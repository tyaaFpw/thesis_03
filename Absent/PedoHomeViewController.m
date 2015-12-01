//
//  PedoHomeViewController.m
//  Absent
//
//  Created by Gratia on 11/26/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import "PedoHomeViewController.h"
//#import "Run.h"
#import "Run+CoreDataProperties.h"
//#import "Locations.h"
#import "Locations+CoreDataProperties.h"
#import "MainNavC.h"
#import "MathCalculation.h"
#import <CoreLocation/CoreLocation.h>
//#import <AudioToolbox/AudioToolbox.h>
#import <MapKit/MapKit.h>

@interface PedoHomeViewController () <UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property int seconds;
@property float distance;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locationsMutable;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) Run *run;
@property (nonatomic, strong) MainNavC *mainHall;

@end

@implementation PedoHomeViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)settingUpAllAttributes {
    self.seconds = 0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(eachSecond) userInfo:nil repeats:YES];
    self.distance = 0;
    self.locationsMutable = [NSMutableArray array];
    
    
}

- (void)saveRunProgress {
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
    
    newRun.distance = [NSNumber numberWithFloat:self.distance];
    newRun.duration = [NSNumber numberWithInt:self.seconds];
    newRun.timestamp = [NSDate date];
    
    NSMutableArray *locationArray = [NSMutableArray array];
    for (CLLocation *location in self.locationsMutable) {
        Locations *objectLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
        
        objectLocation.timestamp = location.timestamp;
        objectLocation.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        objectLocation.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        [locationArray addObject:objectLocation];
    }
    
    newRun.locations = [NSOrderedSet orderedSetWithArray:locationArray];
    self.run = newRun;
}

- (void)eachSecond {
    self.seconds++;
    [self updateAllLabels];
}

- (void)startTheLocationUpdates {
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = 10;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)updateAllLabels {
    self.timeDurationLbl.text = [NSString stringWithFormat:@"Time: %@", [MathCalculation stringTheSecondCount:self.seconds inLongFormat:NO]];
    
    self.distanceLbl.text = [NSString stringWithFormat:@"Distance: %@", [MathCalculation stringTheDistance:self.distance]];
    
    self.paceLbl.text = [NSString stringWithFormat:@"Pace: %@", [MathCalculation stringAveragePaceFromDistance:self.distance overTime:self.seconds]];
}

#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    for (CLLocation *newLocation in locations) {
        NSDate *eventDate = newLocation.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        
        if (fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20) {
            if (self.locationsMutable.count > 0) {
                self.distance += [newLocation distanceFromLocation:self.locationsMutable.lastObject];
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.locationsMutable.lastObject).coordinate;
                coords[1] = newLocation.coordinate;
                
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                [self.mapView setRegion:region animated:YES];
                [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [self.locationsMutable addObject:newLocation];
        }
    }
}

#pragma mark -MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyline = (MKPolyline *)overlay;
        MKPolylineRenderer *polyRenderer = [[MKPolylineRenderer alloc]initWithPolyline:polyline];
        polyRenderer.strokeColor = [UIColor blueColor];
        polyRenderer.lineWidth = 3;
        
        return polyRenderer;
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
