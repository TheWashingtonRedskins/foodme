//
//  FMButton.m
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import "FMButton.h"
#import "FMColors.h"

@implementation FMButton

-(id)initWithFrame:(CGRect)frame completion:(void (^)())completion; {
    self = [super initWithFrame:frame];
    if (self) {
        _completion = completion;
        
        self.layer.cornerRadius = 10;
        self.layer.borderColor = TEXT_COLOR.CGColor;
        self.layer.borderWidth = 3;
        self.titleLabel.textColor = [UIColor blackColor];
        
        
        UIFont* font = [UIFont fontWithName:@"Varela" size:24];
        [self.titleLabel setFont:font];
        [self setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        
        [self addTarget:self action:@selector(buttonHighlight) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

-(void) buttonHighlight {
    self.superview.userInteractionEnabled = NO;
    [UIView animateWithDuration:.15 animations:^{
        [self setBackgroundColor:TEXT_COLOR];
        [self setTitleColor: BACKGROUND_COLOR forState: UIControlStateNormal];
    } completion:^(BOOL finished) {
        _completion();
    }];
}

@end
