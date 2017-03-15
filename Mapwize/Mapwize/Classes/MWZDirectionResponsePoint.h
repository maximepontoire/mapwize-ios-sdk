#import <Foundation/Foundation.h>

@interface MWZDirectionResponsePoint : NSObject

@property(nonatomic, strong) NSNumber* latitude;
@property(nonatomic, strong) NSNumber* longitude;
@property(nonatomic, strong) NSNumber* floor;
@property(nonatomic, strong) NSString* placeId;
@property(nonatomic, strong) NSString* venueId;
@property(nonatomic, strong) NSString* placeListId;

- (instancetype) initWithPlaceId: (NSString*) placeId;

- (instancetype) initWithVenueId: (NSString*) venueId;

- (instancetype) initWithPlaceListId: (NSString*) placeListId;

- (instancetype) initWithLatitude: (NSNumber*) latitude longitude: (NSNumber*) longitude floor:(NSNumber*) floor;

- (instancetype) initFromDictionary:(NSDictionary*)dic;

- (NSString*) toStringJSON;

- (NSDictionary*) toDictionary;

@end
