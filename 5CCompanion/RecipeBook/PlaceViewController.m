//
//  RecipeBookViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "PlaceViewController.h"
#import "PlaceDetailViewController.h"
#import "mapViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface PlaceViewController () {
    
IBOutlet UIView *loadingView;
IBOutlet UIView *emptyView;
NSUInteger tab;
NSArray *type;
UITableView *currentVC;
    
}

@end

@implementation PlaceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    tab = self.tabBarController.selectedIndex;
    if (tab == 0) {
    self.tabBarController.delegate = self;
    self.gymPoolTV.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    
    
    self.places = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Places"];
    query.cachePolicy =  kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *row in objects) {
                Place *place = [[Place alloc] init];
                place.name = [row objectForKey:@"name"];
                PFFile *PFImage = [row objectForKey:@"imageFile"];
                [PFImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        place.imageFile = [UIImage imageWithData:data];
                    }
                }];
                place.phone = [row objectForKey:@"Phone"];
                place.tab = [row objectForKey:@"Class"];
                place.location = [row objectForKey:@"Location"];
                if ([place.tab isEqualToString:@"Dining"]) {
                    place.hours = [NSArray arrayWithObjects: [row objectForKey:@"breakfastTime"], [row objectForKey:@"lunchTime"], [row objectForKey:@"dinnerTime"], [row objectForKey:@"weekendBrunch"], [row objectForKey:@"weekendDinner"], nil];
                }
                else {
                    place.hours = [NSArray arrayWithObjects: [row objectForKey:@"Monday"], [row objectForKey:@"Tuesday"], [row objectForKey:@"Wednesday"], [row objectForKey:@"Thursday"], [row objectForKey:@"Friday"], [row objectForKey:@"Saturday"], [row objectForKey:@"Sunday"], nil];
                }
                [self.places addObject:place];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSPredicate *gymPoolPredicate = [NSPredicate predicateWithFormat:@"tab = 'GymPool'"];
                NSPredicate *eateriesPredicate = [NSPredicate predicateWithFormat:@"tab = 'Eatery'"];
                NSPredicate *otherPredicate = [NSPredicate predicateWithFormat:@"tab = 'Other'"];
                NSPredicate *diningPredicate = [NSPredicate predicateWithFormat:@"tab = 'Dining'"];
                self.gymPools = [self.places filteredArrayUsingPredicate:gymPoolPredicate];
                self.eateries = [self.places filteredArrayUsingPredicate:eateriesPredicate];
                self.others = [self.places filteredArrayUsingPredicate:otherPredicate];
                self.dinings = [self.places filteredArrayUsingPredicate:diningPredicate];
                
                type = [NSArray array];
                //simpleTableIdentifier = @"TableViewCell";
                type = self.gymPools;
                currentVC = self.gymPoolTV;

                sleep(1);
                [UIView transitionFromView:loadingView toView:self.gymPoolTV
                                  duration:01.0 options:UIViewAnimationOptionTransitionFlipFromRight
                                completion:NULL];
                self.gymPoolTV.hidden = NO;
                loadingView.hidden = YES;
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                self.tabBarController.tabBar.hidden=NO;
                [self.gymPoolTV reloadData];
            });
        }
    }
     ];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (tab == 4) {
    
    NSArray *favoritesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    if (favoritesArray.count == 0) {
        emptyView.hidden = NO;
        self.favoritesTV.hidden = YES;
    }
    else {
        self.favoritesTV.hidden = NO;
        emptyView.hidden = YES;
    }
    
    NSPredicate *favoritesPredicate = [NSPredicate predicateWithFormat:@"name IN %@", favoritesArray];
    self.favorites = [self.places filteredArrayUsingPredicate:favoritesPredicate];
    
    [self.favoritesTV reloadData];
    
    [self.favoritesTV deselectRowAtIndexPath:[self.favoritesTV indexPathForSelectedRow] animated:YES];
        
    }
    
    type = [NSArray array];
    
    
	switch (tab) {
		case 0:
        {
            type = self.gymPools;
            currentVC = self.gymPoolTV;
			break;
        }
		case 1:
        {
            type = self.eateries;
            currentVC = self.eateriesTV;
			break;
        }
		case 2:
        {
            type = self.dinings;
            currentVC = self.diningTV;
			break;
        }
		case 3:
        {
            type = self.others;
            currentVC = self.otherTV;
			break;
        }
		case 4:
        {
            type = self.favorites;
            currentVC = self.favoritesTV;
			break;
        }
		default:
			NSLog(@"Unknown operator.");
			break;
	}
    
    [currentVC deselectRowAtIndexPath:[currentVC indexPathForSelectedRow] animated:YES];
    [currentVC reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


// Checks if the time is before 3:00 AM

- (BOOL)before3am
{
    NSCalendar *gregorianCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalender components:NSHourCalendarUnit fromDate:[NSDate date]];
    if([components hour] <= 3)
        return YES;
    return NO;
    
}

