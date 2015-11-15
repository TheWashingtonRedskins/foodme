//
//  FMYelpHelper.m
//  YelpTester
//
//  Created by Jake Saferstein on 11/14/15.
//  Copyright © 2015 Jake Saferstein. All rights reserved.
//

#import "FMYelpHelper.h"
#import "NSURLRequest+OAuth.h"
#import "FMLocationHelper.h"

@interface FMYelpHelper ()

@property (nonatomic) NSUserDefaults* dflts;
@property (nonatomic) NSMutableDictionary* yelpData;

@property (nonatomic) NSString* priceDesc;
@property (nonatomic) double radiusInMeters;
@property (nonatomic) NSString* mealDesc;

@property (nonatomic) int indexToPick;

//_prompts = @[
//@"We'll need to ask you a few questions to get set up.",
//@"What's your price range?",
//@"How far away do you want to eat?",
//];
//_options = @[
//@[@"Ok"],
//@[@"$5-$10", @"$10-$20", @"$20-$40"],
//@[@"5 - 10 min", @"10 - 20 min", @"20 - 40 min"]
//];

@end

@implementation FMYelpHelper

SINGLETON_IMPL(FMYelpHelper);

/**
 Default paths and search terms used in this example
 */
static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"3";

-(instancetype) init
{
    if(self = [super init]) {
        
        _dflts = [NSUserDefaults standardUserDefaults];
        
        [self loadYelpData];
    }
    return self;
}

#pragma mark - Data Processing

-(void)setIndexToPick:(int)ind
{
    _indexToPick = ind;
}

-(void) setMeal:(NSString *)mealDesc
{
    _mealDesc = mealDesc;
}

-(void) setSearchRadiusBasedOnTime:(NSString *)timeRange
{
#warning fix this later...
    if([timeRange isEqualToString:@"5 - 10 min"]) {
        
        _radiusInMeters = 801.45331;
    }
    else if([timeRange isEqualToString:@"10 - 20 min"]) {
        
        _radiusInMeters = 801.45331 * 2;
    }
    else {
        _radiusInMeters = 801.45331 * 4;
    }
}

-(void)setPriceDescBasedOnResponse:(NSString *)response
{
    if ([response isEqualToString:@"$5-$10"]) {
        _priceDesc = @"Inexpensive";
    }
    else if ([response isEqualToString:@"$11-$30"]) {
        _priceDesc = @"Moderate";
    }
    else {
        _priceDesc = @"Pricey";
    }
}

-(void) mutateCoeffsAfterEatingWithCategoriesToMutate:(NSArray *)mutcats andDidLike: (BOOL) liked
{
    if(liked) {
        
        for (NSString* str in mutcats) {
            _yelpData[str] = @([[_yelpData valueForKey:str] doubleValue] + arc4random_uniform(3));
        }
    }
    else {
        
        for (NSString* str in mutcats) {
            
            if([_yelpData[str] doubleValue] > 100) {
                
                _yelpData[str] = @([[_yelpData valueForKey:str] doubleValue] * 0.95);
            }
            else {
                
                _yelpData[str] = @([[_yelpData valueForKey:str] doubleValue] * 0.9 - 5);
            }
        }
        
        _yelpData[@"ratingCoeff"] = @([_yelpData[@"ratingCoeff"] doubleValue] + arc4random_uniform(10)-5);
        _yelpData[@"searchRankingCoeff"]= @([_yelpData[@"searchRankingCoeff"] doubleValue] + arc4random_uniform(8)-4);
        _yelpData[@"distanceCoeff"]= @([_yelpData[@"distanceCoeff"] doubleValue] + arc4random_uniform(6)-3);
    }
    
    [self saveYelpData];
}

