# Mapwize

[![Version](https://img.shields.io/cocoapods/v/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)
[![License](https://img.shields.io/cocoapods/l/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)
[![Platform](https://img.shields.io/cocoapods/p/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)

This is the Mapwize iOS SDK, version 2.1.x.

It allows you to display and interact with Mapwize venue maps.

## Requirements

iOS 8 or higher

## Emulator

The Emulator seems to have an issue with the Cookie Management and behaves differently than real devices. Please use real devices if you need to use the API to access content from private venues.

## Installation

Mapwize is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

pod 'Mapwize'

## Example application

An example application is provided in this repository, in MapwizeDemo. Open MapwizeDemo/MapwizeDemo.xcworkspace

The menu lists all the possible actions that you can do with the map.

The SDK is installed using CocoaPods. Run `pod install` from MapwizeDemo to reset the pods configuration if necessary.


## Map documentation

### Display the map
To display the Mapwize app, create an instance of MWZMapView then, in your view controller, call the method 

[map loadMapWithOptions: options];

This will load the map in the view with the provided options.

### Map options
Options are defined using the class MWZMapOptions. The following options are available:

- apiKey : [NSString] must be provided for the map to load. It can be obtained from the Mapwize administration interface. If you don't have any, contact us.
- bounds : [MWZBounds] region that will be display after initialization.
- maxBounds : [MWZBounds] region users are allowed to navigate in (default: entire world).
- center: [MWZCoordinate] coordiantes of the center of the map at start-up (default: 0,0).
- zoom : [NSNumber] integer between 0 and 21 (default 0).
- minZoom: [NSNumber] optional minimum zoom allowed by the map, usefull to limit the visible area.
- floor : [NSNumber] integer representing the desired floor of the building (default 0).
- locationEnabled : [BOOL] boolean defining if the GPS should be started and the user position displayed (default: true).
- beaconsEnabled : [BOOL] boolean defining if the iBeacon scanner should be turned on (default: false).
- accessKey: [NSString] optional accessKey to be used during map load to be sure that access is granted to desired buildings at first map display.
- language: [NSString] optional preferred language for the map. Used to display all venues supporting that language.
- showUserPositionControl [BOOL] display the user position button at the bottom right of the map (default: true).

### Moving the map
Once the map loaded, you can use the following functions on the map instance:

- (void) fitBounds:(MWZBounds*) bounds; - moves the map so the specified bound is completely visible.
- (void) centerOnCoordinates: (MWZCoordinate*) coordinate withZoom:(NSNumber*) zoom;
Depracated: - (void) centerOnCoordinates: (NSNumber*) latitude longitude: (NSNumber*) longitude floor: (NSNumber*) floor zoom: (NSNumber*) zoom;
- (void) setFloor: (NSNumber*) floor;
- (void) setZoom: (NSNumber*) zoom;
- (void) centerOnVenue: (MWZVenue*) venue;
- (void) centerOnVenueById: (NSString*) venueId;
- (void) centerOnPlace: (MWZPlace*) place;
- (void) centerOnPlaceById: (NSString*) placeId;
- (void) centerOnUser: (NSNumber*) zoom;

### Getting map state

- (NSNumber*) getFloor - returns the floor currently displayed.
- (NSArray*) getFloors - returns the list of floors available at the current viewing position.
- (NSNumber*) getZoom - returns the current zoom level.

### User position

The followUserMode defines if the map should move when the user is moving.

- (BOOL) getFollowUserMode;
- (void) setFollowUserMode: (BOOL) follow;

You can get/set the user position using the following methods. For a complete guide on the user position measurement principle, please refer to the [Mapwize.js documentation](https://github.com/Mapwize/mapwize.js-dist/blob/master/doc/doc.md).

- (MWZUserPosition*) getUserPosition;
- (void) setUserPosition:(MWZUserPosition*) userPosition;
Deprecated: - (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor;
Deprecated: - (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy;
- (void) newUserPositionMeasurement: (MWZMeasurement*) measurement;
- (void) unlockUserPosition;
- (void) removeUserPosition;


If you are not setting the user position manually, you need to request the Location Authorization. This can be done with the code:

CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

if (status == kCLAuthorizationStatusAuthorizedAlways || status ==kCLAuthorizationStatusAuthorizedWhenInUse) {
NSLog(@"Location Authorization granted");
} else {
NSLog(@"Requesting Location Authorization");
[locationManager requestWhenInUseAuthorization];
}

Don't forget to add kCLAuthorizationStatusAuthorizedWhenInUse or kCLAuthorizationStatusAuthorizedAlways string in the info.plist.

If you set locationEnabled=false in the map options, you can control the location using the functions

- (void) startLocationWithBeacons:(BOOL) useBeacons;
- (void) stopLocation;

### User heading

When a compass is available, it can be interesting to display the direction the user is looking. To do so, the method setUserHeading can be used, giving it an angle in degree. Example if the user is looking south:

- (void) setUserHeading: (NSNumber*) heading;

To remove the display of the compass, simply set the angle to null.

In the example app, you will find an example of code to listen to compass changes and display it on the map.

### Using Mapwize URLs

You can load Mapwize URLs using the following command. For a complete documentation please refer to the [Mapwize URL Scheme](https://github.com/Mapwize/mapwize-url-scheme).

- (void) loadURL: (NSString*) url;

### Adding markers

You can add markers on top of the map.

- (void) addMarkerWithCoordinate: (MWZCoordinate*) coordinate;
Deprecated: - (void) addMarkerWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor;
- (void) addMarkerWithPlaceId: (NSString*) placeId;
- (void) removeMarkers;

### Controlling places display

You can promote places to increase their display priority.

- (void) setPromotePlaces:(NSArray<MWZPlace*>*) places;
- (void) setPromotePlacesWithIds:(NSArray<NSString*>*) placeIds;
- (void) addPromotePlace:(MWZPlace*) place;
- (void) addPromotePlaceWithId:(NSString*) placeId;
- (void) addPromotePlaces:(NSArray<MWZPlace*>*) places;
- (void) addPromotePlacesWithIds:(NSArray<NSString*>*) placeIds;
- (void) removePromotePlace:(MWZPlace*) place;

You can ignore place to make them not visible

- (void) addIgnorePlace:(MWZPlace*) place;
- (void) addIgnorePlaceWithId:(NSString*) placeId;
- (void) removeIgnorePlace:(MWZPlace*) place;
- (void) removeIgnorePlaceWithId:(NSString*) placeId;
- (void) setIgnorePlaces:(NSArray<MWZPlace*>*) places;
- (void) setIgnorePlacesWithIds:(NSArray<NSString*>*) placeIds;


### Showing directions

To show directions, you can use 

- (void) startDirections: (MWZDirection*) direction;

The direction will be displayed and the event didStartDirections will be fired once the direction is loaded.

See the ApiManager part of this documentation to learn more about getting directions.

To remove the directions from the map, use

- (void) stopDirections;

### Listening to events

You can listen for events emitted by the map using the MWZMapDelegate protocol. To do so, set the delegate class using

map.delegate = self;

then implement the following methods

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
- (void) map:(MWZMapView*) map didChangeUserPosition:(MWZCoordinate*) userPosition;
- (void) map:(MWZMapView*) map didChangeFollowUserMode:(BOOL) followUserMode;
- (void) map:(MWZMapView*) map didStartDirections: (NSString*) infos;
- (void) map:(MWZMapView*) map didStopDirections: (NSString*) infos;
- (void) map:(MWZMapView*) map didFailWithError: (NSError *)error;

didFailWithError will be triggered in case of unavailable internet connection or in case one of the interaction with the map failed. 

### Editing place style

The display style of places can be changed dynamically within the SDK. To do so, you can use

- (void) setStyle: (MWZStyle*) style forPlaceById: (NSString*) placeId;

### Universes

You can change the universe of a venue with the following methods.

- (void) setUniverseForVenue: (MWZVenue*) venue withUniverseId:(NSString*) universeId;
- (void) setUniverseForVenue: (MWZVenue*) venue withUniverse:(MWZUniverse*) universeId;

### Setting top and bottom margins

It often happens that part of the map is hidden by banners or controls on the top or on the bottom. For example, if you display a banner to show the details of the place you just clicked on, it's better to display the banner on top of the map than having to resize the map.

However, you want to make sure that the Mapwize controls are always visible, like the followUserMode button and the floor selector. Also, that if you make a fitBounds, the area will be completely in the visible part of the map.

For this purpose, you can set a top and a bottom margin on the map. We garantee that nothing important will be displayed in those margin areas.

To set the margins in pixel:

- (void) setBottomMargin: (NSNumber*) margin;
- (void) setTopMargin: (NSNumber*) margin;

### Refreshing the cache

To prevent too many network requests while browsing the map, the SDK keeps a cache of some data it already downloaded.

The Time To Live of the cache is 5 minutes.

If you want to force the map to refresh the cache and update itself, you can call the refresh method anytime.

- (void) refresh;


## ApiManager documentation 

Mapwize objects and data can be retrieved without instantiating the map thanks to the ApiManager singleton.

Before the ApiManager can be used, the api key need to be provided:

[[MWZApiManager sharedManager] setApiKey:@"Your_api_key"];

Please note that the api key need to be provided to both the ApiManager and any MapView independently.


### Accessing private venues

To access a private venue, enter the related accessKey using:

- (NSURLSessionDataTask *)getAccessWithAccessKey:(NSString *)accessKey success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

Access keys are managed in the Mapwize administration interface and are provided by venue managers.

Getting an access using api give the access in the map at the same time. If the map is already loaded when the call is done, you have to refresh the map.

### Getting venues

Venues have properties name and alias that allow to identify them in a more human-readable manner than the ID.
Venue names and alias are unique throughout the Mapwize platform.

To get a venue object from an id, a name or an alias, you can use the following methods. The first methods allows to pass a dictionnary with filter arguments that will be sent directly with the API request.

- (NSURLSessionDataTask *)getVenues:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZVenue*> *venues))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenuesForOrganizationId:(NSString *)organizationId success:(void (^)(NSArray<MWZVenue*> *venues))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenueWithId:(NSString *)requestId success:(void (^)(MWZVenue *venue))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenueWithName:(NSString *)name success:(void (^)(MWZVenue *venue))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getVenueWithAlias:(NSString *)alias success:(void (^)(MWZVenue *venue))success failure:(void (^)(NSError *error))failure;

### Getting places

Place have id, name and alias like venues.
ID is unique throughout the mapwize platform but name and alias are unique throughout each venues

To get a place object from an id, a name or an alias, you can use the following methods. The first methods allows to pass a dictionnary with filter arguments that will be sent directly with the API request.

- (NSURLSessionDataTask *)getPlaces:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZPlace*> *places))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceWithId:(NSString *)requestId success:(void (^)(MWZPlace *place))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceWithName:(NSString *)name inVenue:(MWZVenue*) venue success:(void (^)(MWZPlace *place))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceWithAlias:(NSString *)alias inVenue:(MWZVenue*) venue success:(void (^)(MWZPlace *place))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlacesForVenue:(MWZVenue *)venue withOptions:(NSDictionary*) options success:(void (^)(NSArray<MWZPlace*>* places))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlacesForPlaceList:(MWZPlaceList *)placeList success:(void (^)(NSArray<MWZPlace*>* places))success failure:(void (^)(NSError *error))failure;


### Getting placeLists

Placelist have the same behavior than places. You can use the following methods. The first methods allows to pass a dictionnary with filter arguments that will be sent directly with the API request.

- (NSURLSessionDataTask *)getPlaceLists:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZPlaceList*> *placeLists))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceListWithId:(NSString *)requestId success:(void (^)(MWZPlaceList *placeList))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceListWithName:(NSString *)name inVenue:(MWZVenue*) venue success:(void (^)(MWZPlaceList *placeList))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceListWithAlias:(NSString *)alias inVenue:(MWZVenue*) venue success:(void (^)(MWZPlaceList *placeList))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPlaceListsForVenue:(MWZVenue *)venue success:(void (^)(NSArray<MWZPlaceList*>* placeLists))success failure:(void (^)(NSError *error))failure;

### Getting directions

To request a direction from one place to another, possibly with intermediate waypoints, the following method can be used:

- (NSURLSessionDataTask *)getDirectionsFrom:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to by: (NSArray<id<MWZDirectionPoint>>*) waypoints withOptions:(MWZDirectionOptions*) options success:(void (^)(MWZDirection *direction))success failure:(void (^)(NSError *error))failure;

### Search engine

MWZVenue, MWZPlace and MWZPlaceList are searchable object. They can be retrieve by the search method.

```
- (NSURLSessionDataTask *)search:(MWZSearchParams*) params success:(void (^)(NSArray<id>*)) success failure:(void (^)(NSError *error))failure;
```

The search parameters are built as follow

```
NSString *query;           // The query string used for the search
NSString *venueId;         // If specified, restricts the search to this venue
NSString *organizationId;  // If specified, restricts the search to this organization
NSString *universeId;      // If specified, restricts the search to this universe
```


## Contact

If you need any help, please contact us at contact@mapwize.io

## License

Mapwize is available under the MIT license. See the LICENSE file for more info.
