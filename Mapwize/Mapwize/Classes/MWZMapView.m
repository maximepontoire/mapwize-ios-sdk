#import "MWZMapView.h"
#import <WebKit/WebKit.h>
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"
#import "MWZParser.h"

#define SERVER_URL @"https://www.mapwize.io"
#define IOS_SDK_VERSION @"2.3.2"
#define IOS_SDK_NAME @"IOS SDK"

@implementation MWZMapView {
    WKWebView* _webview;
    NSNumber* _floor;
    NSArray* _floors;
    NSNumber* _zoom;
    BOOL _followUserModeON;
    BOOL _isWebviewLoaded;
    MWZUserPosition* _userPosition;
    NSMutableArray* _jsQueue;
    MWZCoordinate* _center;
    NSArray* monitoredUuids;
    MWZMapOptions* _options;
    NSMutableDictionary* callbackMemory;
    NSMutableDictionary* _universesByVenues;

}

- (void) loadMapWithOptions: (MWZMapOptions*) options {
    _isWebviewLoaded = NO;
    _jsQueue = [[NSMutableArray alloc] init];
    callbackMemory = [[NSMutableDictionary alloc] init];
    _universesByVenues = [[NSMutableDictionary alloc] init];

    /*
     * Loads the webview
     */
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"MWZMapEvent"];
    
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    [configuration setUserContentController: userContentController];
    
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:configuration];
    _webview.navigationDelegate = self;
    _webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_webview];
    
    NSBundle* podBundle = [NSBundle bundleForClass: [MWZMapView classForCoder]];
    NSURL* bundleURL = [podBundle URLForResource:@"Mapwize" withExtension: @"bundle"];
    NSBundle* mapwizeBundle = [NSBundle bundleWithURL:bundleURL];
    
    NSString* mapPath = [mapwizeBundle pathForResource:@"mwzmap" ofType:@"html"];
    mapPath = [mapPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_webview loadFileURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",mapPath]] allowingReadAccessToURL:[NSURL URLWithString:@"file://"]];
    
    
    _webview.scrollView.bounces = NO;
    [self executeJS:[NSString stringWithFormat:@"Mapwize.config.SERVER = '%@'; Mapwize.config.SDK_NAME = '%@'; Mapwize.config.SDK_VERSION = '%@'; Mapwize.config.CLIENT_APP_NAME = '%@'; ", SERVER_URL, IOS_SDK_NAME, IOS_SDK_VERSION, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]]];
    
    /*
     * Handles the options
     */
    _options = options;
    _zoom = options.zoom;
    NSString* optionsString = [options toJSONString];
    /*
     * Set up the map with the options
     */
    NSMutableString* js = [[NSMutableString alloc] init];
    [js appendString:@"map.on('zoomend', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, zoom:map.getZoom()});});"];
    [js appendString:@"map.on('click', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, latlng:e.latlng});});"];
    [js appendString:@"map.on('contextmenu', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, latlng:e.latlng});});"];
    [js appendString:@"map.on('floorsChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, floors:this._floors});});"];
    [js appendString:@"map.on('floorChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, floor:this._floor});});"];
    [js appendString:@"map.on('placeClick', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, place:e.place});});"];
    [js appendString:@"map.on('venueClick', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, venue:e.venue});});"];
    [js appendString:@"map.on('markerClick', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, lat:e.latlng.lat, lon:e.latlng.lng, floor:e.floor});});"];
    [js appendString:@"map.on('moveend', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, center:map.getCenter()});});"];
    [js appendString:@"map.on('userPositionChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, userPosition:e.userPosition});});"];
    [js appendString:@"map.on('followUserModeChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, followUserMode:e.active});});"];
    [js appendString:@"map.on('directionsStart', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, dir:e.directions, info:'Directions have been loaded'});});"];
    [js appendString:@"map.on('directionsStop', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, info:'Directions have stopped'});});"];
    [js appendString:@"map.on('apiResponse', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, returnedType: e.returnedType, hash:e.hash, response:e.response, error:e.error});});"];
    [js appendString:@"Mapwize.Location.on('monitoredUuidsChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:'monitoredUuidsChange', uuids:e.uuids});});"];
    [js appendString:@"map.on('universeChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:'universeChange', venueId:e.venueId, universeId:e.universeId});});"];
    [js appendString:@"Mapwize.Location.setUseBrowserLocation(false);"];
    [self executeJS:[NSString stringWithFormat:@"var map = Mapwize.map('map',%@, function () {%@window.webkit.messageHandlers.MWZMapEvent.postMessage({type:'maploaded'})});",optionsString, js]];
    
    /*
     * Configures Location manager (authorizations need to be requested outside the SDK)
     */
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    monitoredUuids = [[NSArray alloc] init];
    
}

