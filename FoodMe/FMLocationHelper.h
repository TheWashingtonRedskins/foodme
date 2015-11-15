//
//  FMLocationHelper.h
//  FoodMe
//
//  Created by Jake Saferstein on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonHelper.h"

@import CoreLocation;

@interface FMLocationHelper : NSObject <CLLocationManagerDelegate>

SINGLETON_INTR(FMLocationHelper);

-(void) startTrackingLocation;

@property (nonatomic) CLLocation* curLoc;
@property (nonatomic) NSString* locality;

@end
