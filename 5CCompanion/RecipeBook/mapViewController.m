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
#import "Place.h"
#import "PlaceDetailViewController.h"


@interface mapViewController ()

@end

@implementation mapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34.100974
                                                            longitude:-117.708947
                                                                 zoom:15];
    self.mapView.camera = camera;
    
    _mapView.delegate=self; 
    
    self.mapView.myLocationEnabled = YES;
    
    self.mapView.settings.myLocationButton = YES;
    
    self.searchResults = [NSMutableArray array];
    
    self.markers = [NSMutableArray array];
    
    for (Place *place in self.buildings) {
        PFGeoPoint *geoPoint = place.location;
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(geoPoint.latitude,geoPoint.longitude);
        marker.title = place.name;
        marker.snippet = place.name;
        marker.icon = nil;
        //marker.map = self.mapView;
        [self.markers addObject:marker];
    }
    
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
    Place *result = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = result.name;
    return cell;
}

- (void)filterResults:(NSString *)searchTerm {
    
    //[self.searchResults removeAllObjects];
    [self.searchResults setArray:self.buildings];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchTerm];
    [self.searchResults filterUsingPredicate:resultPredicate];
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *resultMarkers = [NSArray array];
    Place *result = [self.searchResults objectAtIndex:indexPath.row];
    NSString* markerTitle = result.name;
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title == %@", markerTitle];
    resultMarkers = [self.markers filteredArrayUsingPredicate:resultPredicate];
    GMSMarker *resultMarker = [resultMarkers objectAtIndex:0];
    
    [self.mapView setSelectedMarker:resultMarker];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:resultMarker.position.latitude
                                                            longitude:resultMarker.position.longitude
                                                                 zoom:18];
    self.mapView.camera = camera;
    [self.searchDisplayController setActive:NO animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSPredicate *tapInfoPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", marker.title];
    NSArray *filteredBuildings = [NSArray array];
    filteredBuildings = [[self.buildings filteredArrayUsingPredicate:tapInfoPredicate]mutableCopy];
    self.tappedBuilding = [filteredBuildings objectAtIndex:0];
    if ([@"DiningEateryGymPoolOther" rangeOfString:self.tappedBuilding.tab].location != NSNotFound) {
        [self performSegueWithIdentifier:@"showMapDetailView" sender:self];
    }
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    if (self.mapView.camera.zoom >= 17) {
        for (GMSMarker *marker in self.markers)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            label.text = marker.title;
            //float fontSize = (self.mapView.camera.zoom - 9) + (self.mapView.camera.zoom - 17)*4;
            float fontSize = 8;
            label.font = [UIFont fontWithName:@"AvenirNext-Regular" size:fontSize];
            label.numberOfLines = 0;
            [label sizeToFit];
            //grab it
            UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [label.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage * icon = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            marker.icon = icon;
            marker.map = self.mapView;
        }
    }
    else {
            [self.mapView clear];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMapDetailView"]) {
        
        PlaceDetailViewController *destViewController = segue.destinationViewController;
        destViewController.place = self.tappedBuilding;
    }
}

@end
