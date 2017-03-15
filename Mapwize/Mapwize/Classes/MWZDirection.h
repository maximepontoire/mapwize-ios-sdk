#import <Foundation/Foundation.h>
#import "MWZDirectionResponsePoint.h"
#import "MWZBounds.h"
@class MWZParser;
#import "MWZRoute.h"

@interface MWZDirection : NSObject

@property(nonatomic, strong) MWZDirectionResponsePoint* from;
@property(nonatomic, strong) MWZDirectionResponsePoint* to;
@property(nonatomic) double distance;
@property(nonatomic, strong) NSArray<MWZRoute*>* route;
@property(nonatomic) double traveltime;
@property(nonatomic, strong) MWZBounds* bounds;
@property(nonatomic, strong) NSArray<MWZDirectionResponsePoint*>* waypoints;
@property(nonatomic, strong) NSArray<MWZDirection*>* subdirections;

- (instancetype)initFromDictionary:(NSDictionary*)dic;

- (NSString*) toStringJSON;

@end
