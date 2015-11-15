//
//  FMYelpHelper.h
//  YelpTester
//
//  Created by Jake Saferstein on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonHelper.h"

@interface FMYelpHelper : NSObject

SINGLETON_INTR(FMYelpHelper);

-(void)findTopBiz:(void (^)(NSDictionary *biz, NSError *error))completionHandler;
-(void) saveYelpData;

-(void) setSearchRadiusBasedOnTime: (NSString *)timeRange;
-(void) setPriceDescBasedOnResponse: (NSString *) response;
-(void) setMeal: (NSString *) mealDesc;
-(void) setIndexToPick: (int) ind;


-(void) mutateCoefficientsOnRespinWithCategories:(NSArray *)cats andDidLike:(BOOL)liked;
-(void) mutateCoeffsAfterEatingWithCategoriesToMutate:(NSArray *)mutcats andDidLike: (BOOL) liked;

@end
