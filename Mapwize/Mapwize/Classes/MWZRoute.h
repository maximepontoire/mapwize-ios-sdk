#import <Foundation/Foundation.h>
#import "MWZBounds.h"

@interface MWZRoute : NSObject

@property(nonatomic, strong) NSNumber* floor;
@property(nonatomic, strong) NSNumber* fromFloor;
@property(nonatomic, strong) NSNumber* toFloor;
@property(nonatomic) BOOL isStart;
@property(nonatomic) BOOL isEnd;
@property(nonatomic) double traveltime;
@property(nonatomic) double timeToEnd;
@property(nonatomic, strong) MWZBounds* bounds;
@property(nonatomic) double distance;
@property(nonatomic, strong) NSString* connectorTypeTo;
@property(nonatomic, strong) NSString* connectorTypeFrom;
@property(nonatomic, strong) NSArray* path;

- (instancetype)initFromDictionary:(NSDictionary*)dic;

- (NSDictionary*) toDictionary;

@end
