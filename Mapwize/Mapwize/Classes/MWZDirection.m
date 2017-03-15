#import "MWZDirection.h"
#import "MWZParser.h"

@implementation MWZDirection

- (instancetype)initFromDictionary:(NSDictionary*)dic {
    self = [super init];
    
    _from = [[MWZDirectionResponsePoint alloc] initFromDictionary:[dic objectForKey:@"from"]];
    _to = [[MWZDirectionResponsePoint alloc] initFromDictionary:[dic objectForKey:@"to"]];
    _distance =  [[dic objectForKey:@"distance"] doubleValue];
    _traveltime =  [[dic objectForKey:@"traveltime"] doubleValue];
    _bounds = [[MWZBounds alloc] initWithArray:[dic objectForKey:@"bounds"]];
    _waypoints = [MWZParser positionsFromArray:[dic objectForKey:@"waypoints"]];
    _route = [MWZParser routesFromArray:[dic objectForKey:@"route"]];
    _subdirections = [MWZParser subdirectionsFromArray:[dic objectForKey:@"subdirections"]];
    
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithDouble:_distance] forKey:@"distance"];
    [dic setObject:[NSNumber numberWithDouble:_traveltime] forKey:@"traveltime"];
    if (_from != nil) {
        [dic setObject:[_from toDictionary] forKey:@"from"];
    }
    if (_to != nil) {
        [dic setObject:[_to toDictionary] forKey:@"to"];
    }
    if (_bounds != nil) {
        [dic setObject:[_bounds toArray] forKey:@"bounds"];
    }
    if (_route != nil) {
        NSMutableArray* a = [[NSMutableArray alloc] init];
        for (MWZRoute* p in _route) {
            NSDictionary* d = [p toDictionary];
            [a addObject:d];
        }
        [dic setObject:a forKey:@"route"];
    }
    if (_waypoints != nil) {
        NSMutableArray* a = [[NSMutableArray alloc] init];
        for (MWZDirectionResponsePoint* p in _waypoints) {
            NSDictionary* d = [p toDictionary];
            [a addObject:d];
        }
        [dic setObject:a forKey:@"waypoints"];
    }
    if (_subdirections != nil) {
        NSMutableArray* a = [[NSMutableArray alloc] init];
        for (MWZDirection* p in _subdirections) {
            NSDictionary* d = [p toDictionary];
            [a addObject:d];
        }
        [dic setObject:a forKey:@"subdirections"];
    }
    
    return dic;
}

- (NSString*) toStringJSON {
    
    NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
    
    return userPositionString;
}

@end
