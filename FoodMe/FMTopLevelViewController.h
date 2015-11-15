//
//  FMTopLevelViewController.h
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMainViewController.h"
#import "FMSetupViewController.h"
#import "FMQuestionViewController.h"

@interface FMTopLevelViewController : UIViewController<FMSetupDelegate>

@property (nonatomic) BOOL shouldSetup;
@property (nonatomic) FMMainViewController* mainVC;

-(void) setupCompleted;
-(void) reset;

@end