- (void) executeJS:(NSString*) js {
    
    if (_isWebviewLoaded) {
        [_webview evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
            if (error != nil) {
                if (error.code != 5 && [self.delegate respondsToSelector:@selector(map:didFailWithError:)]) {
                    NSError* err = [[NSError alloc] initWithDomain:@"MWZErrorDomain" code:1936 userInfo:nil];
                    [self.delegate map:self didFailWithError:err];
                }
            }
        }];
    } else {
        [_jsQueue addObject:js];
    }
}

/*
 * Handle the full load of the webview. Any command that was queued so far is executed.
 */
- (void)webView:(WKWebView *)_webView didFinishNavigation:(WKNavigation *)navigation {
    while ([_jsQueue count] > 0) {
        NSString* js = [_jsQueue objectAtIndex:0];
        [_jsQueue removeObjectAtIndex:0];
        [_webview evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
            if (error != nil) {
                if (error.code != 5 && [self.delegate respondsToSelector:@selector(map:didFailWithError:)]) {
                    NSError* err = [[NSError alloc] initWithDomain:@"MWZErrorDomain" code:1936 userInfo:nil];
                    [self.delegate map:self didFailWithError:err];
                }
            }
        }];
    }
    _isWebviewLoaded = YES;
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(map:didFailWithError:)]) {
        [self.delegate map:self didFailWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(map:didFailWithError:)]) {
        [self.delegate map:self didFailWithError:error];
    }
}


