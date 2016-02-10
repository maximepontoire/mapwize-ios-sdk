#import <Foundation/Foundation.h>

@interface MWZLatLon : NSObject

@property double latitude;
@property double longitude;

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude;
- (instancetype)initFromDictionnary:(NSDictionary*)dic;
- (instancetype)initFromArray:(NSArray*)array;
- (instancetype)initFromLeaflet:(NSString*)json;

- (NSArray*) toArray;

@end
