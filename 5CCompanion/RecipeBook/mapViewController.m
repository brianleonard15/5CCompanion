//
//  mapViewController.m
//  claremontMap
//
//  Created by Brian on 3/1/14.
//  Copyright (c) 2014 Brian Leonard. All rights reserved.
//

#import "mapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface mapViewController () {
    NSMutableArray *geoObject;
}
@end
@implementation mapViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34.100974
                                                            longitude:-117.708947
                                                                 zoom:15];
    self.mapView.camera = camera;
    
    self.mapView.myLocationEnabled = YES;
    
    self.mapView.settings.myLocationButton = YES;
    
    self.searchResults = [NSMutableArray array];

    }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    return cell;
}

- (void)filterResults:(NSString *)searchTerm {
    
    //[self.searchResults removeAllObjects];
    [self.searchResults setArray:self.buildings];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchTerm];
    [self.searchResults filterUsingPredicate:resultPredicate];
    NSLog(@"search %@",self.searchResults);
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* markerTitle = [self.searchResults objectAtIndex:indexPath.row];
    NSLog(@"%@",markerTitle);
    GMSMarker *marker = [[GMSMarker alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Map"];
    [query whereKey:@"Building" equalTo:markerTitle];
    geoObject = [[query findObjects] mutableCopy];
    geoObject = [geoObject valueForKey:@"Location"];
    PFGeoPoint *geoPoint = [geoObject objectAtIndex:0];
    marker.position = CLLocationCoordinate2DMake(geoPoint.latitude,geoPoint.longitude);
    marker.title = markerTitle;
    marker.snippet = markerTitle;
    marker.map = self.mapView;
    [self.mapView setSelectedMarker:marker];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:geoPoint.latitude
                                                            longitude:geoPoint.longitude
                                                                 zoom:18];
    self.mapView.camera = camera;
    [self.searchDisplayController setActive:NO animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

@end