-(void) mutateCoefficientsOnRespinWithCategories:(NSArray *)cats andDidLike:(BOOL)liked
{
    for (NSString* str in cats) {
        
        if(liked) {
            
            _yelpData[str] = @([[_yelpData valueForKey:str] doubleValue] + 5);
        }
        else {
            if([_yelpData[str] doubleValue] > 100) {
                _yelpData[str] = @([[_yelpData valueForKey:str] doubleValue] * 0.9);
            }
            else {
                _yelpData[str] = @([[_yelpData valueForKey:str] doubleValue] * 0.7 - 5);
            }
        }
    }
    
    [self saveYelpData];
}

-(void)findTopBiz:(void (^)(NSDictionary *biz, NSError *error))completionHandler
{
    [self chooseRankingWithRadius:_radiusInMeters andMealTime:_mealDesc andMealPriceDesc:_priceDesc
     andCompletionHandler: ^(NSArray *bizzes, NSArray* rankings, NSError *error) {
         
         if(bizzes.count == 0) {
             completionHandler(nil, [NSError errorWithDomain:@"No biz. found" code:1023 userInfo:nil]);
             return;
         }
         
         NSMutableArray* toTupleArray = [NSMutableArray array];
         
         int i = 0;
         for (NSDictionary* biz in bizzes) {
             [toTupleArray addObject: @[biz, rankings[i]]];
             i++;
         }
         
         NSArray* sortedArray;
         sortedArray = [toTupleArray sortedArrayUsingComparator:^NSComparisonResult(NSArray* a, NSArray* b) {
             double rank1 = [a[1] doubleValue];
             double rank2 = [b[1] doubleValue];
             
             return rank1 > rank2;
         }];
         
         if(_indexToPick < sortedArray.count) {
             completionHandler(sortedArray[_indexToPick][0], error);
         }
         else {
             completionHandler(sortedArray[0][0], error);
         }
     }];
}

-(void)chooseRankingWithRadius: (double) meters andMealTime: (NSString *)mealString andMealPriceDesc: (NSString *)priceDesc
          andCompletionHandler: (void (^)(NSArray *bizzes, NSArray* rankings, NSError *error))completionHandler
{
    [[FMYelpHelper sharedInstance] queryRestsWithLocation:[FMLocationHelper sharedInstance].locality andRadiusInMeters:meters andTerm:mealString andLimit:5 andPriceDescription:priceDesc completionHandler:^(NSArray *results, NSError *error) {
        
        NSLog(@"%@", results);
        
        NSMutableArray* rankings = [NSMutableArray array];
        int searchRanking = 1;
        
        for (NSDictionary* biz in results) {
            
            [rankings addObject: @([self makeRankingForRest:biz andRankInSearch:searchRanking])];
            searchRanking++;
        }
        NSLog(@"%@", rankings);
        
        completionHandler(results, rankings, error);
    }];
}


//rating*log(#ratings) + friend recommendations - friend dislikes -distance  + (yelp categories)
-(double) makeRankingForRest: (NSDictionary* )biz andRankInSearch: (int) searchRanking
{
    //Have coefficients stored in _yelpData
    //still need: biz ranking, num rankings, rank in search, distance, categories its in.
    double bizRating = [biz[@"rating"] doubleValue];
    int numRatings = [biz[@"review_count"] intValue];
    double distance = [biz[@"distance"] doubleValue];
#warning make sure distance works
    
    double sumCatCoeffs = 0;
    NSArray* categories = biz[@"categories"];
    for (NSArray* cat in categories) {
        
        sumCatCoeffs += [_yelpData[cat[1]] doubleValue];
    }
    
    double avgCatCoeff = sumCatCoeffs / categories.count;
    
    double adjustedRating = [_yelpData[@"ratingCoeff"] doubleValue] * bizRating * log(numRatings);
    double adjustedDistance = [_yelpData[@"distanceCoeff"] doubleValue] * distance;
    double adjustedSearchRanking = [_yelpData[@"searchRankingCoeff"] doubleValue] *searchRanking;
    
    return adjustedRating + adjustedDistance - adjustedSearchRanking + avgCatCoeff;
}

#pragma mark - Data Storage/Loading

