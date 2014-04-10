//
//  RecipeDetailViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "EateriesDetailViewController.h"

@interface EateriesDetailViewController () {
    NSArray *dayOfWeek;
}
@end

@implementation EateriesDetailViewController

@synthesize placePhoto;
@synthesize place;
@synthesize favButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dayOfWeek = [[NSArray alloc] initWithObjects:
                 @"Monday",
                 @"Tuesday",
                 @"Wednesday",
                 @"Thursday",
                 @"Friday",
                 @"Saturday",
                 @"Sunday",
                 nil];
    
    self.title = place.name;
    self.placePhoto.image = place.imageFile;
    self.phoneLabel.text = place.phone;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] containsObject:[NSString stringWithString:place.name]]) {
		self.favButton.selected = YES;
	}
    else {
        self.favButton.selected = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dayOfWeek count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"hoursCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    UITextView *dayText = (UITextView*) [cell viewWithTag:200];
    dayText.text = [dayOfWeek objectAtIndex:indexPath.row];
    
    // Gets current day
    
    NSArray* hours = [place.hours objectAtIndex:indexPath.row];
    UITextView *hoursText = (UITextView*) [cell viewWithTag:201];
    NSMutableString *hourText = [NSMutableString string];
    if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
        [hourText appendFormat:@"%@", [hours objectAtIndex: 0]];
    }
    else {
        [hourText appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
        if (hours.count == 4) {
            [hourText appendFormat:@"\n%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
        }
    }

    hoursText.text = hourText;
    dayText.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12.0f];
    hoursText.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0f];
    

    return cell;
}

-(IBAction)toggleFav:(UIButton *)sender {
    if([sender isSelected]){
        //...
        [sender setSelected:NO];
		NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] mutableCopy];
		[array removeObject:[NSString stringWithString:place.name]];
		[[NSUserDefaults standardUserDefaults] setObject:array forKey:@"favorites"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        //...
        [sender setSelected:YES];
		NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] mutableCopy];
		[array addObject:[NSString stringWithString:place.name]];
		[[NSUserDefaults standardUserDefaults] setObject:array forKey:@"favorites"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* hours = [place.hours objectAtIndex:indexPath.row];
    CGFloat height;
    if (hours.count < 3) {
        height = 40;
    }
    else {
        height = 60;
    }
    
    static NSString *simpleTableIdentifier = @"hoursCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UITextView *hoursText = (UITextView*) [cell viewWithTag:201];
    CGRect frame = hoursText.frame;
    frame.size.height = height - 10;
    hoursText.frame = frame;
    return height;
}

- (void)viewDidUnload
{
    [self setPlacePhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