/*
 * Handle the events sent by the js sdk
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSDictionary* body = message.body;
    
    if ([body[@"type"] isEqualToString:@"maploaded"]) {
        
        if (_options.locationEnabled) {
            [self startLocationWithBeacons:_options.beaconsEnabled];
        }
        if ([self.delegate respondsToSelector:@selector(mapDidLoad:)]) {
            [self.delegate mapDidLoad: self];
        }
    }
    else if ([body[@"type"] isEqualToString:@"zoomend"]) {
        _zoom = body[@"zoom"];
        if ([self.delegate respondsToSelector:@selector(map:didChangeZoom:)]) {
            [self.delegate map:self didChangeZoom:_zoom];
        }
    }
    else if ([body[@"type"] isEqualToString:@"click"]) {
        if ([self.delegate respondsToSelector:@selector(map:didClick:)]) {
            NSDictionary* latlng = body[@"latlng"];
            double lat = [latlng[@"lat"] doubleValue];
            double lng = [latlng[@"lng"] doubleValue];
            [self.delegate map:self didClick:[[MWZCoordinate alloc] initWithLatitude:lat longitude:lng floor:nil]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"contextmenu"]) {
        if ([self.delegate respondsToSelector:@selector(map:didClickLong:)]) {
            NSDictionary* latlng = body[@"latlng"];
            double lat = [latlng[@"lat"] doubleValue];
            double lng = [latlng[@"lng"] doubleValue];
            
            [self.delegate map:self didClickLong:[[MWZCoordinate alloc] initWithLatitude:lat longitude:lng floor:nil]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"floorsChange"]) {
        _floors = body[@"floors"];
        if ([self.delegate respondsToSelector:@selector(map:didChangeFloors:)]) {
            [self.delegate map:self didChangeFloors:_floors];
        }
    }
    else if ([body[@"type"] isEqualToString:@"floorChange"]) {
        _floor = body[@"floor"];
        if ([self.delegate respondsToSelector:@selector(map:didChangeFloor:)]) {
            [self.delegate map:self didChangeFloor:_floor];
        }
    }
    else if ([body[@"type"] isEqualToString:@"placeClick"]) {
        if ([self.delegate respondsToSelector:@selector(map:didClickOnPlace:)]) {
            [self.delegate map:self didClickOnPlace:[[MWZPlace alloc] initFromDictionary:body[@"place"]]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"venueClick"]) {
        if ([self.delegate respondsToSelector:@selector(map:didClickOnVenue:)]) {
            [self.delegate map:self didClickOnVenue:[[MWZVenue alloc] initFromDictionary:body[@"venue"]]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"markerClick"]) {
        double lat = [body[@"lat"] doubleValue];
        double lng = [body[@"lon"] doubleValue];
        MWZCoordinate* position = [[MWZCoordinate alloc] initWithLatitude:lat longitude:lng floor:body[@"floor"]];
        if ([self.delegate respondsToSelector:@selector(map:didClickOnMarker:)]) {
            [self.delegate map:self didClickOnMarker:position];
        }
    }
    else if ([body[@"type"] isEqualToString:@"moveend"]) {
        NSDictionary* latlng = body[@"center"];
        double lat = [latlng[@"lat"] doubleValue];
        double lng = [latlng[@"lng"] doubleValue];
        _center = [[MWZCoordinate alloc] initWithLatitude:lat longitude:lng floor:nil];
        if ([self.delegate respondsToSelector:@selector(map:didMove:)]) {
            [self.delegate map:self didMove:_center];
        }
    }
    else if ([body[@"type"] isEqualToString:@"userPositionChange"]) {
        NSObject* s = body[@"userPosition"];
        if (s.class != NSNull.class) {
            MWZUserPosition* userPosition = [[MWZUserPosition alloc] initWithDictionary:body[@"userPosition"]];
            _userPosition = userPosition;
            if ([self.delegate respondsToSelector:@selector(map:didChangeUserPosition:)]) {
                [self.delegate map:self didChangeUserPosition:_userPosition];
            }
        }
        else {
            _userPosition = nil;
        }
    }
    else if ([body[@"type"] isEqualToString:@"followUserModeChange"]) {
        _followUserModeON = [body[@"followUserMode"] boolValue];;
        if ([self.delegate respondsToSelector:@selector(map:didChangeFollowUserMode:)]) {
            [self.delegate map:self didChangeFollowUserMode:_followUserModeON];
        }
    }
    else if ([body[@"type"] isEqualToString:@"monitoredUuidsChange"]) {
        monitoredUuids = body[@"uuids"];
        [ self updateMonitoring: monitoredUuids ];
    }
    else if ([body[@"type"] isEqualToString:@"apiResponse"]) {
        NSString* hash = body[@"hash"];
        NSString* returnedType = body[@"returnedType"];
        
        if ([returnedType isEqualToString:@"loadUrl"]) {
            void(^_handler)(NSError*);
            _handler = callbackMemory[hash];
            if (_handler!= nil) {
                NSString* err = body[@"error"];
                NSError* error = nil;
                if (err != nil && ![@"0" isEqualToString:err]) {
                    error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
                }
                _handler(error);
            }
        }
        
        [callbackMemory removeObjectForKey:hash];
        [callbackMemory allKeys];
    }
    else if ([body[@"type"] isEqualToString:@"universeChange"]) {
        if (body[@"venueId"] != nil){
            [_universesByVenues setObject:body[@"venueId"] forKey:body[@"universeId"]];
        }
    }

    
}

/* Universe */
- (void) setUniverseForVenue: (MWZVenue*) venue withUniverseId:(NSString*) universeId {
    [self executeJS:[NSString stringWithFormat:@"map.setUniverseForVenue('%@', '%@');", universeId, venue.identifier]];
}

- (void) setUniverseForVenue: (MWZVenue*) venue withUniverse:(MWZUniverse*) universe {
    [self setUniverseForVenue:venue withUniverseId:universe.identifier];
}

- (NSString*) getUniverseForVenue: (NSString*) venueId {
    return [_universesByVenues objectForKey:venueId];
}


- (void) fitBounds:(MWZBounds*) bounds {
    [self executeJS:[NSString stringWithFormat:@"map.fitBounds(new L.LatLngBounds(new L.LatLng(%f, %f), new L.LatLng(%f, %f)));", bounds.southWest.coordinate.latitude, bounds.southWest.coordinate.longitude, bounds.northEast.coordinate.latitude, bounds.northEast.coordinate.longitude]];
}

