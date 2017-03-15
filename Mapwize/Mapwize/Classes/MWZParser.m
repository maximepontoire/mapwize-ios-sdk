#import "MWZParser.h"

@implementation MWZParser

+ (NSString*) serialize:(NSArray<id<MWZDirectionPoint>>*) positions {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (id<MWZDirectionPoint> p in positions) {
        [array addObject:[p toDirectionDictionary]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:(NSJSONWritingOptions) 0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSArray<MWZDirectionResponsePoint*>*) positionsFromArray:(NSArray<NSDictionary*>*) array {
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dic in array) {
        MWZDirectionResponsePoint* p = [[MWZDirectionResponsePoint alloc] initFromDictionary: dic];
        [arr addObject:p];
    }
    
    return arr;
    
}

+ (NSArray<MWZRoute*>*) routesFromArray:(NSArray*) array {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dic in array) {
        MWZRoute* p = [[MWZRoute alloc] initFromDictionary: dic];
        [arr addObject:p];
    }
    
    return arr;
    
}

+ (NSArray<MWZDirection*>*) subdirectionsFromArray:(NSArray*) array {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dic in array) {
        MWZDirection* p = [[MWZDirection alloc] initFromDictionary: dic];
        [arr addObject:p];
    }
    
    return arr;
}

@end
