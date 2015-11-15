//
//  FMTopLevelViewController.m
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import "FMTopLevelViewController.h"
#import "FMSetupViewController.h"
#import "FMColors.h"

@implementation FMTopLevelViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldSetup = YES;
    }
    return self;
}

-(void)viewDidLoad {
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _mainVC = [[FMMainViewController alloc] init];
}

-(void)viewDidAppear:(BOOL)animated {
    if (_shouldSetup) {
        _shouldSetup = NO;
        FMSetupViewController* vc = [[FMSetupViewController alloc] init];
        vc.setupDelegate = self;
        [self presentViewController:vc animated:NO completion:nil];
    }
}

-(void) reset
{
    [self dismissViewControllerAnimated:NO completion:^{
        FMSetupViewController* vc = [[FMSetupViewController alloc] init];
        vc.setupDelegate = self;
        [self presentViewController:vc animated:NO completion:nil];
    }];
}

-(void)setupCompleted {
    [self presentViewController:_mainVC animated:NO completion:nil];
}

@end