- (void) centerOnCoordinates: (MWZCoordinate*) coordinate withZoom:(NSNumber*) zoom {
    if (coordinate.floor == nil && zoom == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%f,%f)", coordinate.latitude, coordinate.longitude]];
    }
    else if (coordinate.floor == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%f,%f, null, %@)", coordinate.latitude, coordinate.longitude, zoom]];
    }
    else if (zoom == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%f,%f,%@,null)", coordinate.latitude, coordinate.longitude, coordinate.floor]];
    }
    else {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%f,%f,%@,%@)", coordinate.latitude, coordinate.longitude, coordinate.floor, zoom ]];
    }
}

- (void) centerOnCoordinates: (NSNumber*) latitude longitude: (NSNumber*) longitude floor: (NSNumber*) floor zoom: (NSNumber*) zoom {
    MWZCoordinate* coord = [[MWZCoordinate alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue] floor:floor];
    [self centerOnCoordinates:coord withZoom:zoom];
}

- (NSNumber*) getFloor {
    return _floor;
}

- (NSArray*) getFloors {
    return _floors;
}

- (void) setFloor: (NSNumber*) floor {
    [self executeJS:[NSString stringWithFormat:@"map.setFloor(%@)", floor ]];
}

- (void) setZoom:(NSNumber *)zoom {
    [self executeJS:[NSString stringWithFormat:@"map.setZoom(%@)", zoom ]];
}

- (NSNumber*) getZoom {
    return _zoom;
}

- (MWZCoordinate*) getCenter {
    return _center;
};

- (void) centerOnVenueById: (NSString*) venueId {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnVenue('%@')", venueId ]];
}
- (void) centerOnVenue: (MWZVenue*) venue {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnVenue('%@')", venue.identifier ]];
}

- (void) centerOnPlaceById: (NSString*) placeId {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnPlace('%@')", placeId ]];
}
- (void) centerOnPlace: (MWZPlace*) place {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnPlace('%@')", place.identifier ]];
}

- (BOOL) getFollowUserMode {
    return _followUserModeON;
}

- (void) setFollowUserMode: (BOOL) follow {
    [self executeJS:[NSString stringWithFormat:@"map.setFollowUserMode(%@)", (follow?@"true":@"false") ]];
}

- (void) centerOnUser: (NSNumber*) zoom {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnUser(%@)", zoom ]];
}



/* User Position */
- (MWZUserPosition*) getUserPosition {
    return _userPosition;
}

- (void) newUserPositionMeasurement: (MWZMeasurement*) measurement {
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.newUserPositionMeasurement(%@)", [measurement toStringJSON] ]];
}

- (void) setUserHeading: (NSNumber*) heading {
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.setUserHeading(%@)", heading!=nil?heading:@"null" ]];
}

- (void) removeUserPosition {
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.setUserPosition(null)"]];
}

- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor {
    MWZUserPosition* up = [[MWZUserPosition alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue] floor:floor accuracy:@0];
    [self setUserPosition:up];}

