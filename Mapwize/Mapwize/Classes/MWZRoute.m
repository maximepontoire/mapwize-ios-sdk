#import "MWZRoute.h"

@implementation MWZRoute

- (instancetype)initFromDictionary:(NSDictionary*)dic {
    self = [super init];
    
    _floor = [dic objectForKey:@"floor"];
    _fromFloor = [dic objectForKey:@"fromFloor"];
    _toFloor = [dic objectForKey:@"toFloor"];
    _isStart = [[dic objectForKey:@"isStart"] boolValue];
    _isEnd = [[dic objectForKey:@"isEnd"] boolValue];
    _distance =  [[dic objectForKey:@"distance"] doubleValue];
    _traveltime =  [[dic objectForKey:@"traveltime"] doubleValue];
    _bounds = [[MWZBounds alloc] initWithArray:[dic objectForKey:@"bounds"]];
    _timeToEnd =  [[dic objectForKey:@"timeToEnd"] doubleValue];
    _connectorTypeTo = [dic objectForKey:@"connectorTypeTo"];
    _connectorTypeFrom = [dic objectForKey:@"connectorTypeFrom"];
    _path = [dic objectForKey:@"path"];
    
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithDouble:_distance] forKey:@"distance"];
    [dic setObject:[NSNumber numberWithDouble:_traveltime] forKey:@"traveltime"];
    [dic setObject:[NSNumber numberWithDouble:_timeToEnd] forKey:@"timeToEnd"];
    if (_connectorTypeTo != nil) {
        [dic setObject:_connectorTypeTo forKey:@"connectorTypeTo"];
    }
    if (_connectorTypeFrom != nil) {
        [dic setObject:_connectorTypeFrom forKey:@"connectorTypeFrom"];
    }
    [dic setObject:[NSNumber numberWithBool:_isStart] forKey:@"isStart"];
    [dic setObject:[NSNumber numberWithBool:_isEnd] forKey:@"isEnd"];
    [dic setObject:_path forKey:@"path"];
    [dic setObject:_floor forKey:@"floor"];
    [dic setObject:_toFloor forKey:@"toFloor"];
    [dic setObject:_fromFloor forKey:@"fromFloor"];
    if (_bounds != nil) {
        [dic setObject:[_bounds toArray] forKey:@"bounds"];
    }
    
    return dic;
}

@end
