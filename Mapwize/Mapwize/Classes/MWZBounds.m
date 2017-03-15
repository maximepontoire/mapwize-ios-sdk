#import "MWZBounds.h"

@implementation MWZBounds

- (instancetype) initWithSouthWest:(MWZCoordinate*) sw northEast:(MWZCoordinate*) ne {
    self = [super init];
    _southWest = sw;
    _northEast = ne;
    return self;
}

- (instancetype)initWithArray:(NSArray*) array {
    MWZCoordinate* sw = [[MWZCoordinate alloc] initWithLatitude:[array[0] doubleValue] longitude:[array[1] doubleValue] floor:nil];
    MWZCoordinate* ne = [[MWZCoordinate alloc] initWithLatitude:[array[2] doubleValue] longitude:[array[3] doubleValue] floor:nil];
    _northEast = ne;
    _southWest = sw;
    return self;
}

- (CLLocationCoordinate2D) getCenter {
    double latitude = (_southWest.latitude + _northEast.latitude)/2.;
    double longitude = (_southWest.longitude + _northEast.longitude)/2.;
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[_southWest toDictionary] forKey:@"southWest"];
    [dic setObject:[_northEast toDictionary] forKey:@"northEast"];
    return dic;
}

- (NSArray*) toArray {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObject:[_southWest toArray]];
    [arr addObject:[_northEast toArray]];
    return arr;
}

- (NSString*) description {
    return [NSString stringWithFormat: @"MWZBounds SW=%@ NE=%@", _southWest, _northEast];
}

@end
