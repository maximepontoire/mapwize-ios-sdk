#import <Foundation/Foundation.h>

@interface MWZPlaceList : NSObject

@property NSString* identifier;
@property NSString* name;
@property NSString* alias;
@property NSString* venueId;
@property NSArray* placeIds;

- (instancetype)initFromDictionnary:(NSDictionary*)dic;

@end
