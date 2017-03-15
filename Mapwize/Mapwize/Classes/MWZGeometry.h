#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MWZCoordinate.h"

@interface MWZGeometry : NSObject

- (NSString*) getType;

- (id) getCoordinates;

- (instancetype) initWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) toDictionary;

@end
