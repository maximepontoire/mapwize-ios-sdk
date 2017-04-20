#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MWZCoordinate.h"
#import "MWZBounds.h"

@interface MWZGeometry : NSObject

- (NSString*) getType;

- (id) getCoordinates;

- (instancetype) initWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) toDictionary;

- (MWZBounds*) getBounds;

@end
