#import "MWZGeometry.h"

@interface MWZGeometryPoint : MWZGeometry

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) MWZCoordinate* coordinate;

- (instancetype) initWithCoordinate:(MWZCoordinate*) coordinate;

- (instancetype) initWithDictionary:(NSDictionary*) dictionary;

- (NSString*) getType;

- (MWZCoordinate*) getCoordinates;

- (MWZBounds*) getBounds;

- (NSDictionary*) toDictionary;

@end
