//
//  OtherViewController.h
//  5CCompanion
//
//  Created by Brian on 4/2/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Place.h"

@interface OtherViewController :  UIViewController

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *others;

@end
