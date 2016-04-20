#import "MWZLeftMenuController.h"
#import "SWRevealViewController.h"
#import "MWZViewController.h"



@interface MWZLeftMenuController ()
    @end

@implementation MWZLeftMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    _menuItems = @[@"accessKey", @"setZoom", @"centerOnCoordinates", @"centerOnCoordinatesWithFloor", @"setFloor", @"centerOnVenue", @"centerOnPlace", @"centerOnUser", @"loadUrl", @"addMarker", @"addMarkerOnPlace", @"removeMarkers", @"setFollowUserModeOn", @"setFollowUserModeOff", @"setUserPosition", @"setUserPositionWithFloor", @"unlockUserPosition", @"showDirections", @"stopDirections",
                   @"getZoom", @"getFloor", @"getUserPosition", @"getCenter", @"setStyle", @"fitBounds", @"setBottomMargin", @"setTopMargin", @"resetMargin", @"setUserHeading", @"removeHeading", @"getPlaceWithName", @"getPlaceWithAlias", @"getPlaceWithId", @"getVenueWithName", @"getVenueWithAlias", @"getVenueWithId", @"refresh"];
    
    UINavigationController *navController =(UINavigationController*)self.revealViewController.frontViewController;
    MWZViewController *mainViewController = [navController childViewControllers].firstObject;
    _mapController = mainViewController.myMapView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* s = [_menuItems objectAtIndex:indexPath.item];
    SEL monSelecteur = NSSelectorFromString(s);
    [self performSelector:monSelecteur];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
}


