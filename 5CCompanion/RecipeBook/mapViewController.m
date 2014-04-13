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
        marker.map = self.mapView;
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
    self.buildings = [[self.buildings filteredArrayUsingPredicate:tapInfoPredicate]mutableCopy];
    [self performSegueWithIdentifier:@"showMapDetailView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMapDetailView"]) {
        
        PlaceDetailViewController *destViewController = segue.destinationViewController;
        Place *placeee = [self.buildings objectAtIndex:0];
        NSLog(@"%@",placeee.name);
        destViewController.place = [self.buildings objectAtIndex:0];
    }
}

@end
