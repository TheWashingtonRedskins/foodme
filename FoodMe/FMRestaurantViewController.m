//
//  FMRestaurantViewController.m
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import "FMRestaurantViewController.h"
#import "FMColors.h"
#import "FMButton.h"
#import "FMLocationHelper.h"
#import "FMYelpHelper.h"
#import "FMLabel.h"
#import "FMTopLevelViewController.h"

@interface FMRestaurantViewController ()

@property (nonatomic) FMButton* btn;

@end

@implementation FMRestaurantViewController

-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _data = dict;
    }
    return self;
}

-(void)viewDidLoad {
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    CGSize size = self.view.frame.size;
    _restaurantView = [[FMRestaurantView alloc] initWithFrame:CGRectMake(20, 50, size.width - 40, size.height / 2 - 100) Dictionary:_data];

    
//    UIImage *starImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_data[@"rating_img_url_large"]]]];
//    
//    UIImageView* starVw = [[UIImageView alloc] initWithImage:starImg];
//    starVw.frame = CGRectMake(20, size.height/2 - 100, size.width - 40, 50);
    
    _btn = [[FMButton alloc] initWithFrame:CGRectMake(20, _restaurantView.frame.origin.y + _restaurantView.frame.size.height + 10, size.width - 40, 100) completion:^{
        // TODO open maps
        NSDictionary* coords = _data[@"location"][@"coordinate"];
        NSLog(@"%@\n", coords);
        if (coords) {
            
            CLLocation* loc = [[FMLocationHelper sharedInstance] curLoc];
            
            NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@,%@", loc.coordinate.latitude, loc.coordinate.longitude, coords[@"latitude"], coords[@"longitude"]];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            
            self.view.userInteractionEnabled = YES;
            
            [_btn removeFromSuperview];
            [self createNewButtons];
        }
    }];
    [_btn setTitle:@"Go!" forState:UIControlStateNormal];
    
    [self.view addSubview:_restaurantView];
    [self.view addSubview:_btn];
//    [self.view addSubview:starVw];
}

-(void) createNewButtons
{
    NSMutableArray* categories = [NSMutableArray array];
    
    for (NSArray* cat in _data[@"categories"]) {
        [categories addObject:cat[1]];
    }
    
    CGSize size = self.view.frame.size;
    
    FMLabel* lbl = [[FMLabel alloc] initWithFrame:CGRectMake(20, _restaurantView.frame.origin.y + _restaurantView.frame.size.height + 10, size.width - 40, 100)];
    lbl.text = @"How was the restaurant?";
    
    FMButton* likeBtn = [[FMButton alloc] initWithFrame:CGRectMake(20, _restaurantView.frame.origin.y + _restaurantView.frame.size.height + 10 + 110, size.width - 40, 100) completion:^{
        
        [[FMYelpHelper sharedInstance] mutateCoeffsAfterEatingWithCategoriesToMutate:categories andDidLike:YES];
        
//        NSLog(@"%@",self.presentingViewController.presentingViewController.presentingViewController.description);
//        NSLog(@"%@",self.presentingViewController.presentingViewController.description);
//        NSLog(@"%@",self.presentingViewController.description);
        
        [(FMTopLevelViewController *)self.presentingViewController.presentingViewController reset];
        
//        [self dismissViewControllerAnimated:YES completion:^{
//            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
//                [(FMTopLevelViewController *)self.presentingViewController.presentingViewController reset];
//            }];
//        }];
    
    }];
    [likeBtn setTitle:@"Like" forState:UIControlStateNormal];
    
    FMButton* dislikeBtn = [[FMButton alloc] initWithFrame:CGRectMake(20, _restaurantView.frame.origin.y + _restaurantView.frame.size.height + 10 + 220, size.width - 40, 100) completion:^{
        
        [[FMYelpHelper sharedInstance] mutateCoeffsAfterEatingWithCategoriesToMutate:categories andDidLike:NO];
        
        [(FMTopLevelViewController *)self.presentingViewController.presentingViewController reset];
    }];
    [dislikeBtn setTitle:@"Dislike" forState:UIControlStateNormal];
    
    [self.view addSubview:likeBtn];
    [self.view addSubview:dislikeBtn];
    [self.view addSubview:lbl];
}

@end
