//
//  DiningViewController.h
//  RecipeBook
//
//  Created by Brian on 2/9/14.
//
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface DiningViewController : PFQueryTableViewController

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
