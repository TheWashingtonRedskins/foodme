//
//  FMSetupViewController.h
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMQuestionViewController.h"

@protocol FMSetupDelegate <NSObject>

-(void) setupCompleted;

@end

@interface FMSetupViewController : UIViewController<FMQuestionDelegate>

@property (nonatomic, weak) NSObject<FMSetupDelegate>* setupDelegate;
@property (nonatomic) NSInteger questionIndex;
@property (nonatomic) NSArray* prompts;
@property (nonatomic) NSArray* options;
@property (nonatomic) FMQuestionViewController* currentlyDisplayedVC;

-(void) answerChosen:(NSString*)answer WithQuestion:(NSString*)question;

@end
