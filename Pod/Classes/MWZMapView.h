#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"
#import "MWZLatLonBounds.h"

@interface MWZMapView : UIView  <WKNavigationDelegate, WKScriptMessageHandler>

@property id<MWZMapDelegate> delegate;

- (void) loadMapWithOptions: (MWZMapOptions*) options;

- (void) fitBounds:(MWZLatLonBounds*) bounds;
- (NSNumber*) getFloor;
- (NSArray*) getFloors;
- (void) setFloor: (NSNumber*) floor;
- (void) access: (NSString*) accessKey;

- (void) executeJS:(NSString*) js;

@end
