//
//  ViewController+NSMutableArray_Shuffling_h.m
//  FoodMe
//
//  Created by James Lennon on 11/13/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import "NSMutableArray_Shuffling.h"

@implementation NSMutableArray (Shuffling)

- (void)shuffle {
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end