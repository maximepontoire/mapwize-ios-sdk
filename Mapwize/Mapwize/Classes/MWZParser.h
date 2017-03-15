#import <Foundation/Foundation.h>
#import "MWZDirectionResponsePoint.h"
#import "MWZRoute.h"
#import "MWZDirection.h"

@interface MWZParser : NSObject

+ (NSString*) serialize:(NSArray<id<MWZDirectionPoint>>*) positions;

+ (NSArray<MWZDirectionResponsePoint*>*) positionsFromArray:(NSArray*) array;

+ (NSArray<MWZRoute*>*) routesFromArray:(NSArray*) array;

+ (NSArray<MWZDirection*>*) subdirectionsFromArray:(NSArray*) array;

@end
