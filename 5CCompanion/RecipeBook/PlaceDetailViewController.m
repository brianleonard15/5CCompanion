//
//  RecipeDetailViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "PlaceDetailViewController.h"

@interface PlaceDetailViewController () {
    NSArray *dayOfWeek;
    NSUInteger tab;
}
@end

@implementation PlaceDetailViewController

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
    if ([place.tab isEqualToString:@"Dining"]) {
        dayOfWeek = [[NSArray alloc] initWithObjects:
                     @"Breakfast",
                     @"Lunch",
                     @"Dinner",
                     @"Weekend Brunch",
                     @"Weekend Dinner",
                     nil];
    }
    else {
        dayOfWeek = [[NSArray alloc] initWithObjects:
                     @"Monday",
                     @"Tuesday",
                     @"Wednesday",
                     @"Thursday",
                     @"Friday",
                     @"Saturday",
                     @"Sunday",
                     nil];
    }
    
    self.title = place.name;
    self.placePhoto.image = place.imageFile;
    self.phoneLabel.text = place.phone;
    if ([place.phone length] == 0) {
        self.phoneLabel.userInteractionEnabled = FALSE;
    }
    else {
        self.phoneLabel.userInteractionEnabled = TRUE;
    }
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPhoneURL:)];
    [self.phoneLabel addGestureRecognizer:tapGesture];
    tab = self.tabBarController.selectedIndex;
    if(tab == 4) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"] containsObject:[NSString stringWithString:place.name]]) {
            self.favButton.selected = YES;
        }
    }
}

-(void)openPhoneURL:(id)sender
{
    UIGestureRecognizer *rec = (UIGestureRecognizer *)sender;
    id hitLabel = [self.view hitTest:[rec locationInView:self.view] withEvent:UIEventTypeTouches];
    if ([hitLabel isKindOfClass:[UILabel class]]) {
        NSString *phoneNumber = [[((UILabel *)hitLabel).text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *number = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        [self callWithURL:[NSURL URLWithString:number]];
    }
}

- (void)callWithURL:(NSURL *)url
{
    static UIWebView *webView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webView = [UIWebView new];
    });
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
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
    UIButton *dayText = (UIButton*) [cell viewWithTag:200];
    [dayText setTitle:[dayOfWeek objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    // Gets current day

    UIButton *hoursText = (UIButton*) [cell viewWithTag:201];
    NSMutableString *hourText = [NSMutableString string];
    NSArray* hours = [place.hours objectAtIndex:indexPath.row];
    if ([[hours objectAtIndex: 0] isEqualToString: @"Closed"])  {
        [hourText appendFormat:@"%@", [hours objectAtIndex: 0]];
    }
    else {
        [hourText appendFormat:@"%@ - %@", [hours objectAtIndex: 0], [hours objectAtIndex: 1]];
            if (hours.count == 4) {
                [hourText appendFormat:@"\n%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
            }
            if (hours.count == 6) {
                [hourText appendFormat:@"\n%@ - %@", [hours objectAtIndex: 2], [hours objectAtIndex: 3]];
                [hourText appendFormat:@"\n%@ - %@", [hours objectAtIndex: 4], [hours objectAtIndex: 5]];
            }
    }
    [hoursText setTitle:hourText forState:UIControlStateNormal];
    //dayText.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12.0f];
    //hoursText.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0f];
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
        if (tab == 4) {
        [self.navigationController popViewControllerAnimated:YES];
        }
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
    
    static NSString *simpleTableIdentifier = @"hoursCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UIButton *dayText = (UIButton*) [cell viewWithTag:200];
    [dayText setTitle:[dayOfWeek objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    if (hours.count > 4) {
        height = 60;
    }
    else if ([dayText.titleLabel.text isEqualToString:@"Weekend Brunch"] || [dayText.titleLabel.text isEqualToString:@"Weekend Dinner"] || hours.count > 3) {
        height = 50;
    }
    else {
        height = 30;
    }

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
