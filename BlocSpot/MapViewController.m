//
//  MapViewController.m
//  BlocSpot
//
//  Created by Andy Bradbury on 11/02/2015.
//  Copyright (c) 2015 Tin Bear Studios. All rights reserved.
//

#import "MapViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000, 1000);

    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    MKLocalSearchRequest* request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = @"Coffee";
    request.region = region;
    
    MKLocalSearch* search = [[MKLocalSearch alloc] initWithRequest:request];
    

    [search startWithCompletionHandler:^(MKLocalSearchResponse* response, NSError* error){
        // Need ti perform the actual search here
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
