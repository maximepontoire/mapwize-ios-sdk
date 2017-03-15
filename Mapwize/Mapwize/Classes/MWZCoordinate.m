#import "MWZCoordinate.h"

@implementation MWZCoordinate

- (instancetype) initWithLatitude:(double) latitude longitude:(double) longitude floor:(NSNumber*) floor {
    self = [super init];
    _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    _floor = floor;
    return self;
}

- (instancetype) initWithArray:(NSArray*) array {
    self = [super init];
    _coordinate = CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);
    _floor = nil;
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary*) dic {
    self = [super init];
    _coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longitude"] doubleValue]);
    _floor = [dic objectForKey:@"floor"];
    return self;
}

- (CLLocationCoordinate2D) coordinate {
    return _coordinate;
}

- (double) latitude {
    return _coordinate.latitude;
}

- (double) longitude {
    return _coordinate.longitude;
}

- (NSNumber*) floor {
    return _floor;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    NSMutableArray* coords = [[NSMutableArray alloc] init];
    [coords addObject:[NSNumber numberWithDouble:_coordinate.latitude]];
    [coords addObject:[NSNumber numberWithDouble:_coordinate.longitude]];
    if (_floor != nil) {
        [dic setObject:_floor forKey:@"floor"];
    }
    return dic;
}

- (NSArray*) toArray {
    NSMutableArray* coords = [[NSMutableArray alloc] init];
    [coords addObject:[NSNumber numberWithDouble:_coordinate.latitude]];
    [coords addObject:[NSNumber numberWithDouble:_coordinate.longitude]];
    return coords;
}

- (NSString *)description {
    if (_floor != nil) {
        return [NSString stringWithFormat: @"MWZCoordinate: <%f,%f> Floor=%@", _coordinate.latitude, _coordinate.longitude, _floor];
    }
    else {
        return [NSString stringWithFormat: @"MWZCoordinate: <%f,%f>", _coordinate.latitude, _coordinate.longitude];
    }
    
}

- (NSDictionary*) toDirectionDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithDouble:_coordinate.latitude] forKey:@"lat"];
    [dic setObject:[NSNumber numberWithDouble:_coordinate.longitude] forKey:@"lon"];
    [dic setObject:_floor forKey:@"floor"];
    return dic;
}

- (NSString*) toDirectionStringJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDirectionDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
