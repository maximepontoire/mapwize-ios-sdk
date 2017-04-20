#import "MWZGeometryPoint.h"

@implementation MWZGeometryPoint

- (instancetype) initWithCoordinate:(MWZCoordinate*) coordinate {
    self = [super init];
    _type = @"Point";
    _coordinate = coordinate;
    return self;

}

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    _type = @"Point";
    MWZCoordinate* coordinate = [[MWZCoordinate alloc] initWithArray:dictionary[@"coordinates"]];
    _coordinate = coordinate;
    return self;
}


- (NSString*) getType {
    return _type;
}

- (MWZCoordinate*) getCoordinates {
    return _coordinate;
}

- (MWZBounds*) getBounds {
    return [[MWZBounds alloc] initWithSouthWest:_coordinate northEast:_coordinate];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_type forKey:@"type"];
    [dic setObject:[_coordinate toDictionary] forKey:@"coordinates"];
    return dic;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZGeometry Type=%@ Coordinate=%@", _type, _coordinate];
}

@end