- (void) setUserPosition:(MWZUserPosition*) userPosition {
    if (userPosition == nil) {
        [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.setUserPosition(null)" ]];
    }
    else {
        NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
        [positionDic setObject:@(userPosition.latitude) forKey:@"latitude"];
        [positionDic setObject:@(userPosition.longitude) forKey:@"longitude"];
        if (userPosition.floor != nil) {
            [positionDic setObject:userPosition.floor forKey:@"floor"];
        }
        [positionDic setObject:userPosition.accuracy forKey:@"accuracy"];
        NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
        NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
        [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.setUserPosition(%@)", userPositionString ]];
    }
}

- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy {
    MWZUserPosition* up = [[MWZUserPosition alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue] floor:floor accuracy:accuracy];
    [self setUserPosition:up];
}

- (void) unlockUserPosition {
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.unlockUserPosition()"]];
    
}

/* URL */
- (void) loadURL: (NSString*) url completionHandler:(void(^)(NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    [self executeJS:[NSString stringWithFormat:@"map.loadUrl('%@', function(err, result){map.fire('apiResponse', {returnedType:'loadUrl', hash:'%@', response:result, error:err?'1':'0'});})", url, hash ]];
}

/* Markers */
- (void) addMarkerWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor {
    MWZCoordinate* coord = [[MWZCoordinate alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue] floor:floor];
    [self addMarkerWithCoordinate:coord];
}

- (void) addMarkerWithCoordinate: (MWZCoordinate*) coordinate {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    [positionDic setObject:@(coordinate.latitude) forKey:@"latitude"];
    [positionDic setObject:@(coordinate.longitude) forKey:@"longitude"];
    if (coordinate.floor != nil) {
        [positionDic setObject:coordinate.floor forKey:@"floor"];
    }
    NSData *positionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* positionString = [[NSString alloc] initWithData:positionJSON encoding:NSUTF8StringEncoding];
    
    [self executeJS:[NSString stringWithFormat:@"map.addMarker(%@)", positionString ]];
}

- (void) addMarkerWithPlaceId: (NSString*) placeId {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (placeId != nil) {
        [positionDic setObject:placeId forKey:@"placeId"];
    }
    NSData *positionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* positionString = [[NSString alloc] initWithData:positionJSON encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"map.addMarker(%@)", positionString ]];
}

- (void) removeMarkers {
    [self executeJS:[NSString stringWithFormat:@"map.removeMarkers()"]];
}

/* Promote places */
- (void) setPromotedPlaces:(NSArray<MWZPlace*>*) places {
    if (places == nil) {
        [self setPromotedPlacesWithIds:nil];
    }
    else {
        NSMutableArray<NSString*>* arr = [[NSMutableArray alloc] init];
        for (MWZPlace* place in places) {
            [arr addObject:place.identifier];
        }
        [self setPromotedPlacesWithIds:arr];
    }
}

- (void) setPromotedPlacesWithIds:(NSArray<NSString*>*) placeIds {
    if (placeIds == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.setPromotePlaces(null);"]];
    }
    else {
        NSData *data = [NSJSONSerialization dataWithJSONObject:placeIds options:NSJSONWritingPrettyPrinted error:nil];
        NSString* json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self executeJS:[NSString stringWithFormat:@"map.setPromotePlaces(%@);", json]];
    }
}

- (void) addPromotedPlace:(MWZPlace*) place {
    [self addPromotedPlaceWithId:place.identifier];
}

- (void) addPromotedPlaceWithId:(NSString*) placeId {
    [self executeJS:[NSString stringWithFormat:@"map.addPromotePlace('%@');", placeId]];
}

- (void) addPromotedPlaces:(NSArray<MWZPlace*>*) places {
    NSMutableArray<NSString*>* arr = [[NSMutableArray alloc] init];
    for (MWZPlace* place in places) {
        [arr addObject:place.identifier];
    }
    [self addPromotedPlacesWithIds:arr];
}

- (void) addPromotedPlacesWithIds:(NSArray<NSString*>*) placeIds {
    NSData *data = [NSJSONSerialization dataWithJSONObject:placeIds options:NSJSONWritingPrettyPrinted error:nil];
    NSString* json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"map.addPromotePlaces(%@);", json]];
}

- (void) removePromotedPlace:(MWZPlace*) place {
    [self removePromotedPlaceWithId:place.identifier];
}

- (void) removePromotedPlaceWithId:(NSString*) placeId {
    [self executeJS:[NSString stringWithFormat:@"map.removePromotePlace('%@');", placeId]];
}

- (void) setExternalPlaces: (NSArray<MWZPlace*>*) externalPlaces {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (MWZPlace* p in externalPlaces) {
        [array addObject:[p toDictionary]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString* json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"map.setExternalPlaces(%@);", json]];
}


/* Ignore places */
- (void) addIgnoredPlace:(MWZPlace*) place {
    [self addIgnoredPlaceWithId:place.identifier];
}

- (void) addIgnoredPlaceWithId:(NSString*) placeId {
    [self executeJS:[NSString stringWithFormat:@"map.addIgnorePlace('%@');", placeId]];
}

- (void) removeIgnoredPlace:(MWZPlace*) place {
    [self removeIgnoredPlaceWithId:place.identifier];
}

- (void) removeIgnoredPlaceWithId:(NSString*) placeId {
    [self executeJS:[NSString stringWithFormat:@"map.removeIgnorePlace('%@');", placeId]];
}

- (void) setIgnoredPlaces:(NSArray<MWZPlace*>*) places {
    if (places == nil) {
        [self setIgnoredPlacesWithIds:nil];
    }
    else {
        NSMutableArray<NSString*>* arr = [[NSMutableArray alloc] init];
        for (MWZPlace* place in places) {
            [arr addObject:place.identifier];
        }
        [self setIgnoredPlacesWithIds:arr];
    }

}

