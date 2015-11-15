//
//  FMLoadingView.m
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import "FMLoadingView.h"

@implementation FMLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _potView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pot.png"]];
        _steamView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"steam.png"]];
        
        CGSize steamSize = CGSizeMake(100, 100);
        
        _steamView.frame = CGRectMake(frame.size.width / 2 - steamSize.width / 2 + 25, 10, steamSize.width, steamSize.height);
        _potView.frame = CGRectMake(0, 90, frame.size.width, 100);
    }
    return self;
}

-(void)layoutSubviews {
    [self addSubview:_potView];
    [self addSubview:_steamView];
    
    [UIView animateWithDuration:0.5
                          delay:0.2f
                        options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         _steamView.center = CGPointMake(_steamView.center.x, _steamView.center.y + 20);
                     }
                     completion:^(BOOL fin) {
                     }];
}

@end
