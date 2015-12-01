//
//  PedoHomeViewController.h
//  Absent
//
//  Created by Gratia on 11/26/15.
//  Copyright © 2015 Gratia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PedoHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeDurationLbl;
@property (weak, nonatomic) IBOutlet UILabel *paceLbl;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
