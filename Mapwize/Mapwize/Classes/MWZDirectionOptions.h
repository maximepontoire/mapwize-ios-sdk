#import <Foundation/Foundation.h>

@interface MWZDirectionOptions : NSObject

@property(nonatomic) BOOL isAccessible;
@property(nonatomic) BOOL waypointOptimize;


- (instancetype) init;

- (NSString*) toStringJSON;

- (NSDictionary*) toDictionary;


@end
