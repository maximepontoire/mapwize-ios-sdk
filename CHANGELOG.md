# CHANGELOG

## Version 2.3.1

- Fixed bug with center map option
- Fixed bug with bounds map option
- Fixed bug with initial zoom not returned in getZoom

## Version 2.3.0

- Added support for external places
- Added displayFloorControl map option
- Added mainColor map option
- Added support for custom marker icon

## Version 2.2.0

- Deprecated methods using latitude, longitude and floor to be replaced by methods using MWZCoordinate or MWZUserPosition
- Changed MWZMeasurement to use double for latitude and longitude instead of NSNumber
- Added a set of methods to promote places (make them displayed with highest priority)
- Added a set of methods to ignore places (hide them)

## Version 2.1.4

- Added documentation for setUniverseForVenue methods
- Added map option to hide user position button

## Version 2.1.3

- Fixed bug to make sure that the callback for MWZMapView loadURL is always called

## Version 2.1.2

- Fixed bug with translation subTitle
- Added API call to retrieve universes for an organization, MWZMapView.setUniverseForVenue can now take a MWZUniverse 
- Added getBounds method for geometries

## Version 2.1.1

- Added API methods to get venues, places and placeLists
- Added geometry and other parameters to MWZVenue

## Version 2.1.0

- [MWZMapView showdirection] is deprecated. Use [MWZApi getDirections] and [MWZMapView startDirections] methods instead.
- MWZLatLon and MWZLatLonBounds are replaced by MWZCoordinate and MWZBounds.
- MWZPosition has been removed. MWZPlace, MWZPlaceList and MWZCoordinate now implement the MWZDirectionPoint interface.
- Introduced MWZApi, a wrapper to easily retrieve Mapwize data. All API methods that were previously linked to the map have been moved to MWZApi.
- The MWZPlace object now includes the geometry
- MWZPlaceStyle has been renamed in MWZStyle

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
