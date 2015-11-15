//
//  FMMainViewController.h
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLabel.h"
#import "FMButton.h"
#import "FMQuestionViewController.h"

@interface FMMainViewController : UIViewController<FMQuestionDelegate>

@property (nonatomic) FMLabel* titleLabel;
@property (nonatomic) FMButton* startButton;
@property (nonatomic) NSDictionary* yelpData;

-(void)answerChosen:(NSString *)answer WithQuestion:(NSString *)question;

@end