/*
 Tests methods
*/
- (void) accessKey {
    [_mapController access: @"YOUR ACCESS KEY HERE"];
}
- (void) setZoom {
    [_mapController setZoom:@12];
}
- (void) centerOnCoordinates {
    [_mapController centerOnCoordinates:@49.74252973220731 longitude:@4.599119424819946 floor:nil zoom:@18];
}
- (void) centerOnCoordinatesWithFloor {
    [_mapController centerOnCoordinates:@49.74252973220731 longitude:@4.599119424819946 floor:@2 zoom:@18];
}
- (void) setFloor {
    [_mapController setFloor:@2];
}
- (void) centerOnVenue {
    [_mapController centerOnVenueById:@"56c2ea3402275a0b00fb00ac"];
}
- (void) centerOnPlace {
    [_mapController centerOnPlaceById:@"56c3426202275a0b00fb00b9"];
}
- (void) centerOnUser {
    [_mapController centerOnUser:@19];
}
- (void) loadUrl {
    [_mapController loadURL:@"http://mwz.io/aaa"];
}
- (void) addMarker {
    [_mapController addMarkerWithLatitude:@49.74278626088478 longitude:@4.598293304443359 floor:nil];
}
- (void) addMarkerOnPlace {
    [_mapController addMarkerWithPlaceId:@"56c3426202275a0b00fb00b9"];
}
- (void) removeMarkers {
    [_mapController removeMarkers];
}
- (void) setFollowUserModeOn {
    [_mapController setFollowUserMode:TRUE];
}
- (void) setFollowUserModeOff {
    [_mapController setFollowUserMode:FALSE];
}
- (void) setUserPosition {
    [_mapController setUserPositionWithLatitude:@49.74278626088478 longitude:@4.598293304443359 floor:nil];
}
- (void) setUserPositionWithFloor {
    [_mapController setUserPositionWithLatitude:@49.74278626088478 longitude:@4.598293304443359 floor:@2];
}
- (void) unlockUserPosition {
    [_mapController unlockUserPosition];
}
- (void) showDirections {
    MWZPosition* from = [[MWZPosition alloc] initWithPlaceId:@"56c3426202275a0b00fb00b9"];
    MWZPosition* to = [[MWZPosition alloc] initWithPlaceId:@"56c3504102275a0b00fb00fa"];
    [_mapController showDirectionsFrom:from to:to];
}
- (void) stopDirections {
    [_mapController stopDirections];
}
- (void) setStyle {
    MWZPlaceStyle* style = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor redColor] strokeWidth:@1 fillColor:[UIColor blueColor] labelBackgroundColor:[UIColor greenColor] markerUrl:@"https://cdn4.iconfinder.com/data/icons/medical-soft-1/512/map_marker_pin_pointer_navigation_location_point_position-128.png"];
    [_mapController setStyle:style forPlaceById:@"56c3426202275a0b00fb00b9"];
}
- (void) getZoom {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zoom level"
                                                    message:[NSString stringWithFormat:@"%@", [_mapController getZoom]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void) getFloor {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Floor"
                                                    message:[NSString stringWithFormat:@"%@", [_mapController getFloor]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void) getUserPosition {
    MWZMeasurement* up = [_mapController getUserPosition];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Position"
                                                    message:[NSString stringWithFormat:@"%@", up]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) getCenter {
    MWZLatLon* latlng = [_mapController getCenter];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Center"
                                                    message:[NSString stringWithFormat:@"%@", latlng]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) fitBounds {
    MWZLatLonBounds* bounds = [[MWZLatLonBounds alloc] initWithNorthEast:[[MWZLatLon alloc] initWithLatitude:@49.74252973220731 longitude:@4.599119424819946] southWest:[[MWZLatLon alloc] initWithLatitude:@49.74252973220731 longitude:@4.599119424819946]];
    [_mapController fitBounds:bounds];
}

- (void) setBottomMargin {
    [_mapController setBottomMargin:@60];
}

- (void) setTopMargin {
    [_mapController setTopMargin:@60];
}

- (void) resetMargin {
    [_mapController setBottomMargin:@0];
    [_mapController setTopMargin:@0];
}

- (void) setUserHeading {
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.headingFilter = 5;
    [_manager requestWhenInUseAuthorization];
    [_manager startUpdatingHeading];
}

- (void) removeHeading {
    [_manager stopUpdatingHeading];
    [_mapController setUserHeading:nil];
}

- (void) getPlaceWithName {
    [_mapController getPlaceWithName:@"Bakery" inVenue: @"56c2ea3402275a0b00fb00ac" completionHandler:^(MWZPlace* place){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get place by name"
                                                        message:[NSString stringWithFormat:@"%@", place]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }];
}

- (void) getPlaceWithAlias {
    [_mapController getPlaceWithAlias:@"bakery" inVenue: @"56c2ea3402275a0b00fb00ac" completionHandler:^(MWZPlace* place){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get place by alias"
                                                        message:[NSString stringWithFormat:@"%@", place]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (void) getPlaceWithId {
    [_mapController getPlaceWithId:@"56c3426202275a0b00fb00b9" completionHandler:^(MWZPlace* place){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get place by id"
                                                        message:[NSString stringWithFormat:@"%@", place]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (void) getVenueWithId {
    [_mapController getVenueWithId:@"56c2ea3402275a0b00fb00ac" completionHandler:^(MWZVenue* venue){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get venue by id"
                                                        message:[NSString stringWithFormat:@"%@", venue]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (void) getVenueWithName {
    [_mapController getVenueWithName:@"Demo" completionHandler:^(MWZVenue* venue){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get venue by name"
                                                        message:[NSString stringWithFormat:@"%@", venue]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (void) getVenueWithAlias {
    [_mapController getVenueWithAlias:@"demo" completionHandler:^(MWZVenue* venue){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get venue by alias"
                                                        message:[NSString stringWithFormat:@"%@", venue]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }];
}



- (void) refresh {
    [_mapController refresh];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager*)manager
{
    return YES;
}

- (void)locationManager:(CLLocationManager*)manager
       didUpdateHeading:(CLHeading*)heading
{
    [_mapController setUserHeading:@(heading.magneticHeading)];
}

@end
