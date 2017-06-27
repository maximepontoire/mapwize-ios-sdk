#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Mapwize.h"
#import "MWZApiManager.h"
#import "MWZBounds.h"
#import "MWZCoordinate.h"
#import "MWZCustomMarkerOptions.h"
#import "MWZDirection.h"
#import "MWZDirectionOptions.h"
#import "MWZDirectionPoint.h"
#import "MWZDirectionResponsePoint.h"
#import "MWZGeometry.h"
#import "MWZGeometryFactory.h"
#import "MWZGeometryPoint.h"
#import "MWZGeometryPolygon.h"
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"
#import "MWZMapView.h"
#import "MWZMeasurement.h"
#import "MWZParser.h"
#import "MWZPlace.h"
#import "MWZPlaceList.h"
#import "MWZPlaceType.h"
#import "MWZRoute.h"
#import "MWZSearchParams.h"
#import "MWZSessionManager.h"
#import "MWZStyle.h"
#import "MWZTranslation.h"
#import "MWZUniverse.h"
#import "MWZUserPosition.h"
#import "MWZVenue.h"

FOUNDATION_EXPORT double MapwizeVersionNumber;
FOUNDATION_EXPORT const unsigned char MapwizeVersionString[];

