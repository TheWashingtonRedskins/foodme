//
//  FMQuestionViewController.h
//  FoodMe
//
//  Created by James Lennon on 11/13/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLabel.h"

#define MAX_QUESTIONS 4

@protocol FMQuestionDelegate <NSObject>

-(void) answerChosen:(NSString*)answer WithQuestion:(NSString*)question;

@end

@interface FMQuestionViewController : UIViewController

@property NSObject<FMQuestionDelegate>* questionDelegate;
@property NSString* question;
@property NSArray* answers;
@property FMLabel* questionLabel;
@property NSMutableArray* answerButtons;

-(id)initWithQuestion:(NSString*)question answers:(NSArray*)answers;

@end
