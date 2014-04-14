//
//  mapViewController.h
//  claremontMap
//
//  Created by Brian on 3/1/14.
//  Copyright (c) 2014 Brian Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "Place.h"

@interface mapViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, GMSMapViewDelegate> // Add this if you haven't
{

}


@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *buildings;
@property (nonatomic, strong) Place *tappedBuilding;
@property (nonatomic, strong) NSMutableArray *markers;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@end
