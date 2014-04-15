//
//  RecipeDetailViewController.h
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PlaceDetailViewController : UIViewController {
	UIButton *favButton;
}

@property(nonatomic, strong) IBOutlet UITableView *gymPoolTV, *eateriesTV, *otherTV, *diningTV, *favoritesTV;
@property(retain) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIImageView *placePhoto;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) Place *place;
-(IBAction)toggleFav:(UIButton *)sender;

@end
