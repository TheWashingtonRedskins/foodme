//
//  FMRestaurantViewController.h
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRestaurantView.h"

@interface FMRestaurantViewController : UIViewController

@property (nonatomic) NSDictionary* data;
@property (nonatomic) FMRestaurantView* restaurantView;

-(id) initWithDictionary:(NSDictionary*)dict;

@end
