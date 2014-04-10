//
//  RecipeBookViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "GymPoolViewController.h"
#import "GymPoolDetailViewController.h"


@interface GymPoolViewController () {
    
IBOutlet UIView *loadingView;

}

@end

@implementation GymPoolViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    self.tableView.hidden = YES;
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
                

                sleep(1);
                [UIView transitionFromView:loadingView toView:self.tableView
                                  duration:01.0 options:UIViewAnimationOptionTransitionFlipFromRight
                                completion:NULL];
                self.tableView.hidden = NO;
                loadingView.hidden = YES;
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                self.tabBarController.tabBar.hidden=NO;
                [self.tableView reloadData];
            });
        }
    }
     ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GymPoolCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    Place *place = [[Place alloc] init];
    place = [self.gymPools objectAtIndex:indexPath.row];
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
    
    if ([self before3am]) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *today = [NSDate date];
        
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = -1;
        
        NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent toDate:today options:0];
        day = yesterday;
    }
    NSDateFormatter *currentDay = [[NSDateFormatter alloc] init];
    [currentDay setDateFormat: @"EEEE"];
    NSString *dayOfTheWeek = [currentDay stringFromDate:day];
    NSArray *daysOfWeekInOrder = [NSArray arrayWithObjects: @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    NSUInteger numericDayOfWeek = [daysOfWeekInOrder indexOfObject:dayOfTheWeek];
    
    NSArray *hours = [place.hours objectAtIndex:numericDayOfWeek];
    NSMutableString *currentHours = [[NSMutableString alloc] init];
    
    if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
        [currentHours appendFormat:@"%@", [hours objectAtIndex: 0]];
        currentHoursLabel.textColor = [UIColor redColor];
        openLabel.backgroundColor = [UIColor redColor];
    }
    else {
        if (hours.count == 4) {
            // NSString *strOpenTime = [hours objectAtIndex: 0];
            NSString *strCloseTime = [hours objectAtIndex: 1];
            //  NSString *strCloseTime2 = [hours objectAtIndex: 3];
            // NSDate *openTime = [self todaysDateFromAMPMString:strOpenTime];
            NSDate *closeTime = [self todaysDateFromAMPMString:strCloseTime];
            // NSDate *closeTime2 = [self todaysDateFromAMPMString:strCloseTime2];
            NSDate *now = [NSDate date];
            if ([now compare:closeTime] != NSOrderedAscending || [self before3am]) {
                [currentHours appendFormat:@"%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
            }
            else {
                [currentHours setString:@""];
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
        
        NSDate *now = [NSDate date];
        
        if (([now compare:openTime] != NSOrderedAscending &&
             [now compare:closeTime] != NSOrderedDescending) ||
            (openTime2 && closeTime2 &&
             [now compare:openTime2] != NSOrderedAscending &&
             [now compare:closeTime2] != NSOrderedDescending)) {
                currentHoursLabel.textColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
                openLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
            } else {
                currentHoursLabel.textColor = [UIColor redColor];
                openLabel.backgroundColor = [UIColor redColor];
            }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gymPools.count;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *navController = [tabBarController.viewControllers objectAtIndex:1];
    UINavigationController *navController2 = [tabBarController.viewControllers objectAtIndex:2];
    UINavigationController *navController3 = [tabBarController.viewControllers objectAtIndex:3];
    UINavigationController *navController4 = [tabBarController.viewControllers objectAtIndex:4];
    self.eateriesVC = (EateriesViewController *) [navController.viewControllers objectAtIndex:0];
    self.diningVC = (DiningViewController *) [navController2.viewControllers objectAtIndex:0];
    self.otherVC = (OtherViewController *) [navController3.viewControllers objectAtIndex:0];
    self.favoritesVC = (FavoritesViewController *) [navController4.viewControllers objectAtIndex:0];

    self.eateriesVC.eateries = self.eateries;
    self.diningVC.dinings = self.dinings;
    self.otherVC.others = self.others;
    self.favoritesVC.places = self.places;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGymPoolDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GymPoolDetailViewController *destViewController = segue.destinationViewController;
        
        destViewController.place = [self.gymPools objectAtIndex:indexPath.row];
    }
}



@end
