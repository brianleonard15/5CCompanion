//
//  Recipe.h
//  RecipeBook
//
//  Created by Simon on 12/8/12.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Place : NSObject

@property (nonatomic, strong) NSString *name; // name of Business
@property (nonatomic, strong) UIImage *imageFile; // image filename of business
@property (nonatomic, strong) NSArray *hours; // hours
@property (nonatomic, strong) NSString *phone; // phone number
@property (nonatomic, strong) NSString *tab; // class
@property (nonatomic, strong) PFGeoPoint *location; // location

@end
