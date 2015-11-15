//
//  FMDataLoader.m
//
//
//  Created by Marko Fejzo on 11/14/15.
//
//

#import "FMDataLoader.h"

@interface FMDataLoader ()

@property NSMutableArray<NSString *>* questionarray;
@property NSMutableArray<NSString *>* loadingarray;

@end

@implementation FMDataLoader

SINGLETON_IMPL(FMDataLoader);

- (instancetype) init
{
    if(self = [super init]) {
        
        NSString *questionfile = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"txt"];//Loads the question file
        NSString *questionstring = [NSString stringWithContentsOfFile:questionfile
                                                             encoding:NSUTF8StringEncoding error:NULL];//Converts the question file to string
        _questionarray = [[questionstring componentsSeparatedByString:@"#"] mutableCopy];//gets an array of each question
        
        NSString *loadingfile = [[NSBundle mainBundle] pathForResource:@"loadmessages" ofType:@"txt"];//Loads the loading file
        NSString *loadingstring = [NSString stringWithContentsOfFile:loadingfile
                                                            encoding:NSUTF8StringEncoding error:NULL];//Converts the loading file to string
        _loadingarray = [[loadingstring componentsSeparatedByString:@"\n"] mutableCopy];//gets an array of each loading message
    }
    return self;
}

//Gen question chooses a question randomly from the loaded file and chooses random answers, returning them in an array of strings
//index 1 is the question, next 2-3 indices are answers
- (NSMutableArray *) genQuestion
{
    NSString *randomquestion = [_questionarray objectAtIndex: arc4random_uniform(_questionarray.count-1)];//chooses a random question
    NSMutableArray *parsedquestion = [randomquestion componentsSeparatedByString:@"\n"];//separates the question into parts
    [parsedquestion removeObjectAtIndex: (parsedquestion.count-1)];
    return [self purgeAnswers: parsedquestion];//returns the question with 2-3 answers
}
//purgeAnswers takes in a parsed question array a randomly cleaves answers until the array holds a question in the 1st index and
//             2-3 answers in the 2, 3, and 4 indices.
- (NSMutableArray *) purgeAnswers:(NSMutableArray *)arr
{
    while (arr.count>4) {
        [arr removeObjectAtIndex: (arc4random_uniform(arr.count - 1) + 1)];
    }
    return arr;
}

- (NSString *) genLoadingMessage {
    return [_loadingarray objectAtIndex:arc4random_uniform(_loadingarray.count-1)];//chooses a random loading message from the list to return
}

@end