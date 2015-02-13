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
@property (strong, nonatomic) MKLocalSearchResponse *results;
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
    
    // Set the mapView delegate as itself
    self.mapView.delegate = self;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000, 1000);

    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Create new search request
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Bank";
    request.region = region;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    // Initiate new search
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSMutableArray *annotations = [NSMutableArray array];
        
        [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem *item, NSUInteger idx, BOOL *stop) {
            
            // if we already have an annotation for this MKMapItem,
            // just return because you don't have to add it again
            
            for (id<MKAnnotation>annotation in mapView.annotations)
            {
                if (annotation.coordinate.latitude == item.placemark.coordinate.latitude &&
                    annotation.coordinate.longitude == item.placemark.coordinate.longitude)
                {
                    return;
                }
            }
            
            // otherwise, add it to our list of new annotations
            // ideally, I'd suggest a custom annotation or MKPinAnnotation, but I want to keep this example simple
            [annotations addObject:item.placemark];
        }];
        
        [mapView addAnnotations:annotations];
        
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        if ([response.mapItems count] == 0) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        _results = response;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
