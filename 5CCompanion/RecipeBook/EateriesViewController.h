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

@interface EateriesViewController : UIViewController

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *eateries;

@end