- (void) loadYelpData
{
    NSDictionary* yelpData = [_dflts objectForKey:@"yelpData"];
    
    if(!yelpData) {
        
        NSMutableDictionary* newData = [NSMutableDictionary dictionary];
        
        newData[@"ratingCoeff"] = @(50);
        newData[@"searchRankingCoeff"] = @(30);
        newData[@"distanceCoeff"] = @(25);
        newData[@"categoryCoeffs"] = @{}; //This will be updated every search to autofill categoreis instead of manual input of each category.;
        
        _yelpData = newData;
        
        [self saveYelpData];
    }
    else {
        _yelpData = [NSMutableDictionary dictionaryWithDictionary:yelpData];
    }
}

-(void) createCategoryIfNeeded: (NSString *)catName
{
    if (!_yelpData[@"categoryCoeffs"][catName]) {
        
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:_yelpData[@"categoryCoeffs"]];
        [newDict setObject:@(110) forKey:catName];
        _yelpData[@"categoryCoeffs"] = newDict;
    }
}

- (void) updateCategoryInfoWithArray: (NSArray *)bizzes
{
    for (NSDictionary* biz in bizzes) {
        
        for (NSArray* category in biz[@"categories"]) {
            //Category is an array of size 2, with a category name and an alias that is searchable in filters
            //We save the alias name in case we want to search with this later.
            
            [self createCategoryIfNeeded:category[1]];
        }
    }
}

- (void) saveYelpData
{
    [_dflts setObject:_yelpData forKey:@"yelpData"];
}


#pragma mark - Querying Work

- (void) queryRestsWithLocation: (NSString *)location andRadiusInMeters: (double) meters andTerm: (NSString *)term andLimit: (int) limit andPriceDescription: (NSString *)price
              completionHandler:(void (^)(NSArray *results, NSError *error))completionHandler
{
    NSLog(@"Querying the stuff");
    
    NSString* newTerm = [NSString stringWithFormat:@"%@ %@", price, term];
    
    
    double lat = [FMLocationHelper sharedInstance].curLoc.coordinate.latitude;
    double longit = [FMLocationHelper sharedInstance].curLoc.coordinate.longitude;
    
    NSURLRequest *searchRequest = [self createSearchWithLocation:location andRadiusInMeters:meters andTerm:newTerm andLimit:limit andLat:lat andLong:longit];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error && httpResponse.statusCode == 200) {
            
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            
            if (businessArray.count > 0) {
                
                NSArray* filteredBiz = [self filterArray:businessArray];
                NSLog(@"Filtered Array %@", filteredBiz);
                
                [self updateCategoryInfoWithArray: filteredBiz];
                
                completionHandler(filteredBiz, error);
            }
            else {
                completionHandler(nil, error); // No business was found
            }
        }
        else {
            completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}

- (NSMutableArray *) filterArray: (NSArray *)bizzes
{
    NSMutableArray* toRet = [NSMutableArray array];
    
    for (NSDictionary* biz in bizzes) {
        
        int isClosed = [biz[@"is_closed"] intValue];
        
        if (isClosed == 0) {
            [toRet addObject:biz];
        }
    }
    
    return toRet;
}

- (NSURLRequest *) createSearchWithLocation: (NSString *)location andRadiusInMeters: (double) meters andTerm: (NSString *)term andLimit: (int) limit andLat: (double) latitude andLong: (double) longitude
{
    NSDictionary* params = @{
                             @"location": location,
                             @"limit": [NSString stringWithFormat:@"%i",limit],
                             @"term": term,
                             @"radius_filter": [NSString stringWithFormat:@"%f", meters],
                             @"cll": [NSString stringWithFormat:@"%f,%f", latitude,longitude],
                             @"category_filter":@"food",
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

/**
 Builds a request to hit the search endpoint with the given parameters.
 
 @param term The term of the search, e.g: dinner
 @param location The location request, e.g: San Francisco, CA
 
 @return The NSURLRequest needed to perform the search
 */
- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term location:(NSString *)location {
    NSDictionary *params = @{
                             @"term": term,
                             @"location": location,
                             @"limit": kSearchLimit
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

@end