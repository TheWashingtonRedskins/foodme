//
//  FMMainViewController.m
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import "FMMainViewController.h"
#import "FMColors.h"
#import "FMLoadingViewController.h"
#import "FMYelpHelper.h"
#import "FMRestaurantViewController.h"
#import "FMTopLevelViewController.h"

@implementation FMMainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad {
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _titleLabel = [[FMLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_titleLabel sizeToFit];
    
    CGSize size = self.view.frame.size;
    
    CGFloat sidePadding = 30, btnHeight = 100;
    
    _startButton = [[FMButton alloc] initWithFrame:CGRectMake(sidePadding, size.height / 2 - btnHeight / 2, size.width - 2 * sidePadding, btnHeight) completion:^{
        [self transition];
    }];
    [_startButton setTitle:@"food me" forState:UIControlStateNormal];
    [self.view addSubview:_startButton];
}

-(void) transition {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5f animations:^{
            [_startButton setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self chooseRestaurant];
        }];
    });
}

-(void)chooseRestaurant {
    FMLoadingViewController* lvc = [[FMLoadingViewController alloc] init];
    [self presentViewController:lvc animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[FMYelpHelper sharedInstance] findTopBiz:^(NSDictionary *biz, NSError *error) {
                
                if(error) {
                    NSLog(@"ERROR!!! %@", error);
                    return;
                }
                
                NSLog(@"Top business: %@", biz);
                _yelpData = biz;
                
                NSString* categoryName = biz[@"categories"][0][0];
                
                NSLog(@"Category Name: %@", categoryName);
                
                NSString* questionStr = [NSString stringWithFormat:@"How does %@ sound?", categoryName];
                
                FMQuestionViewController* confirmVC = [[FMQuestionViewController alloc] initWithQuestion:questionStr answers:@[@"Great, let's go!", @"No thanks"]];
                confirmVC.questionDelegate = self;
                [self dismissViewControllerAnimated:YES completion:^{
                    [self presentViewController:confirmVC animated:NO completion:nil];
                }];
                
            }];
        });
    }];
}

-(void)answerChosen:(NSString *)answer WithQuestion:(NSString *)question {
    
    NSMutableArray* categories = [NSMutableArray array];
    
    for (NSArray* cat in _yelpData[@"categories"]) {
        [categories addObject:cat[1]];
    }
    
    if ([answer  isEqual: @"Great, let's go!"]) {
        
        [[FMYelpHelper sharedInstance] mutateCoefficientsOnRespinWithCategories:categories andDidLike:YES];
        
        
        // Show restaurant / directions
        FMRestaurantViewController* vc = [[FMRestaurantViewController alloc] initWithDictionary:_yelpData];
        NSLog(@"%@",self.presentedViewController);
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:vc animated:NO completion:nil];
        }];
    }
    else {
        
        [[FMYelpHelper sharedInstance] mutateCoefficientsOnRespinWithCategories:categories andDidLike:NO];

        
        [self dismissViewControllerAnimated:YES completion:^{
//            [self chooseRestaurant];
//            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
//                [(FMTopLevelViewController *)self.presentingViewController reset];
//                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            
            NSLog(@"%@", self.presentingViewController.presentingViewController.presentingViewController.description);
            NSLog(@"%@", self.presentingViewController.presentingViewController.description);
            NSLog(@"%@", self.presentingViewController.description);
            
            [(FMTopLevelViewController *)self.presentingViewController reset];//dismissViewControllerAnimated:YES completion:^{
//                [(FMTopLevelViewController *)self.presentingViewController reset];
//                FMTopLevelViewController* topLvl = (FMTopLevelViewController *)self.presentingViewController;
//                FMSetupViewController* vc = [[FMSetupViewController alloc] init];
//                vc.setupDelegate = topLvl;
//                [topLvl presentViewController:vc animated:NO completion:nil];
//                
//                NSLog(@"Restarting stuff");
//            }];
        }];
    }
}
@end
