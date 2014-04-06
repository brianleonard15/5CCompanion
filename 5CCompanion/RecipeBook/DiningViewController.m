//
//  RecipeBookViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "DiningViewController.h"
#import "DiningDetailViewController.h"
#import "Place.h"

@interface DiningViewController ()

@end

@implementation DiningViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Initialize table data
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

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Places";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        self.objectsPerPage = 100;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"Class" equalTo:@"Dining"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    return query;
}

// Checks if the time is before 3:00 AM


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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"DiningCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    PFFile *thumbnail = [object objectForKey:@"imageFile"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    thumbnailImageView.image = [UIImage imageNamed:@"white.jpg"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"name"];
    
    // Gets current day
    
    UILabel *currentHoursLabel = (UILabel*) [cell viewWithTag:102];
    UILabel *openLabel = (UILabel*) [cell viewWithTag:103];
    NSDate* day = [[NSDate alloc] init];
    // Some places open past 12:00 am. For example, Jay's Place opens until 2 AM on Saturdays, and don't
    // want the app to show Jay's Sunday hours when it is between 12 and 2 AM on Sunday.
    

    NSDateFormatter *currentDay = [[NSDateFormatter alloc] init];
    [currentDay setDateFormat: @"EEEE"];
    NSString *dayOfTheWeek = [currentDay stringFromDate:day];
    
    BOOL isWeekend = [self isWeekend:dayOfTheWeek];
    
    NSMutableArray *hours;
    
    if (isWeekend) {
        hours = [[[object objectForKey: @"weekendBrunch"] arrayByAddingObjectsFromArray:[object objectForKey: @"weekendDinner"]]mutableCopy];
    }
    else {
        hours = [[[[object objectForKey: @"breakfastTime"] arrayByAddingObjectsFromArray:[object objectForKey: @"lunchTime"]] arrayByAddingObjectsFromArray: [object objectForKey: @"dinnerTime"]]mutableCopy];
    }
    
    [hours removeObject:@"Closed"];
    
    if (hours.count == 0) {
        [hours addObject:@"Closed"];
    }
    
    NSMutableString *currentHours = [[NSMutableString alloc] init];
    
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
    
    return cell;
}
- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDiningDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DiningDetailViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        Place *place = [[Place alloc] init];
        place.name = [object objectForKey:@"name"];
        place.imageFile = [object objectForKey:@"imageFile"];
        place.hours = [NSArray arrayWithObjects: [object objectForKey:@"breakfastTime"], [object objectForKey:@"lunchTime"], [object objectForKey:@"dinnerTime"], [object objectForKey:@"weekendBrunch"], [object objectForKey:@"weekendDinner"], nil];
        destViewController.place = place;
    }
}


@end
