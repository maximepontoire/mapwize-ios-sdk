#import <Foundation/Foundation.h>
#import "MWZGeometry.h"
#import "MWZGeometryPoint.h"
#import "MWZGeometryPolygon.h"

@interface MWZGeometryFactory : NSObject

+ (MWZGeometry*) geometryWithDictionary:(NSDictionary*) dictionary;

@end
