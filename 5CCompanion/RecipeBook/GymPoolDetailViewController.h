//
//  RecipeDetailViewController.h
//  RecipeBook
//
//  Created by Simon Ng on 17/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GymPool.h"

@interface GymPoolDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *gymPoolPhoto;
@property (nonatomic, strong) GymPool *gympool;

@end
