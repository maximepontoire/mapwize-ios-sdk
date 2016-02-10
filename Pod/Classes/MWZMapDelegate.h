#ifndef MWZMapDelegate_h
#define MWZMapDelegate_h

@class MWZMapView;
@class MWZLatLon;

@protocol MWZMapDelegate

@optional

- (void) map:(MWZMapView*) map didClick:(MWZLatLon*) latlon;
- (void) map:(MWZMapView*) map didClickOnPlace:(NSDictionary*) place;
- (void) map:(MWZMapView*) map didChangeFloor:(NSNumber*) floor;
- (void) map:(MWZMapView*) map didChangeFloors:(NSArray*) floors;

- (void) map:(MWZMapView*) map didFailWithError: (NSError *)error;

@end

#endif /* MWZMapDelegate_h */
