#import "MWZViewController.h"
#import "SWRevealViewController.h"
#import <Mapwize/Mapwize.h>

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

    MWZApiManager* manager = [MWZApiManager sharedManager];
    [manager getAccessWithAccessKey:@"demo" success:^{
        [manager getVenueWithId:@"56c2ea3402275a0b00fb00ac" success:^(MWZVenue *venue) {
            NSDictionary* data = venue.data;
            NSNumber* minZoom = data[@"minZoom"];
            NSDictionary* maxBoundsDic = data[@"maxBounds"];
            NSDictionary* swDic = maxBoundsDic[@"southWest"];
            NSDictionary* neDic = maxBoundsDic[@"northEast"];
            MWZCoordinate* sw = [[MWZCoordinate alloc] initWithLatitude:[swDic[@"latitude"] doubleValue] longitude:[swDic[@"longitude"] doubleValue] floor:nil];
            MWZCoordinate* ne = [[MWZCoordinate alloc] initWithLatitude:[neDic[@"latitude"] doubleValue] longitude:[neDic[@"longitude"] doubleValue] floor:nil];
            MWZBounds* maxBounds = [[MWZBounds alloc] initWithSouthWest:sw northEast:ne];
            MWZMapOptions* options = [[MWZMapOptions alloc] init];
            options.apiKey = @"1f04d780dc30b774c0c10f53e3c7d4ea"; // PASTE YOU API KEY HERE !!! This is a demo key. It is not allowed to use it for production. The key might change at any time without notice.
            options.locationEnabled = true;
            options.maxBounds = maxBounds;
            options.accessKey = @"demo";
            options.beaconsEnabled = true;
            options.minZoom = minZoom;
            //Sets the delegate to receive events
            _myMapView.delegate = self;
            
            //Loads the map
            [_myMapView loadMapWithOptions: options];
            
        } failure:^(NSError *error) {
            NSLog(@"GetVenue error: %@", error);
        }];

    } failure:^(NSError *error) {
        NSLog(@"Access error: %@", error);
    }];
    
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

- (void) map:(MWZMapView*) map didClick:(MWZCoordinate*) latlon {
    NSLog(@"didClick %@", latlon);
}

- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place {
    NSLog(@"didClickOnPlace %@", place);
}

- (void) map:(MWZMapView*) map didClickOnVenue:(MWZVenue*) venue {
    NSLog(@"didClickOnVenue %@", venue);
}

- (void) map:(MWZMapView*) map didClickOnMarker:(MWZCoordinate *)marker {
    NSLog(@"didClickOnMarker %@", marker);
}

- (void) map:(MWZMapView*) map didChangeFloor:(NSNumber*) floor {
    NSLog(@"didChangeFloor %@", floor);
}

- (void) map:(MWZMapView*) map didChangeFloors:(NSArray*) floors {
    NSLog(@"didChangeFloors %@", floors);
}

- (void) map:(MWZMapView *)map didMove:(MWZCoordinate *)center {
    NSLog(@"didMove %@", center);
}

- (void) map:(MWZMapView*) map didFailWithError: (NSError *)error {
    NSLog(@"didFailWithError %@", error);
}

- (void) map:(MWZMapView*) map didChangeFollowUserMode:(BOOL)followUserMode {
    NSLog(@"didChangeFollowUserMode %@", (followUserMode?@"YES":@"NO"));
}

- (void) map:(MWZMapView*) map didChangeUserPosition:(MWZUserPosition *)userPosition {
    NSLog(@"didChangeUserPosition %@", userPosition);
}

- (void )map:(MWZMapView*) map didChangeZoom: (NSNumber*) zoom {
    NSLog(@"didChangeZoom %@", zoom);
}

- (void )map:(MWZMapView*) map didClickLong: (MWZCoordinate*) latlon {
    NSLog(@"didClickLong %@", latlon);
}

- (void) map:(MWZMapView*) map didStartDirections: (NSString*) infos {
    NSLog(@"didStartDirections %@", infos);
}

- (void )map:(MWZMapView*) map didStopDirections: (NSString*) infos {
    NSLog(@"didStopDirections %@", infos);
}

@end
