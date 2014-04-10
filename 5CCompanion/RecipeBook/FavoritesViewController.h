//
//  FavoritesViewController.h
//  5CCompanion
//
//  Created by Brian on 4/1/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FavoritesViewController : UIViewController

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSArray *favorites;

@end
