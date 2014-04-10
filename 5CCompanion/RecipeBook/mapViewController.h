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

@interface mapViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {


}

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *buildings;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@end
