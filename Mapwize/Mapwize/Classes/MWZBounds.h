#import <Foundation/Foundation.h>
#import "MWZCoordinate.h"

@interface MWZBounds : NSObject

@property (nonatomic, retain) MWZCoordinate* southWest;
@property (nonatomic, retain) MWZCoordinate* northEast;

- (instancetype) initWithSouthWest:(MWZCoordinate*) sw northEast:(MWZCoordinate*) ne;

- (instancetype)initWithArray:(NSArray*) array;

- (CLLocationCoordinate2D) getCenter;

- (NSDictionary*) toDictionary;

- (NSArray*) toArray;

@end
