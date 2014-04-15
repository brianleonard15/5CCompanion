//
//  RecipeBookViewController.h
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Place.h"
#import "MBProgressHUD.h"

@interface PlaceViewController : UIViewController <UITabBarControllerDelegate>

@property(nonatomic, strong) IBOutlet UITableView *gymPoolTV, *eateriesTV, *otherTV, *diningTV, *favoritesTV;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSArray *favorites;
@property (nonatomic, strong) NSArray *gymPools;
@property (nonatomic, strong) NSArray *eateries;
@property (nonatomic, strong) NSArray *dinings;
@property (nonatomic, strong) NSArray *others;
@property(strong, nonatomic) PlaceViewController *eateriesVC;
@property(strong, nonatomic) PlaceViewController *otherVC;
@property(strong, nonatomic) PlaceViewController *diningVC;
@property(strong, nonatomic) PlaceViewController *favoritesVC;

@end
