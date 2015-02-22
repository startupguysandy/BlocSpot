//
//  SearchViewController.h
//  BlocSpot
//
//  Created by Andy Bradbury on 14/02/2015.
//  Copyright (c) 2015 Tin Bear Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SearchViewController : UITableViewController <MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end