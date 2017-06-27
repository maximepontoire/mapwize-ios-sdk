#import "MWZLeftMenuController.h"
#import "SWRevealViewController.h"
#import "MWZViewController.h"

@interface MWZLeftMenuController ()
    @end

@implementation MWZLeftMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    _menuItems = @[@"setPreferredLanguageFR", @"setPreferredLanguageEN", @"setZoom", @"centerOnCoordinates", @"centerOnCoordinatesWithFloor", @"setFloor", @"centerOnVenue", @"centerOnPlace", @"centerOnUser", @"loadUrl", @"addMarker", @"addMarkerOnPlace", @"removeMarkers", @"setFollowUserModeOn", @"setFollowUserModeOff", @"setUserPosition", @"setUserPositionWithFloor", @"unlockUserPosition", @"startUserLocation", @"stopUserLocation", @"removeUserPosition", @"showDirections", @"showDirectionsWithWaypoints", @"showDirectionsToAList", @"stopDirections",@"getZoom", @"getFloor", @"getUserPosition", @"getCenter", @"setStyle", @"fitBounds", @"setBottomMargin", @"setTopMargin", @"resetMargin", @"setUserHeading", @"removeHeading", @"getPlaceWithName", @"getPlaceWithAlias", @"getPlaceWithId", @"getVenueWithName", @"getVenueWithAlias", @"getVenueWithId", @"getPlaceListWithId", @"getPlaceListWithName", @"getPlaceListWithAlias", @"getPlaceListsForVenue", @"getPlacesWithPlaceListId", @"refresh", @"getPlaces",@"setPromotePlaces"];
    
    UINavigationController *navController =(UINavigationController*)self.revealViewController.frontViewController;
    MWZViewController *mainViewController = [navController childViewControllers].firstObject;
    _mapController = mainViewController.myMapView;
    _apiManager = [MWZApiManager sharedManager];
    _okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* s = [_menuItems objectAtIndex:indexPath.item];
    SEL selector = NSSelectorFromString(s);
    [self performSelector:selector];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
}


