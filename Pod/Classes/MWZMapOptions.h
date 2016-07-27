#import <Foundation/Foundation.h>
#import "MWZLatLonBounds.h"
#import "MWZLatLon.h"

@interface MWZMapOptions : NSObject

@property NSString* apiKey;
@property MWZLatLonBounds* maxBounds;
@property MWZLatLon* center;
@property NSNumber* zoom;
@property NSNumber* minZoom;
@property NSNumber* floor;
@property BOOL locationEnabled;
@property BOOL beaconsEnabled;
@property NSString* accessKey;
@property NSString* language;

- (instancetype) init;

@end
