//
//  DiningDetailViewController.h
//  RecipeBook
//
//  Created by Brian on 2/9/14.
//
//

#import <UIKit/UIKit.h>
#import "Dining.h"

@interface DiningDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *recipePhoto;
@property (weak, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *ingredientTextView;

@property (nonatomic, strong) Dining *dining;

@end
