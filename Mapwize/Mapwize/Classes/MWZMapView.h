#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MWZUserPosition.h"
#import "MWZBounds.h"
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"
#import "MWZPlace.h"
#import "MWZVenue.h"
#import "MWZMeasurement.h"
#import "MWZStyle.h"
#import "MWZPlaceList.h"
#import "MWZDirectionOptions.h"
#import "MWZDirection.h"
#import "MWZUniverse.h"

@interface MWZMapView : UIView  <WKNavigationDelegate, WKScriptMessageHandler, CLLocationManagerDelegate>

@property (nonatomic,weak) id<MWZMapDelegate> delegate;
@property (nonatomic, strong) CLLocationManager* locationManager;

- (void) loadMapWithOptions: (MWZMapOptions*) options;

- (void) fitBounds:(MWZBounds*) bounds;

- (void) setFloor: (NSNumber*) floor;
- (NSNumber*) getFloor;
- (NSArray*) getFloors;

- (void) setZoom: (NSNumber*) zoom;
- (NSNumber*) getZoom;

- (MWZCoordinate*) getCenter;

- (void) centerOnCoordinates: (MWZCoordinate*) coordinate withZoom:(NSNumber*) zoom;
- (void) centerOnCoordinates: (NSNumber*) lat longitude: (NSNumber*) lon floor: (NSNumber*) floor zoom: (NSNumber*) zoom
__attribute__((deprecated("Use centerOnCoordinate:withZoom instead")));
- (void) centerOnVenue: (MWZVenue*) venue;
- (void) centerOnVenueById: (NSString*) venueId;
- (void) centerOnPlace: (MWZPlace*) place;
- (void) centerOnPlaceById: (NSString*) placeId;
- (void) centerOnUser: (NSNumber*) zoom;

- (BOOL) getFollowUserMode;
- (void) setFollowUserMode: (BOOL) follow;

- (void) setUniverseForVenue: (MWZVenue*) venue withUniverseId:(NSString*) universeId;
- (void) setUniverseForVenue: (MWZVenue*) venue withUniverse:(MWZUniverse*) universeId;
- (NSString*) getUniverseForVenue: (NSString*) venueId;

- (MWZUserPosition*) getUserPosition;
- (void) removeUserPosition;
- (void) setUserPosition:(MWZUserPosition*) userPosition;
- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor
__attribute__((deprecated("Use setUserPosition:(MWZUserPosition*) instead")));
- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy
__attribute__((deprecated("Use setUserPosition:(MWZUserPosition*) instead")));
- (void) newUserPositionMeasurement: (MWZMeasurement*) measurement;
- (void) setUserHeading: (NSNumber*) heading;
- (void) unlockUserPosition;

- (void) startLocationWithBeacons:(BOOL) useBeacons;
- (void) stopLocation;

- (void) loadURL: (NSString*) url completionHandler:(void(^)(NSError*)) handler ;

- (void) addPromotedPlace:(MWZPlace*) place;
- (void) addPromotedPlaceWithId:(NSString*) placeId;
- (void) addPromotedPlaces:(NSArray<MWZPlace*>*) places;
- (void) addPromotedPlacesWithIds:(NSArray<NSString*>*) placeIds;
- (void) setPromotedPlaces:(NSArray<MWZPlace*>*) places;
- (void) setPromotedPlacesWithIds:(NSArray<NSString*>*) placeIds;
- (void) removePromotedPlace:(MWZPlace*) place;
- (void) removePromotedPlaceWithId:(NSString*) placeId;

- (void) addIgnoredPlace:(MWZPlace*) place;
- (void) addIgnoredPlaceWithId:(NSString*) placeId;
- (void) setIgnoredPlaces:(NSArray<MWZPlace*>*) places;
- (void) setIgnoredPlacesWithIds:(NSArray<NSString*>*) placeIds;
- (void) removeIgnoredPlace:(MWZPlace*) place;
- (void) removeIgnoredPlaceWithId:(NSString*) placeId;

- (void) addMarkerWithCoordinate: (MWZCoordinate*) coordinate;
- (void) addMarkerWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor
__attribute__((deprecated("Use addMarkerWithCoordinate:(MWZCoordinate*) instead")));
- (void) addMarkerWithPlaceId: (NSString*) placeId;
- (void) removeMarkers;

- (void) startDirections: (MWZDirection*) direction;
- (void) stopDirections;

- (void) setPreferredLanguage: (NSString*) language;

- (void) setStyle: (MWZStyle*) style forPlaceById: (NSString*) placeId;

- (void) setBottomMargin: (NSNumber*) margin;
- (void) setTopMargin: (NSNumber*) margin;

- (void) refresh;

@end
