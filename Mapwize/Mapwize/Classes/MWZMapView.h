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

- (void) centerOnCoordinates: (NSNumber*) lat longitude: (NSNumber*) lon floor: (NSNumber*) floor zoom: (NSNumber*) zoom;
- (void) centerOnVenue: (MWZVenue*) venue;
- (void) centerOnVenueById: (NSString*) venueId;
- (void) centerOnPlace: (MWZPlace*) place;
- (void) centerOnPlaceById: (NSString*) placeId;
- (void) centerOnUser: (NSNumber*) zoom;

- (BOOL) getFollowUserMode;
- (void) setFollowUserMode: (BOOL) follow;

- (void) setUniverseForVenue: (MWZVenue*) venue withUniverseId:(NSString*) universeId;
- (NSString*) getUniverseForVenue: (NSString*) venueId;

- (MWZUserPosition*) getUserPosition;
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

- (void) startDirections: (MWZDirection*) direction;
- (void) stopDirections;

- (void) setPreferredLanguage: (NSString*) language;

- (void) setStyle: (MWZStyle*) style forPlaceById: (NSString*) placeId;

- (void) setBottomMargin: (NSNumber*) margin;
- (void) setTopMargin: (NSNumber*) margin;

- (void) refresh;

@end
