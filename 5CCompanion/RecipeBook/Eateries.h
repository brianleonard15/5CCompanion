//
//  Recipe.h
//  RecipeBook
//
//  Created by Simon on 12/8/12.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Eateries : NSObject

@property (nonatomic, strong) NSString *name; // name of Business
@property (nonatomic, strong) PFFile *imageFile; // image filename of business
@property (nonatomic, strong) NSArray *hours; // hours

@end
