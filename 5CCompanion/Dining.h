//
//  Dining.h
//  RecipeBook
//
//  Created by Brian on 2/9/14.
//
//

#import <Foundation/Foundation.h>

@interface Dining : NSObject

@property (nonatomic, strong) NSString *name; // name of recipe
@property (nonatomic, strong) NSString *prepTime; // preparation time
@property (nonatomic, strong) NSString *imageFile; // image filename of recipe
@property (nonatomic, strong) NSArray *ingredients; // ingredients

@end
