//
//  RecipeDetailViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "FoodDetailViewController.h"

@interface FoodDetailViewController ()

@end

@implementation FoodDetailViewController

@synthesize foodPhoto;
@synthesize prepTimeLabel;
@synthesize ingredientTextView;
@synthesize dayTextView;
@synthesize food;


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
    
    self.title = food.name;
    self.prepTimeLabel.text = food.prepTime;
    self.foodPhoto.file = food.imageFile;

    NSMutableString *ingredientText = [NSMutableString string];
    for (NSArray* day in food.hours) {
        if ([[day objectAtIndex: 0] isEqualToString: @"Closed"])  {
            [ingredientText appendFormat:@"%@\n", [day objectAtIndex: 0]];
        }
        else {
            [ingredientText appendFormat:@"%@ to %@", [day objectAtIndex: 0], [day objectAtIndex: 1]];
            if (day.count == 4) {
                [ingredientText appendFormat:@"\n%@ to %@", [day objectAtIndex: 2], [day objectAtIndex: 3]];
            }
            [ingredientText appendFormat:@"\n"];
        }
    }
    
    self.ingredientTextView.text = ingredientText;
    
    NSArray *dayOfWeek;
    dayOfWeek = [NSArray arrayWithObjects:
             @"Monday",
             @"Tuesday",
             @"Wednesday",
             @"Thursday",
             @"Friday",
             @"Saturday",
             @"Sunday",
             nil];
    NSMutableString *dayText = [NSMutableString string];
    for (int i = 0; i < 7; i++) {
        [dayText appendFormat:@"%@\n", dayOfWeek[i]];
        if ([[food.hours objectAtIndex:i] count] == 4) {
            [dayText appendFormat:@"\n"];
            
        }
    }
    self.dayTextView.text = dayText;
    
}

- (void)viewDidUnload
{
    [self setFoodPhoto:nil];
    [self setPrepTimeLabel:nil];
    [self setIngredientTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
