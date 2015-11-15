//
//  ViewController+NSMutableArray_Shuffling_h.h
//  FoodMe
//
//  Created by James Lennon on 11/13/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>

// This category enhances NSMutableArray by providing
// methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end