// convert to a NSDate from the current day
- (NSDate *)todaysDateFromAMPMString:(NSString *)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    
    // Get year-month-day for today:
    [fmt setDateFormat:@"yyyy-MM-dd "];
    NSString *todayString = [fmt stringFromDate:[NSDate date]];
    
    // Append the given time:
    NSString *todaysTime = [todayString stringByAppendingString:time];
    
    // Convert date+time string back to NSDate:
    [fmt setDateFormat:@"yyyy-MM-dd h:mma"];
    NSDate *date = [fmt dateFromString:todaysTime];
    return date;
}


- (BOOL)isWeekend:(NSString *)day
{
    NSArray *weekend = @[@"Saturday", @"Sunday"];
    return [weekend containsObject: day];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    // Configure the cell
    Place *place = [[Place alloc] init];
    place = [type objectAtIndex:indexPath.row];
    UIImageView *thumbnailImageView = (UIImageView*)[cell viewWithTag:100];
    thumbnailImageView.image = place.imageFile;
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = place.name;
    
    // Gets current day
    
    UILabel *currentHoursLabel = (UILabel*) [cell viewWithTag:102];
    UILabel *openLabel = (UILabel*) [cell viewWithTag:103];
    NSDate* day = [[NSDate alloc] init];
    // Some places open past 12:00 am. For example, Jay's Place opens until 2 AM on Saturdays, and don't
    // want the app to show Jay's Sunday hours when it is between 12 and 2 AM on Sunday.
    
    if (![place.tab isEqualToString: @"Dining"]) {
        if ([self before3am]) {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *today = [NSDate date];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            
            NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent toDate:today options:0];
            day = yesterday;
        }
    }
    NSDateFormatter *currentDay = [[NSDateFormatter alloc] init];
    [currentDay setDateFormat: @"EEEE"];
    NSString *dayOfTheWeek = [currentDay stringFromDate:day];
    NSArray *daysOfWeekInOrder = [NSArray arrayWithObjects: @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    NSUInteger numericDayOfWeek = [daysOfWeekInOrder indexOfObject:dayOfTheWeek];
    
    NSMutableArray *hours;
    
    if ([place.tab isEqualToString: @"Dining"]) {
        BOOL isWeekend = [self isWeekend:dayOfTheWeek];
        
        
        if (isWeekend) {
            hours = [[[place.hours objectAtIndex:3] arrayByAddingObjectsFromArray: [place.hours objectAtIndex:4]]mutableCopy];
        }
        else {
            hours = [[[[place.hours objectAtIndex:0] arrayByAddingObjectsFromArray: [place.hours objectAtIndex:1]] arrayByAddingObjectsFromArray:[place.hours objectAtIndex:2]] mutableCopy];
        }
        
        [hours removeObject:@"Closed"];
        
        if (hours.count == 0) {
            [hours addObject:@"Closed"];
        }
    }
    else {
        hours = [place.hours objectAtIndex:numericDayOfWeek];
    }
    
    NSMutableString *currentHours = [[NSMutableString alloc] init];
    
    if (![place.tab isEqualToString: @"Dining"]) {
        if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
            [currentHours appendFormat:@"%@", [hours objectAtIndex: 0]];
            currentHoursLabel.textColor = [UIColor redColor];
            openLabel.backgroundColor = [UIColor redColor];
        }
        else {
            if (hours.count == 4) {
                NSString *strCloseTime = [hours objectAtIndex: 1];
                NSDate *closeTime = [self todaysDateFromAMPMString:strCloseTime];
                NSDate *now = [NSDate date];
                if ([now compare:closeTime] != NSOrderedAscending || [self before3am]) {
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
                }
                else {
                    [currentHours setString:@""];
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
                }
            }
            else if (hours.count == 6) {
                NSString *strCloseTime = [hours objectAtIndex: 1];
                NSDate *closeTime = [self todaysDateFromAMPMString:strCloseTime];
                NSString *strCloseTime2 = [hours objectAtIndex: 3];
                NSDate *closeTime2 = [self todaysDateFromAMPMString:strCloseTime2];
                NSString *strCloseTime3 = [hours objectAtIndex: 5];
                NSDate *closeTime3 = [self todaysDateFromAMPMString:strCloseTime3];
                NSDate *now = [NSDate date];
                if ([now compare:closeTime] == NSOrderedAscending) {
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
                }
                else if ([now compare:closeTime] != NSOrderedAscending && [now compare:closeTime2] == NSOrderedAscending) {
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
                }
                else if ([now compare:closeTime3] == NSOrderedAscending) {
                    [currentHours setString:@""];
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 4], [hours objectAtIndex: 5]];
                }
                else {
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
                }
            }
            else
                [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
        }
        
        currentHoursLabel.text = currentHours;
        
        
        if (![[hours objectAtIndex: 0] isEqualToString: @"Closed"]) {
            NSString *strOpenTime = [hours objectAtIndex: 0];
            NSString *strCloseTime = [hours objectAtIndex: 1];
            
            NSDate *openTime = [self todaysDateFromAMPMString:strOpenTime];
            NSDate *closeTime = [self todaysDateFromAMPMString:strCloseTime];
            NSDate *openTime2;
            NSDate *closeTime2;
            NSDate *openTime3;
            NSDate *closeTime3;
            
            if ([closeTime compare:openTime] != NSOrderedDescending) {
                // closeTime is less than or equal to openTime, so add one day:
                if([self before3am]) {
                    NSCalendar *cal = [NSCalendar currentCalendar];
                    NSDateComponents *comp = [[NSDateComponents alloc] init];
                    [comp setDay:-1];
                    openTime = [cal dateByAddingComponents:comp toDate:openTime options:0];
                }
                else {
                    NSCalendar *cal = [NSCalendar currentCalendar];
                    NSDateComponents *comp = [[NSDateComponents alloc] init];
                    [comp setDay:1];
                    closeTime = [cal dateByAddingComponents:comp toDate:closeTime options:0];
                }
            }
            
            if (hours.count == 4) {
                NSString *strOpenTime2 = [hours objectAtIndex: 2];
                NSString *strCloseTime2 = [hours objectAtIndex: 3];
                
                openTime2 = [self todaysDateFromAMPMString:strOpenTime2];
                closeTime2 = [self todaysDateFromAMPMString:strCloseTime2];
                
                if ([closeTime2 compare:openTime2] != NSOrderedDescending) {
                    // closeTime is less than or equal to openTime, so add one day:
                    if([self before3am]) {
                        NSCalendar *cal = [NSCalendar currentCalendar];
                        NSDateComponents *comp = [[NSDateComponents alloc] init];
                        [comp setDay:-1];
                        openTime2 = [cal dateByAddingComponents:comp toDate:openTime2 options:0];
                    }
                    else {
                        NSCalendar *cal = [NSCalendar currentCalendar];
                        NSDateComponents *comp = [[NSDateComponents alloc] init];
                        [comp setDay:1];
                        closeTime2 = [cal dateByAddingComponents:comp toDate:closeTime2 options:0];
                    }
                }
                
            }
            if (hours.count == 6) {
                NSString *strOpenTime2 = [hours objectAtIndex: 2];
                NSString *strCloseTime2 = [hours objectAtIndex: 3];
                NSString *strOpenTime3 = [hours objectAtIndex: 4];
                NSString *strCloseTime3 = [hours objectAtIndex: 5];
                
                openTime2 = [self todaysDateFromAMPMString:strOpenTime2];
                closeTime2 = [self todaysDateFromAMPMString:strCloseTime2];
                openTime3 = [self todaysDateFromAMPMString:strOpenTime3];
                closeTime3 = [self todaysDateFromAMPMString:strCloseTime3];
                
                if ([closeTime2 compare:openTime2] != NSOrderedDescending) {
                    // closeTime is less than or equal to openTime, so add one day:
                    NSCalendar *cal = [NSCalendar currentCalendar];
                    NSDateComponents *comp = [[NSDateComponents alloc] init];
                    [comp setDay:1];
                    closeTime2 = [cal dateByAddingComponents:comp toDate:closeTime2 options:0];
                }
            }
            
            NSDate *now = [NSDate date];
            
            if (([now compare:openTime] != NSOrderedAscending &&
                 [now compare:closeTime] != NSOrderedDescending) ||
                (openTime2 && closeTime2 &&
                 [now compare:openTime2] != NSOrderedAscending &&
                 [now compare:closeTime2] != NSOrderedDescending) ||
                (openTime3 && closeTime3 &&
                 [now compare:openTime3] != NSOrderedAscending &&
                 [now compare:closeTime3] != NSOrderedDescending)) {
                    currentHoursLabel.textColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
                    openLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
                } else {
                    currentHoursLabel.textColor = [UIColor redColor];
                    openLabel.backgroundColor = [UIColor redColor];
                }
        }
    }
    
    else {
        if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
            [currentHours appendFormat:@"%@", [hours objectAtIndex: 0]];
            currentHoursLabel.textColor = [UIColor redColor];
            openLabel.backgroundColor = [UIColor redColor];
        }
        else {
            if (hours.count == 4) {
                NSString *strCloseTime = [hours objectAtIndex: 1];
                NSDate *closeTime = [self todaysDateFromAMPMString:strCloseTime];
                NSDate *now = [NSDate date];
                if ([now compare:closeTime] != NSOrderedAscending) {
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
                }
                else {
                    [currentHours setString:@""];
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
                }
            }
            else if (hours.count == 6) {
                NSString *strCloseTime = [hours objectAtIndex: 1];
                NSDate *closeTime = [self todaysDateFromAMPMString:strCloseTime];
                NSString *strCloseTime2 = [hours objectAtIndex: 3];
                NSDate *closeTime2 = [self todaysDateFromAMPMString:strCloseTime2];
                NSString *strCloseTime3 = [hours objectAtIndex: 5];
                NSDate *closeTime3 = [self todaysDateFromAMPMString:strCloseTime3];
                NSDate *now = [NSDate date];
                if ([now compare:closeTime] == NSOrderedAscending) {
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
                }
                else if ([now compare:closeTime] != NSOrderedAscending && [now compare:closeTime2] == NSOrderedAscending) {
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
                }
                else if ([now compare:closeTime3] == NSOrderedAscending) {
                    [currentHours setString:@""];
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 4], [hours objectAtIndex: 5]];
                }
                else {
                    [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
                }
            }
            else
                [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
        }
        
        currentHoursLabel.text = currentHours;
        
        if (![[hours objectAtIndex: 0] isEqualToString: @"Closed"]) {
            NSString *strOpenTime = [hours objectAtIndex: 0];
            NSString *strCloseTime = [hours objectAtIndex: 1];
            NSDate *openTime = [self todaysDateFromAMPMString:strOpenTime];
            NSDate *closeTime = [self todaysDateFromAMPMString:strCloseTime];
            
            NSDate *openTime2;
            NSDate *closeTime2;
            NSDate *openTime3;
            NSDate *closeTime3;
            
            if ([closeTime compare:openTime] != NSOrderedDescending) {
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *comp = [[NSDateComponents alloc] init];
                [comp setDay:1];
                closeTime = [cal dateByAddingComponents:comp toDate:closeTime options:0];
            }
            
            if (hours.count == 4) {
                NSString *strOpenTime2 = [hours objectAtIndex: 2];
                NSString *strCloseTime2 = [hours objectAtIndex: 3];
                
                openTime2 = [self todaysDateFromAMPMString:strOpenTime2];
                closeTime2 = [self todaysDateFromAMPMString:strCloseTime2];
                
                if ([closeTime2 compare:openTime2] != NSOrderedDescending) {
                    // closeTime is less than or equal to openTime, so add one day:
                    NSCalendar *cal = [NSCalendar currentCalendar];
                    NSDateComponents *comp = [[NSDateComponents alloc] init];
                    [comp setDay:1];
                    closeTime2 = [cal dateByAddingComponents:comp toDate:closeTime2 options:0];
                }
                
            }
            
            if (hours.count == 6) {
                NSString *strOpenTime2 = [hours objectAtIndex: 2];
                NSString *strCloseTime2 = [hours objectAtIndex: 3];
                NSString *strOpenTime3 = [hours objectAtIndex: 4];
                NSString *strCloseTime3 = [hours objectAtIndex: 5];
                
                openTime2 = [self todaysDateFromAMPMString:strOpenTime2];
                closeTime2 = [self todaysDateFromAMPMString:strCloseTime2];
                openTime3 = [self todaysDateFromAMPMString:strOpenTime3];
                closeTime3 = [self todaysDateFromAMPMString:strCloseTime3];
                
                if ([closeTime2 compare:openTime2] != NSOrderedDescending) {
                    // closeTime is less than or equal to openTime, so add one day:
                    NSCalendar *cal = [NSCalendar currentCalendar];
                    NSDateComponents *comp = [[NSDateComponents alloc] init];
                    [comp setDay:1];
                    closeTime2 = [cal dateByAddingComponents:comp toDate:closeTime2 options:0];
                }
            }
            
            NSDate *now = [NSDate date];
            
            if (([now compare:openTime] != NSOrderedAscending &&
                 [now compare:closeTime] != NSOrderedDescending) ||
                (openTime2 && closeTime2 &&
                 [now compare:openTime2] != NSOrderedAscending &&
                 [now compare:closeTime2] != NSOrderedDescending) ||
                (openTime3 && closeTime3 &&
                 [now compare:openTime3] != NSOrderedAscending &&
                 [now compare:closeTime3] != NSOrderedDescending)) {
                    currentHoursLabel.textColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
                    openLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
                } else {
                    currentHoursLabel.textColor = [UIColor redColor];
                    openLabel.backgroundColor = [UIColor redColor];
                }
        }
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return type.count;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *navController = [tabBarController.viewControllers objectAtIndex:1];
    UINavigationController *navController2 = [tabBarController.viewControllers objectAtIndex:2];
    UINavigationController *navController3 = [tabBarController.viewControllers objectAtIndex:3];
    UINavigationController *navController4 = [tabBarController.viewControllers objectAtIndex:4];
    self.eateriesVC = (PlaceViewController *) [navController.viewControllers objectAtIndex:0];
    self.diningVC = (PlaceViewController *) [navController2.viewControllers objectAtIndex:0];
    self.otherVC = (PlaceViewController *) [navController3.viewControllers objectAtIndex:0];
    self.favoritesVC = (PlaceViewController *) [navController4.viewControllers objectAtIndex:0];

    self.eateriesVC.eateries = self.eateries;
    self.diningVC.dinings = self.dinings;
    self.otherVC.others = self.others;
    self.favoritesVC.places = self.places;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [currentVC indexPathForSelectedRow];
        PlaceDetailViewController *destViewController = segue.destinationViewController;
        
        destViewController.place = [type objectAtIndex:indexPath.row];
    }
    if ([segue.identifier isEqualToString:@"showMapView"]) {
        
        mapViewController *mapViewController = segue.destinationViewController;
        mapViewController.buildings = [[NSMutableArray alloc]init];
        [mapViewController.buildings addObjectsFromArray:self.places];
    }
}



@end
