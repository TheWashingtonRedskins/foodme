//
//  FMRestaurantView.h
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRestaurantView : UIView

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* imgURL;
@property (nonatomic) NSString* address;

-(instancetype)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dict;

@end
