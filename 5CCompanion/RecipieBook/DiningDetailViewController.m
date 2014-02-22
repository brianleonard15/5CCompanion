//
//  DiningDetailViewController.m
//  RecipeBook
//
//  Created by Brian on 2/9/14.
//
//

#import "DiningDetailViewController.h"

@interface DiningDetailViewController ()

@end

@implementation DiningDetailViewController

@synthesize recipePhoto;
@synthesize prepTimeLabel;
@synthesize ingredientTextView;
@synthesize dining;


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
    
    self.title = dining.name;
    self.prepTimeLabel.text = dining.prepTime;
    self.recipePhoto.image = [UIImage imageNamed:dining.imageFile];
    
    NSMutableString *ingredientText = [NSMutableString string];
    for (NSString* ingredient in dining.ingredients) {
        [ingredientText appendFormat:@"%@\n", ingredient];
    }
    self.ingredientTextView.text = ingredientText;
    
}

- (void)viewDidUnload
{
    [self setRecipePhoto:nil];
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
