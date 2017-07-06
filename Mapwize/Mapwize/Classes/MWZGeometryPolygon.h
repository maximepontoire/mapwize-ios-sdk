#import "MWZGeometry.h"

@interface MWZGeometryPolygon : MWZGeometry

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSArray<MWZCoordinate*>* coordinates;

- (instancetype) init;
    
- (instancetype) initWithCoordinates:(NSArray*) coordinates;

- (instancetype) initWithDictionary:(NSDictionary*) dictionary;

- (NSString*) getType;

- (NSArray*) getCoordinates;

- (MWZBounds*) getBounds;

- (NSDictionary*) toDictionary;

@end
