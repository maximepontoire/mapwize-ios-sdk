# Mapwize

[![Version](https://img.shields.io/cocoapods/v/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)
[![License](https://img.shields.io/cocoapods/l/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)
[![Platform](https://img.shields.io/cocoapods/p/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)

This is the Mapwize iOS SDK, version 1.x.

It allows you to display and interact with Mapwize venue maps.

## Requirements

iOS 8 or higher

## Installation

Mapwize is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Mapwize"
```

## Example application

An example application is provided in this repository. To run it, clone the repo, and run `pod install` from the Example directory first. Then simply open Mapwize.xcworkspace.

## Documentation

To display the Mapwize app, create an instance of MWZMapView then, in your view controller, call the method 

	[map loadMapWithOptions: options];
	
This will load the map in the view with the provided options.

Options are defined using the class MWZMapOptions. The following options are available:

- apiKey : [NSString] must be provided for the map to load. It can be obtained from the Mapwize administration interface. If you don't have any, contact us.
- maxBounds : [MWZLatLonBounds] region users are allowed to navigate in.
- center: [MWZLatLon] coordiantes of the center of the map at start-up.
- zoom : [NSNumber] integer between 0 and 21.
- floor : [NSNumber] integer represneting the desired floor of the building.

Once the map loaded, you can use the following functions on the map instance:

- (void) fitBounds:(MWZLatLonBounds*) bounds - moves the map so the specified bound is completely visible.
- (NSNumber*) getFloor - returns the floor currently displayed.
- (NSArray*) getFloors - returns the list of floors available at the current viewing position.
- (void) setFloor: (NSNumber*) floor - changes the displayed floor.
- (void) access: (NSString*) accessKey - enters an access key to gain access to private buildings. Access keys are managed in the Mapwize administration interface and are provided by venue managers.

You can also listen for events emitted by the map using the MWZMapDelegate. To do so, set the delegate class using

    map.delegate = self;

then implement the following methods

- (void) map:(MWZMapView\*) map didClick:(MWZLatLon\*) latlon;
- (void) map:(MWZMapView\*) map didClickOnPlace:(NSDictionary\*) place;
- (void) map:(MWZMapView\*) map didChangeFloor:(NSNumber\*) floor;
- (void) map:(MWZMapView\*) map didChangeFloors:(NSArray\*) floors;


## Contact

If you need any help, please contact us at contact@mapwize.io

## License

Mapwize is available under the MIT license. See the LICENSE file for more info.
