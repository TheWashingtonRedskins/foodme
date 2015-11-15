//
//  FMButton.h
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMButton : UIButton

@property (nonatomic, copy) void (^completion)();

-(id)initWithFrame:(CGRect)frame completion:(void (^)())completion;

@end