/*
 Tests methods
*/
- (void) setPreferredLanguageFR {
    [_mapController setPreferredLanguage:@"fr"];
}
- (void) setPreferredLanguageEN {
    [_mapController setPreferredLanguage:@"en"];
}
- (void) setZoom {
    [_mapController setZoom:@12];
}
- (void) centerOnCoordinates {
    MWZCoordinate* coordinate = [[MWZCoordinate alloc] initWithLatitude:49.74252973220731 longitude:4.599119424819946 floor:nil];
    [_mapController centerOnCoordinates:coordinate withZoom:@18];
}
- (void) centerOnCoordinatesWithFloor {
    MWZCoordinate* coordinate = [[MWZCoordinate alloc] initWithLatitude:49.74252973220731 longitude:4.599119424819946 floor:@2];
    [_mapController centerOnCoordinates:coordinate withZoom:@18];
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
    [_mapController loadURL:@"http://mwz.io/aaa" completionHandler:^(NSError* error){
        if (error != nil) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Load url"
                                                  message:[NSString stringWithFormat:@"Error:%@", error]
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:_okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Load url"
                                                  message:[NSString stringWithFormat:@"Success"]
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:_okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
- (void) addMarker {
    MWZCoordinate* coordinate = [[MWZCoordinate alloc] initWithLatitude:49.74278626088478 longitude:4.598293304443359 floor:nil];
    [_mapController addMarkerWithCoordinate:coordinate];
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
    MWZUserPosition* userPosition = [[MWZUserPosition alloc] initWithLatitude:49.74278626088478 longitude:4.598293304443359 floor:nil accuracy:@3];
    [_mapController setUserPosition:userPosition];
}
- (void) setUserPositionWithFloor {
    MWZUserPosition* userPosition = [[MWZUserPosition alloc] initWithLatitude:49.74278626088478 longitude:4.598293304443359 floor:@2 accuracy:@3];
    [_mapController setUserPosition:userPosition];
}
- (void) removeUserPosition {
    [_mapController removeUserPosition];
}
- (void) unlockUserPosition {
    [_mapController unlockUserPosition];
}
- (void) startUserLocation {
    [_mapController startLocationWithBeacons:YES];
}

- (void) stopUserLocation {
    [_mapController stopLocation];
}

- (void) showDirections {
    MWZPlace* from = [[MWZPlace alloc] init];
    from.identifier = @"56c3426202275a0b00fb00b9";
    MWZPlace* to = [[MWZPlace alloc] init];
    to.identifier = @"56c3504102275a0b00fb00fa";
    
    MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
    options.isAccessible = TRUE;

    [_apiManager getDirectionsFrom:from to:to by:nil withOptions:options success:^(MWZDirection *direction) {
        [_mapController startDirections: direction];
    } failure:^(NSError *error) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Directions"
                                              message:[NSString stringWithFormat:@"Error:%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
}

- (void) showDirectionsWithWaypoints {
    MWZPlace* from = [[MWZPlace alloc] init];
    from.identifier = @"56c3426202275a0b00fb00b9";
    MWZPlace* to = [[MWZPlace alloc] init];
    to.identifier = @"56c3504102275a0b00fb00fa";
    
    NSMutableArray<id<MWZDirectionPoint>>* array = [[NSMutableArray alloc] init];
    MWZPlace* wp1 = [[MWZPlace alloc] init];
    wp1.identifier = @"56c34fc402275a0b00fb00f6";
    MWZPlace* wp2 = [[MWZPlace alloc] init];
    wp2.identifier = @"56c344a402275a0b00fb00bf";
    [array addObject:wp1];
    [array addObject:wp2];
    MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
    options.isAccessible = TRUE;
    
    [_apiManager getDirectionsFrom:from to:to by:array withOptions:options success:^(MWZDirection *direction) {
        [_mapController startDirections: direction];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Directions with waypoints"
                                              message:[NSString stringWithFormat:@"Error:%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) showDirectionsToAList {
    MWZPlace* from = [[MWZPlace alloc] init];
    from.identifier = @"56c3429c02275a0b00fb00bb";
    MWZPlaceList* to = [[MWZPlaceList alloc] init];
    to.identifier = @"5728a351a3a26c0b0027d5cf";
    MWZDirectionOptions* options = [[MWZDirectionOptions alloc] init];
    options.isAccessible = TRUE;
    
    [_apiManager getDirectionsFrom:from to:to by:nil withOptions:options success:^(MWZDirection *direction) {
        [_mapController startDirections: direction];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Directions to a list"
                                              message:[NSString stringWithFormat:@"Error:%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];

}

- (void) stopDirections {
    [_mapController stopDirections];
}
- (void) setStyle {
    MWZStyle* style = [[MWZStyle alloc] init];
    style.strokeColor = @"#FF0000";
    style.strokeWidth = @1;
    style.fillColor = @"#0000FF";
    [_mapController setStyle:style forPlaceById:@"56c3426202275a0b00fb00b9"];
}
- (void) getZoom {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Zoom level"
                                          message:[NSString stringWithFormat:@"%@", [_mapController getZoom]]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:_okAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void) getFloor {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Floor"
                                          message:[NSString stringWithFormat:@"%@", [_mapController getFloor]]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:_okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void) getUserPosition {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"User position"
                                          message:[NSString stringWithFormat:@"%@", [_mapController getUserPosition]]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:_okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) getCenter {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Center"
                                          message:[NSString stringWithFormat:@"%@", [_mapController getCenter]]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:_okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) fitBounds {
    MWZBounds* bounds = [[MWZBounds alloc] initWithSouthWest:[[MWZCoordinate alloc] initWithLatitude:49.742851692813445652 longitude:4.5997658371925345122 floor:nil] northEast:[[MWZCoordinate alloc] initWithLatitude:49.742313935073504183 longitude:4.5989323407411575317 floor:nil]];
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

- (void) getPlaces {
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @2, @"floor", nil];
    MWZVenue* venueExample = [[MWZVenue alloc] init];
    venueExample.identifier = @"56c2ea3402275a0b00fb00ac";
    [_apiManager getPlacesForVenue:venueExample withOptions:options success:^(NSArray<MWZPlace *> *places) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get places for placeList (success)"
                                              message:[NSString stringWithFormat:@"%lu", (unsigned long)places.count]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get places for placeList (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getPlaceWithName {
    MWZVenue* venueExample = [[MWZVenue alloc] init];
    venueExample.identifier = @"56c2ea3402275a0b00fb00ac";

    [_apiManager getPlaceWithName:@"Bakery" inVenue:venueExample success:^(MWZPlace *place) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get place by name (success)"
                                              message:[NSString stringWithFormat:@"%@", place]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get place by name (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getPlaceWithAlias {
    MWZVenue* venueExample = [[MWZVenue alloc] init];
    venueExample.identifier = @"56c2ea3402275a0b00fb00ac";

    [_apiManager getPlaceWithAlias:@"bakery" inVenue: venueExample success:^(MWZPlace *place) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get place by alias (success)"
                                              message:[NSString stringWithFormat:@"%@", place]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get place by alias (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getPlaceWithId {
    
    [_apiManager getPlaceWithId:@"56f1c77625565f0b00eda15d" success:^(MWZPlace *place) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get place by id (success)"
                                              message:[NSString stringWithFormat:@"%@", place]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get place by id (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getVenueWithId {
    
    [_apiManager getVenueWithId:@"56c2ea3402275a0b00fb00ac" success:^(MWZVenue *venue) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get venue by id (success)"
                                              message:[NSString stringWithFormat:@"%@", venue]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Get venue by id (error)"
                                                  message:[NSString stringWithFormat:@"%@", error]
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:_okAction];
            [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getVenueWithName {
    [_apiManager getVenueWithName:@"Demo" success:^(MWZVenue *venue) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get venue with name (success)"
                                              message:[NSString stringWithFormat:@"%@", venue]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get venue with name (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];

}

- (void) getVenueWithAlias {
    [_apiManager getVenueWithAlias:@"demo" success:^(MWZVenue *venue) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get venue with alias (success)"
                                              message:[NSString stringWithFormat:@"%@", venue]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get venue with alias (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];

}

- (void) getPlaceListWithId {
    
    [_apiManager getPlaceListWithId:@"5728a351a3a26c0b0027d5cf" success:^(MWZPlaceList *placeList) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get placeList with id (success)"
                                              message:[NSString stringWithFormat:@"%@", placeList]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get placeList with id (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getPlaceListWithName {
    MWZVenue* venueExample = [[MWZVenue alloc] init];
    venueExample.identifier = @"56c2ea3402275a0b00fb00ac";
    
    [_apiManager getPlaceListWithName:@"Toilets" inVenue:venueExample success:^(MWZPlaceList *placeList) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get placeList with alias (success)"
                                              message:[NSString stringWithFormat:@"%@", placeList]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get placeList with alias (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getPlaceListWithAlias {
    MWZVenue* venueExample = [[MWZVenue alloc] init];
    venueExample.identifier = @"56c2ea3402275a0b00fb00ac";
    
    [_apiManager getPlaceListWithAlias:@"toilets" inVenue:venueExample success:^(MWZPlaceList *placeList) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get placeList with name (success)"
                                              message:[NSString stringWithFormat:@"%@", placeList]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get placeList with name (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getPlaceListsForVenue {
    MWZVenue* venueExample = [[MWZVenue alloc] init];
    venueExample.identifier = @"56c2ea3402275a0b00fb00ac";
    
    [_apiManager getPlaceListsForVenue:venueExample success:^(NSArray<MWZPlaceList *> *placeLists) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get placeLists for venue (success)"
                                              message:[NSString stringWithFormat:@"%lu", (unsigned long)placeLists.count]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get placeList for venue (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void) getPlacesWithPlaceListId {
    MWZPlaceList* exemplePlaceList = [[MWZPlaceList alloc] init];
    exemplePlaceList.identifier = @"5728a351a3a26c0b0027d5cf";
    [_apiManager getPlacesForPlaceList:exemplePlaceList success:^(NSArray<MWZPlace *> *places) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get places for placelist (success)"
                                              message:[NSString stringWithFormat:@"%lu", (unsigned long)places.count]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Get places for placelist (error)"
                                              message:[NSString stringWithFormat:@"%@", error]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:_okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }];
}



- (void) refresh {
    [_mapController refresh];
}

- (void) setPromotePlaces {
    [_mapController setPromotedPlacesWithIds:@[@"56c346fc02275a0b00fb00c9",@"582324008557460c00235dbf"]];
}

#pragma mark location manager delagate
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
