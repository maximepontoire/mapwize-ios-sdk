#import "MWZGeometryFactory.h"

@implementation MWZGeometryFactory

+ (MWZGeometry*) geometryWithDictionary:(NSDictionary*) dictionary {
    
    NSString* type = dictionary[@"type"];
    if ([type isEqualToString:@"Polygon"]) {
        return [[MWZGeometryPolygon alloc] initWithDictionary:dictionary];
    }
    else if ([type isEqualToString:@"Point"]) {
        return [[MWZGeometryPoint alloc] initWithDictionary:dictionary];
    }
    else {
        return nil;
    }
    
}

@end
