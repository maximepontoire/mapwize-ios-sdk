#ifndef MWZMapDelegate_h
#define MWZMapDelegate_h

@class MWZMapView;
@class MWZCoordinate;
@class MWZUserPosition;
@class MWZPlace;
@class MWZVenue;
@class WKWebView;

@protocol MWZMapDelegate <NSObject>

@optional

- (void) mapDidLoad: (MWZMapView*) map;
- (void) map:(MWZMapView*) map didClick:(MWZCoordinate*) latlon;
- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place;
- (void) map:(MWZMapView*) map didClickOnVenue:(MWZVenue*) venue;
- (void) map:(MWZMapView*) map didClickLong: (MWZCoordinate*) latlon;
- (void) map:(MWZMapView*) map didClickOnMarker: (MWZCoordinate*) marker;
- (void) map:(MWZMapView*) map didChangeFloor:(NSNumber*) floor;
- (void) map:(MWZMapView*) map didChangeFloors:(NSArray*) floors;
- (void) map:(MWZMapView*) map didChangeZoom:(NSNumber*) floor;
- (void) map:(MWZMapView*) map didMove:(MWZCoordinate*) center;
- (void) map:(MWZMapView*) map didChangeUserPosition:(MWZUserPosition*) userPosition;
- (void) map:(MWZMapView*) map didChangeFollowUserMode:(BOOL) followUserMode;
- (void) map:(MWZMapView*) map didStartDirections: (NSString*) infos;
- (void) map:(MWZMapView*) map didStopDirections: (NSString*) infos;
- (void) map:(MWZMapView*) map didFailWithError: (NSError *)error;

@end

#endif
