#import "MWZSessionManager.h"
#import "MWZVenue.h"
#import "MWZPlace.h"
#import "MWZPlaceList.h"
#import "MWZDirectionOptions.h"
#import "MWZDirectionPoint.h"
#import "MWZDirection.h"
#import "MWZSearchParams.h"
#import "MWZUniverse.h"

@interface MWZApiManager : MWZSessionManager

@property(nonatomic, strong) NSString* apiKey;

/*
 Access request related method
*/
- (NSURLSessionDataTask *)getAccessWithAccessKey:(NSString *)accessKey success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/*
 Universes request related method
*/
- (NSURLSessionDataTask *)getUniversesForOrganizationId:(NSString *)organizationId success:(void (^)(NSArray<MWZUniverse*> *universes))success failure:(void (^)(NSError *error))failure;

/*
 Venues request related methods
*/
- (NSURLSessionDataTask *)getVenues:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZVenue*> *venues))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenuesForOrganizationId:(NSString *)organizationId success:(void (^)(NSArray<MWZVenue*> *venues))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenueWithId:(NSString *)requestId success:(void (^)(MWZVenue *venue))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenueWithName:(NSString *)name success:(void (^)(MWZVenue *venue))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenueWithAlias:(NSString *)alias success:(void (^)(MWZVenue *venue))success failure:(void (^)(NSError *error))failure;

/*
 Places request related methods
*/
- (NSURLSessionDataTask *)getPlaces:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZPlace*> *places))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceWithId:(NSString *)requestId success:(void (^)(MWZPlace *place))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceWithName:(NSString *)name inVenue:(MWZVenue*) venue success:(void (^)(MWZPlace *place))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceWithAlias:(NSString *)alias inVenue:(MWZVenue*) venue success:(void (^)(MWZPlace *place))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlacesForVenue:(MWZVenue *)venue withOptions:(NSDictionary*) options success:(void (^)(NSArray<MWZPlace*>* places))success failure:(void (^)(NSError *error))failure;

/*
 Places request related methods
*/
- (NSURLSessionDataTask *)getPlacesForPlaceList:(MWZPlaceList *)placeList success:(void (^)(NSArray<MWZPlace*>* places))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceLists:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZPlaceList*> *placeLists))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceListWithId:(NSString *)requestId success:(void (^)(MWZPlaceList *placeList))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceListWithName:(NSString *)name inVenue:(MWZVenue*) venue success:(void (^)(MWZPlaceList *placeList))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceListWithAlias:(NSString *)alias inVenue:(MWZVenue*) venue success:(void (^)(MWZPlaceList *placeList))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceListsForVenue:(MWZVenue *)venue success:(void (^)(NSArray<MWZPlaceList*>* placeLists))success failure:(void (^)(NSError *error))failure;

/*
 Directions request related methods
*/
- (NSURLSessionDataTask *)getDirectionsFrom:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to by: (NSArray<id<MWZDirectionPoint>>*) waypoints withOptions:(MWZDirectionOptions*) options success:(void (^)(MWZDirection *direction))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getDirectionsFrom:(id<MWZDirectionPoint>) from oneOfTo:(NSArray<id<MWZDirectionPoint>>*) to by: (NSArray<id<MWZDirectionPoint>>*) waypoints withOptions:(MWZDirectionOptions*) options success:(void (^)(MWZDirection *direction))success failure:(void (^)(NSError *error))failure;

/*
 Search request related method
*/
- (NSURLSessionDataTask *)search:(MWZSearchParams*) params success:(void (^)(NSArray<id>*)) success failure:(void (^)(NSError *error))failure;
    

@end
