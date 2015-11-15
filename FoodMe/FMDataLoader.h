//
//  FMDataLoader.h
//
//
//  Created by Marko Fejzo on 11/14/15.
//
//

#import <Foundation/Foundation.h>
#import "SingletonHelper.h"

@interface FMDataLoader : NSObject

SINGLETON_INTR(FMDataLoader);

- (NSMutableArray *) genQuestion;
- (NSString *) genLoadingMessage;

@end