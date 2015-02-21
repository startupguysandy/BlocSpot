//
//  SearchViewController.m
//  BlocSpot
//
//  Created by Andy Bradbury on 14/02/2015.
//  Copyright (c) 2015 Tin Bear Studios. All rights reserved.
//

#import "SearchViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SearchViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) MKLocalSearchResponse *results;
@property (strong, nonatomic) MKUserLocation *userLocation;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchQuery = searchBar.text;
    [self searchRequest:searchQuery];
}

- (void) searchRequest:(NSString *) searchInfo {
    // Create new search request
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchInfo;
    
    /*
      Need to make sure we have permission to use their location here
    */
    request.region = MKCoordinateRegionMakeWithDistance(_userLocation.location.coordinate, 2000, 2000);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Initiate new search
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        self.results = response;
        
        // Edge cases
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
        
        // Add the response we have to the results variable
        _results = response;
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.mapItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSInteger row = indexPath.row;
    
    MKMapItem *item = self.results.mapItems[row];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - Memory Warnings

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
