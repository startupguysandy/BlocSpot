//
//  MapViewController.m
//  BlocSpot
//
//  Created by Andy Bradbury on 11/02/2015.
//  Copyright (c) 2015 Tin Bear Studios. All rights reserved.
//

#import "MapViewController.h"
#import "SearchViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set up locationManager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
	// Start Updating location
    [self.locationManager startUpdatingLocation];
    
    // Set the mapView delegate as itself and disable user tracking
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeNone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    if (self.POI != nil)
    {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        
        // Set coordinates of annotation
        [annotation setCoordinate: self.POI.placemark.coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1500, 1500);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
        // Set additional annotation detail
        [annotation setTitle:self.POI.name]; // We can set the subtitle too
        
        [self.mapView addAnnotation: annotation]; // Place the annotation on the map
    } else {
        self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
