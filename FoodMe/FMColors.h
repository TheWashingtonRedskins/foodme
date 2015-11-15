//
//  FMColors.h
//  FoodMe
//
//  Created by James Lennon on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#ifndef FMColors_h
#define FMColors_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BACKGROUND_COLOR UIColorFromRGB(0xc0392b)
#define TEXT_COLOR UIColorFromRGB(0xecf0f1)

// 0xc0392b

#endif /* FMColors_h */
