//
//  RecipeDetailViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "GymPoolDetailViewController.h"

@interface GymPoolDetailViewController ()

@end

@implementation GymPoolDetailViewController

@synthesize gymPoolPhoto;
@synthesize prepTimeLabel;
@synthesize ingredientTextView;
@synthesize gympool;


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
    
    self.title = gympool.name;
    self.prepTimeLabel.text = gympool.prepTime;
    self.gymPoolPhoto.file = gympool.imageFile;

    NSMutableString *ingredientText = [NSMutableString string];
    for (NSArray* day in gympool.hours) {
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
    [self setGymPoolPhoto:nil];
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
