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

- (void) centerOnVenue: (MWZVenue*) venue;
- (void) centerOnVenueById: (NSString*) venueId;
- (void) centerOnPlace: (MWZPlace*) place;
- (void) centerOnPlaceById: (NSString*) placeId;

- (BOOL) getFollowUserMode;
- (void) setFollowUserMode: (BOOL) follow;

- (void) centerOnUser: (NSNumber*) zoom;
- (MWZMeasurement*) getUserPosition;
- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor;
- (void) newUserPositionMeasurement: (MWZMeasurement*) measurement;
- (void) unlockUserPosition;

- (void) loadURL: (NSString*) url;

- (void) addMarkerWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor;
- (void) addMarkerWithPlaceId: (NSString*) placeId;
- (void) removeMarkers;

- (void) showDirectionsFrom: (MWZPosition*) from to: (MWZPosition*) to;

- (void) access: (NSString*) accessKey;

- (void) executeJS:(NSString*) js;

@end