- (void) setIgnoredPlacesWithIds:(NSArray<NSString*>*) placeIds {
    if (placeIds == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.setIgnorePlaces(null);"]];
    }
    else {
        NSData *data = [NSJSONSerialization dataWithJSONObject:placeIds options:NSJSONWritingPrettyPrinted error:nil];
        NSString* json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self executeJS:[NSString stringWithFormat:@"map.setIgnorePlaces(%@);", json]];
    }
}


/* Directions */
- (void) startDirections: (MWZDirection*) direction {
    [self executeJS:[NSString stringWithFormat:@"map.startDirections(%@);", [direction toStringJSON]]];
}

- (void) stopDirections {
    [self executeJS:[NSString stringWithFormat:@"map.stopDirections()"]];
}

/* Language */
- (void) setPreferredLanguage: (NSString*) language {
    [self executeJS:[NSString stringWithFormat:@"map.setPreferredLanguage('%@');", language]];
}

/* Margin */

- (void) setBottomMargin: (NSNumber*) margin {
    [self executeJS:[NSString stringWithFormat:@"map.setBottomMargin(%@);", margin ]];
}

- (void) setTopMargin: (NSNumber*) margin {
    [self executeJS:[NSString stringWithFormat:@"map.setTopMargin(%@);", margin ]];
}

/* PlaceStyle */

- (void) setStyle: (MWZStyle*) style forPlaceById: (NSString*) placeId {
    [self executeJS:[NSString stringWithFormat:@"map.setPlaceStyle('%@', %@);", placeId, [style toJSONString]]];
}

/* API Request */
-(NSString*) generateHash {
    return [[NSUUID UUID] UUIDString];
}


- (void) refresh {
    [self executeJS:[NSString stringWithFormat:@"map.refresh()"]];
}

- (void) startLocationWithBeacons:(BOOL) useBeacons {
    [self unlockUserPosition];
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    _options.beaconsEnabled = useBeacons;
    if (_options.beaconsEnabled) {
        [self updateMonitoring:monitoredUuids];
    }
}

- (void) stopLocation {
    [_locationManager stopUpdatingLocation];
    [_locationManager stopUpdatingHeading];
    [self setUserHeading:nil];
    [self removeUserPosition];
    _options.beaconsEnabled = false;
    [self updateMonitoring:@[]];
}

/* location manager methods */
- (void) updateMonitoring: (NSArray*) uuids {
    NSArray* rangedRegion = [[_locationManager rangedRegions] copy];
    for (CLBeaconRegion* region in rangedRegion) {
        [_locationManager stopRangingBeaconsInRegion:region];
    }
    if (_options.beaconsEnabled) {
        for (NSString* uuidString in uuids) {
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
            CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuidString];
            [_locationManager startRangingBeaconsInRegion:region];
        }
    }
}

#pragma mark Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* location = [locations objectAtIndex:0];
    MWZMeasurement* m = [[MWZMeasurement alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude floor:nil accuracy:@(location.horizontalAccuracy) valitidy:nil source:@"gps"];
    [self newUserPositionMeasurement:m];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    [self setUserHeading:[NSNumber numberWithFloat:newHeading.trueHeading]];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    NSMutableArray* beaconsToJS = [[NSMutableArray alloc] init];
    
    for (CLBeacon* beacon in beacons) {
        NSMutableDictionary* beaconDic = [[NSMutableDictionary alloc] init];
        [beaconDic setObject:[beacon.proximityUUID UUIDString] forKey:@"uuid"];
        [beaconDic setObject:beacon.major forKey:@"major"];
        [beaconDic setObject:beacon.minor forKey:@"minor"];
        [beaconDic setObject:@(beacon.rssi) forKey:@"rssi"];
        [beaconDic setObject:@(beacon.accuracy) forKey:@"accuracy"];
        [beaconsToJS addObject:beaconDic];
    }
    NSData *beaconsJSON = [NSJSONSerialization dataWithJSONObject:beaconsToJS options:(NSJSONWritingOptions) 0 error:nil];
    NSString* beaconsString = [[NSString alloc] initWithData:beaconsJSON encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.addRangedIBeacons('%@',%@);", region.identifier, beaconsString]];
}

@end
