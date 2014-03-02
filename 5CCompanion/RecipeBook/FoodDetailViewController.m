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
            [ingredientText appendFormat:@"%@ to %@\n", [day objectAtIndex: 0], [day objectAtIndex: 1]];
        }
    }
    
    self.ingredientTextView.text = ingredientText;
    
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
