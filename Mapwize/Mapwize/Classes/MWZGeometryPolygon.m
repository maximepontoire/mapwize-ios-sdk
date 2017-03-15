#import "MWZGeometryPolygon.h"

@implementation MWZGeometryPolygon

- (instancetype) initWithCoordinates:(NSArray*) coordinates {
    self = [super init];
    _type = @"Polygon";
    _coordinates = coordinates;
    return self;
    
}

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    _type = @"Polygon";
    NSMutableArray* coordinates = [[NSMutableArray alloc] init];
    NSArray* coordinatesJson = dictionary[@"coordinates"][0];
    for (NSArray* coordinateJson in coordinatesJson) {
        MWZCoordinate* coordinate = [[MWZCoordinate alloc] initWithArray:coordinateJson];
        [coordinates addObject:coordinate];
    }
    _coordinates = [NSArray arrayWithArray:coordinates];
    return self;
}


- (NSString*) getType {
    return _type;
}

- (NSArray*) getCoordinates {
    return _coordinates;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_type forKey:@"type"];
    NSMutableArray* coords = [[NSMutableArray alloc] init];
    for (MWZCoordinate* coord in _coordinates) {
        [coords addObject:[coord toDictionary]];
    }
    [dic setObject:coords forKey:@"coordinates"];
    return dic;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZGeometry Type=%@ Coordinates=%@", _type, _coordinates];
}

@end
