#import <Foundation/Foundation.h>
#import "MWZBounds.h"
#import "MWZCoordinate.h"
#import "MWZCustomMarkerOptions.h"

@interface MWZMapOptions : NSObject

@property(nonatomic, strong) NSString* apiKey;
@property(nonatomic, strong) MWZBounds* maxBounds;
@property(nonatomic, strong) MWZBounds* bounds;
@property(nonatomic, strong) MWZCoordinate* center;
@property(nonatomic, strong) NSNumber* zoom;
@property(nonatomic, strong) NSNumber* minZoom;
@property(nonatomic, strong) NSNumber* floor;
@property(nonatomic) BOOL locationEnabled;
@property(nonatomic) BOOL beaconsEnabled;
@property(nonatomic) BOOL showUserPositionControl;
@property(nonatomic, strong) NSString* accessKey;
@property(nonatomic, strong) NSString* language;
@property(nonatomic) BOOL displayFloorControl;
@property(nonatomic, strong) MWZCustomMarkerOptions* displayMarkerOptions;
@property(nonatomic, strong) NSString* mainColor;

- (instancetype) init;

- (NSDictionary*) toDictionary;

- (NSString*) toJSONString;

@end
