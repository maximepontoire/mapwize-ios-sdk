#import <Foundation/Foundation.h>
#import "MWZBounds.h"
#import "MWZCoordinate.h"

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

- (instancetype) init;

- (NSDictionary*) toDictionary;

- (NSString*) toJSONString;

@end
