//
//  RecipeDetailViewController.h
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Eateries.h"

@interface EateriesDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *eateryPhoto;
@property (nonatomic, strong) Eateries *eatery;

@end
