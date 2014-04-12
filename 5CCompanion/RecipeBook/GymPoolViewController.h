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
#import "OtherViewController.h"
#import "DiningViewController.h"
#import "FavoritesViewController.h"
#import "Place.h"

@interface GymPoolViewController : UIViewController <UITabBarControllerDelegate>

@property(nonatomic, strong) IBOutlet UITableView *gymPoolTV, *eateriesTV, *otherTV, *diningTV, *favoritesTV;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSArray *gymPools;
@property (nonatomic, strong) NSArray *eateries;
@property (nonatomic, strong) NSArray *dinings;
@property (nonatomic, strong) NSArray *others;
@property(strong, nonatomic) GymPoolViewController *eateriesVC;
@property(strong, nonatomic) OtherViewController *otherVC;
@property(strong, nonatomic) DiningViewController *diningVC;
@property(strong, nonatomic) FavoritesViewController *favoritesVC;

@end
