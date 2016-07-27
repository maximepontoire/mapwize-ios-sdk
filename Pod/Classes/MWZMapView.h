#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"
#import "MWZLatLonBounds.h"
#import "MWZPlace.h"
#import "MWZVenue.h"
#import "MWZPosition.h"
#import "MWZMeasurement.h"
#import "MWZPlaceStyle.h"
#import "MWZPlaceList.h"

@interface MWZMapView : UIView  <WKNavigationDelegate, WKScriptMessageHandler, CLLocationManagerDelegate>

@property id<MWZMapDelegate> delegate;
@property CLLocationManager* locationManager;

- (void) loadMapWithOptions: (MWZMapOptions*) options;

- (void) fitBounds:(MWZLatLonBounds*) bounds;

- (void) centerOnCoordinates: (NSNumber*) lat longitude: (NSNumber*) lon floor: (NSNumber*) floor zoom: (NSNumber*) zoom;
- (void) setFloor: (NSNumber*) floor;
- (NSNumber*) getFloor;
- (NSArray*) getFloors;
- (void) setZoom: (NSNumber*) zoom;
- (NSNumber*) getZoom;
- (MWZLatLon*) getCenter;

- (void) centerOnVenue: (MWZVenue*) venue;
- (void) centerOnVenueById: (NSString*) venueId;
- (void) centerOnPlace: (MWZPlace*) place;
- (void) centerOnPlaceById: (NSString*) placeId;

- (BOOL) getFollowUserMode;
- (void) setFollowUserMode: (BOOL) follow;

- (void) centerOnUser: (NSNumber*) zoom;
- (MWZMeasurement*) getUserPosition;
- (void) removeUserPosition;
- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor;
- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy;
- (void) newUserPositionMeasurement: (MWZMeasurement*) measurement;
- (void) setUserHeading: (NSNumber*) heading;
- (void) unlockUserPosition;
- (void) startLocationWithBeacons:(BOOL) useBeacons;
- (void) stopLocation;

- (void) loadURL: (NSString*) url completionHandler:(void(^)(NSError*)) handler ;

- (void) addMarkerWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor;
- (void) addMarkerWithPlaceId: (NSString*) placeId;
- (void) removeMarkers;

- (void) showDirectionsFrom: (MWZPosition*) from to: (MWZPosition*) to completionHandler:(void(^)(NSError*)) handler;;
- (void) stopDirections;

- (void) access: (NSString*) accessKey completionHandler:(void(^)(BOOL)) handler;
- (void) setPreferredLanguage: (NSString*) language;

- (void) setStyle: (MWZPlaceStyle*) style forPlaceById: (NSString*) placeId;
- (void) setBottomMargin: (NSNumber*) margin;
- (void) setTopMargin: (NSNumber*) margin;


- (void) getPlaceWithId: (NSString*) placeId completionHandler:(void(^)(MWZPlace*, NSError*)) handler;
- (void) getPlaceWithAlias: (NSString*) placeAlias inVenue: (NSString*) venueId completionHandler:(void(^)(MWZPlace*, NSError*)) handler;
- (void) getPlaceWithName: (NSString*) placeName inVenue: (NSString*) venueId completionHandler:(void(^)(MWZPlace*, NSError*)) handler;

- (void) getVenueWithId: (NSString*) venueId completionHandler:(void(^)(MWZVenue*, NSError*)) handler;
- (void) getVenueWithName: (NSString*) venueName completionHandler:(void(^)(MWZVenue*, NSError*)) handler;
- (void) getVenueWithAlias: (NSString*) venueAlias completionHandler:(void(^)(MWZVenue*, NSError*)) handler;

- (void) getPlaceListWithId: (NSString*) placeListId completionHandler:(void(^)(MWZPlaceList*, NSError*)) handler;
- (void) getPlaceListWithName: (NSString*) placeListId inVenue:(NSString*) venueId completionHandler:(void(^)(MWZPlaceList*, NSError*)) handler;
- (void) getPlaceListWithAlias: (NSString*) placeListId inVenue:(NSString*) venueId completionHandler:(void(^)(MWZPlaceList*, NSError*)) handler;
- (void) getPlaceListsForVenue: (NSString*) venueId completionHandler:(void(^)(NSArray*, NSError*)) handler;
- (void) getPlacesWithPlaceListId: (NSString*) placeListId completionHandler:(void(^)(NSArray*, NSError*)) handler;

- (void) refresh;

- (void) executeJS:(NSString*) js;

@end
