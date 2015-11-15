//
//  FMSetupViewController.m
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import "FMSetupViewController.h"
#import "FMQuestionViewController.h"
#import "FMYelpHelper.h"
#import "FMDataLoader.h"

@implementation FMSetupViewController

- (instancetype)init
{
    self = [super init];
    if (self) {

        
        NSMutableArray* funQuestionArray = [[FMDataLoader sharedInstance] genQuestion];;
        NSString* questPart = funQuestionArray[0];
        
        [funQuestionArray removeObjectAtIndex:0];
        NSMutableArray* answers = funQuestionArray;
        
        
        _questionIndex = 0;
        _prompts = @[
                     @"Welcome to foodme! \n the easiest way \n to find a place to eat.",
                     @"What's your price range?",
                     @"How far away do you want to eat?",
                     @"What meal do you want?",
                     questPart
                     ];
        _options = @[
                     @[@"Ok"],
                     @[@"$5-$10", @"$11-$30", @"$31+"],
                     @[@"0 - 5 min", @"5 - 10 min", @"10 - 20 min", @"21+ min"],
                     @[@"Breakfast", @"Lunch", @"Dinner", @"Dessert"],
                     answers
                     ];
    }
    return self;
}

-(void) showQuestionVC:(NSInteger) index animated:(BOOL)animated {
    FMQuestionViewController* vc = [[FMQuestionViewController alloc] initWithQuestion:_prompts[index] answers:_options[index]];
    vc.questionDelegate = self;
    if (_currentlyDisplayedVC) {
        [_currentlyDisplayedVC presentViewController:vc animated:animated completion:^{
        }];
    } else {
        [self presentViewController:vc animated:animated completion:nil];
    }
    _currentlyDisplayedVC = vc;
}

-(void)viewDidAppear:(BOOL)animated {
    if (!_currentlyDisplayedVC)
        [self showQuestionVC:0 animated:NO];
}

-(void) answerChosen:(NSString*)answer WithQuestion:(NSString*)question {
        
    if (_questionIndex == 1) {
        [[FMYelpHelper sharedInstance] setPriceDescBasedOnResponse:answer];
    }
    else if (_questionIndex == 2) {
        [[FMYelpHelper sharedInstance] setSearchRadiusBasedOnTime:answer];
    }
    else if (_questionIndex == 3) {
        [[FMYelpHelper sharedInstance] setMeal:answer];
    }
    else if (_questionIndex == 4) {
        [[FMYelpHelper sharedInstance] setIndexToPick: [_options[4] indexOfObject:answer]];
    }
    
    _questionIndex++;
    if (_questionIndex >= _prompts.count) {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
            [_setupDelegate setupCompleted];
        }];
    } else {
        [self showQuestionVC:_questionIndex animated:YES];
    }
}

@end
