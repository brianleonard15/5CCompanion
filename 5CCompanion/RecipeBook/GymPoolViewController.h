//
//  RecipeBookViewController.h
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EateriesViewController.h"
#import "Place.h"

@interface GymPoolViewController : UIViewController <UITabBarControllerDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSArray *gymPools;
@property (nonatomic, strong) NSMutableArray *eateries;
@property (nonatomic, strong) NSArray *dinings;
@property (nonatomic, strong) NSArray *others;
@property(strong, nonatomic) EateriesViewController *eateriesVC;

@end
