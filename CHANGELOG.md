# CHANGELOG

## Version 1.7.1

- Improved location service
- Introduced startLocationWithBeacons: and stopLocation methods in MWZMapView
- Removed webViewDidFinishLoad from MWZMapDelegate. mapDidLoad: callback is now fired when the map is fully loaded

## Version 1.6.0

- Added completionHandlers to all methods which can fail
- Added support for multilingual venues
- General improvements and bugfix

## Version 1.5.0

- Added locationEnabled and beaconsEnables in MapOptions
- Added placeList support with api methods and directions to a list

## Version 1.4.0

- Added method to stop showing directions.
- Added method to set user position with accuracy.
- Added methods to set top and bottom margins (see doc).
- Added the possibility to display user heading. See code in example app.
- Added methods to query venues and places on id, name and alias.
- Added caching to limit network traffic and resist to loss of connection. Call refresh on the map to force the update of the data.
- Improved the doc.
