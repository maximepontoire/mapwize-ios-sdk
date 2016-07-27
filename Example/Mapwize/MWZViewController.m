#import "MWZViewController.h"
#import "SWRevealViewController.h"
@import Mapwize;

@interface MWZViewController ()
@property (nonatomic, strong) CLLocationManager * locationManager;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * activityView;
@end

@implementation MWZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (status == kCLAuthorizationStatusAuthorizedAlways || status ==kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Location Authorization granted");
    } else {
        NSLog(@"Requesting Location Authorization");
        [_locationManager requestWhenInUseAuthorization];
    }

    
    //Defines the map options
    MWZMapOptions* options = [[MWZMapOptions alloc] init];
    options.apiKey = @"1f04d780dc30b774c0c10f53e3c7d4ea"; // PASTE YOU API KEY HERE !!! This is a demo key. It is not allowed to use it for production. The key might change at any time without notice.
    options.locationEnabled = true;
    options.accessKey = @"demo";
    options.beaconsEnabled = true;
    //Sets the delegate to receive events
    _myMapView.delegate = self;
    
    //Loads the map
    [_myMapView loadMapWithOptions: options];
    
    //Fits bounds on demo building
    [_myMapView fitBounds:[[MWZLatLonBounds alloc] initWithNorthEast:[[MWZLatLon alloc] initWithLatitude:@49.742313935073504183 longitude:@4.5989323407411575317] southWest:[[MWZLatLon alloc] initWithLatitude:@49.742851692813445652 longitude:@4.5997658371925345122]]];

    //Update view and show menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.navigationButton setTarget: self.revealViewController];
        [self.navigationButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}

#pragma mark - <MWZMapDelegate>

//Listering to delegate events
- (void) mapDidLoad: (MWZMapView*) map {
    NSLog(@"mapDidLoad");
    [self.activityView stopAnimating];
}

- (void) map:(MWZMapView*) map didClick:(MWZLatLon*) latlon {
    NSLog(@"didClick %@", latlon);
}

- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place {
    NSLog(@"didClickOnPlace %@", place);
}

- (void) map:(MWZMapView*) map didClickOnVenue:(MWZVenue*) venue {
    NSLog(@"didClickOnVenue %@", venue);
}

- (void) map:(MWZMapView*) map didClickOnMarker:(MWZPosition *)marker {
    NSLog(@"didClickOnMarker %@", marker);
}

- (void) map:(MWZMapView*) map didChangeFloor:(NSNumber*) floor {
    NSLog(@"didChangeFloor %@", floor);
}

- (void) map:(MWZMapView*) map didChangeFloors:(NSArray*) floors {
    NSLog(@"didChangeFloors %@", floors);
}

- (void) map:(MWZMapView *)map didMove:(MWZLatLon *)center {
    NSLog(@"didMove %@", center);
}

- (void) map:(MWZMapView*) map didFailWithError: (NSError *)error {
    NSLog(@"didFailWithError %@", error);
}

- (void) map:(MWZMapView*) map didChangeFollowUserMode:(BOOL)followUserMode {
    NSLog(@"didChangeFollowUserMode %@", (followUserMode?@"YES":@"NO"));
}

- (void) map:(MWZMapView*) map didChangeUserPosition:(MWZMeasurement *)userPosition {
    NSLog(@"didChangeUserPosition %@", userPosition);
}

- (void )map:(MWZMapView*) map didChangeZoom: (NSNumber*) zoom {
    NSLog(@"didChangeZoom %@", zoom);
}

- (void )map:(MWZMapView*) map didClickLong: (MWZLatLon*) latlon {
    NSLog(@"didClickLong %@", latlon);
}

- (void) map:(MWZMapView*) map didStartDirections: (NSString*) infos {
    NSLog(@"didStartDirections %@", infos);
}

- (void )map:(MWZMapView*) map didStopDirections: (NSString*) infos {
    NSLog(@"didStopDirections %@", infos);
}

#pragma mark - Memory managment

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
