#import <Foundation/Foundation.h>
#import "MWZLatLonBounds.h"
#import "MWZLatLon.h"

@interface MWZMapOptions : NSObject

@property NSString* apiKey;
@property MWZLatLonBounds* maxBounds;
@property MWZLatLon* center;
@property NSNumber* zoom;
@property NSNumber* floor;
@property BOOL locationEnabled;
@property BOOL beaconsEnabled;


- (instancetype) init;

@end
