#import "MWZMapView.h"
#import <WebKit/WebKit.h>
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"

#define SERVER_URL @"https://www.mapwize.io"
#define SDK_VERSION @"1.7.x"
#define IOS_SDK_VERSION @"1.7.1"
#define IOS_SDK_NAME @"IOS SDK"

@implementation MWZMapView {
    WKWebView* _webview;
    NSNumber* _floor;
    NSArray* _floors;
    NSNumber* _zoom;
    BOOL _followUserModeON;
    BOOL _isWebviewLoaded;
    MWZMeasurement* _userPosition;
    NSMutableArray* _jsQueue;
    MWZLatLon* _center;
    NSArray* monitoredUuids;
    MWZMapOptions* _options;
    NSMutableDictionary* callbackMemory;
}

- (void) loadMapWithOptions: (MWZMapOptions*) options {
    _isWebviewLoaded = NO;
    _jsQueue = [[NSMutableArray alloc] init];
    callbackMemory = [[NSMutableDictionary alloc] init];
    
    /*
     * Loads the webview
     */
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"MWZMapEvent"];
    
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    [configuration setUserContentController: userContentController];
#if DEBUG
    [self setBackgroundColor:[UIColor greenColor]];
#endif
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:configuration];
    _webview.navigationDelegate = self;
    _webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_webview];
    
    [_webview loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/sdk/mapwize-ios-sdk/%@/map.html", SERVER_URL, SDK_VERSION]]]];
    _webview.scrollView.bounces = NO;
    [self executeJS:[NSString stringWithFormat:@"Mapwize.config.SERVER = '%@'; Mapwize.config.SDK_NAME = '%@'; Mapwize.config.SDK_VERSION = '%@'; Mapwize.config.CLIENT_APP_NAME = '%@'; ",
                     SERVER_URL, IOS_SDK_NAME, IOS_SDK_NAME, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]]];
    
    /*
     * Handles the options
     */
    _options = options;
    NSMutableDictionary* optionsDic = [[NSMutableDictionary alloc] init];
    if (options.apiKey != nil) {
        [optionsDic setObject:options.apiKey forKey:@"apiKey"];
    }
    if (options.maxBounds != nil) {
        [optionsDic setObject:[options.maxBounds toArray] forKey:@"maxBounds"];
    }
    if (options.center != nil) {
        [optionsDic setObject:[options.center toArray] forKey:@"center"];
    }
    if (options.zoom != nil) {
        [optionsDic setObject:options.zoom forKey:@"zoom"];
    }
    if (options.floor != nil) {
        [optionsDic setObject:options.floor forKey:@"floor"];
    }
    if (options.accessKey != nil) {
        [optionsDic setObject:options.accessKey forKey:@"accessKey"];
    }
    if (options.language != nil) {
        [optionsDic setObject:options.language forKey:@"language"];
    }
    if (options.minZoom != nil) {
        [optionsDic setObject:options.minZoom forKey:@"minZoom"];
    }
    [optionsDic setObject:@0 forKey:@"useBrowserLocation"];
    [optionsDic setObject:@0 forKey:@"zoomControl"];
    
    NSData *optionsJson = [NSJSONSerialization dataWithJSONObject:optionsDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* optionsString = [[NSString alloc] initWithData:optionsJson encoding:NSUTF8StringEncoding];
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
    [js appendString:@"map.on('directionsStart', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, info:'Directions have been loaded'});});"];
    [js appendString:@"map.on('directionsStop', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, info:'Directions have stopped'});});"];
    [js appendString:@"map.on('apiResponse', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, returnedType: e.returnedType, hash:e.hash, response:e.response, error:e.error});});"];
    [js appendString:@"Mapwize.Location.on('monitoredUuidsChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:'monitoredUuidsChange', uuids:e.uuids});});"];
    [js appendString:@"Mapwize.Location.setUseBrowserLocation(false);"]
    ;
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
            NSNumber* lat = latlng[@"lat"];
            NSNumber* lng = latlng[@"lng"];
            [self.delegate map:self didClick:[[MWZLatLon alloc] initWithLatitude:lat longitude:lng]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"contextmenu"]) {
        if ([self.delegate respondsToSelector:@selector(map:didClickLong:)]) {
            NSDictionary* latlng = body[@"latlng"];
            NSNumber* lat = latlng[@"lat"];
            NSNumber* lng = latlng[@"lng"];
            [self.delegate map:self didClickLong:[[MWZLatLon alloc] initWithLatitude:lat longitude:lng]];
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
            [self.delegate map:self didClickOnPlace:[[MWZPlace alloc] initFromDictionnary:body[@"place"]]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"venueClick"]) {
        if ([self.delegate respondsToSelector:@selector(map:didClickOnVenue:)]) {
            [self.delegate map:self didClickOnVenue:[[MWZVenue alloc] initFromDictionnary:body[@"venue"]]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"markerClick"]) {
        MWZPosition* position = [[MWZPosition alloc] initWithLatitude:body[@"lat"] longitude:body[@"lon"] floor:body[@"floor"]];
        if ([self.delegate respondsToSelector:@selector(map:didClickOnMarker:)]) {
            [self.delegate map:self didClickOnMarker:position];
        }
    }
    else if ([body[@"type"] isEqualToString:@"moveend"]) {
        NSDictionary* latlng = body[@"center"];
        NSNumber* lat = latlng[@"lat"];
        NSNumber* lng = latlng[@"lng"];
        _center = [[MWZLatLon alloc] initWithLatitude:lat longitude:lng];
        if ([self.delegate respondsToSelector:@selector(map:didMove:)]) {
            [self.delegate map:self didMove:_center];
        }
    }
    else if ([body[@"type"] isEqualToString:@"userPositionChange"]) {
        NSObject* s = body[@"userPosition"];
        if (s.class != NSNull.class) {
            MWZMeasurement* userPosition = [[MWZMeasurement alloc] initFromDictionnary:body[@"userPosition"]];
            _userPosition = userPosition;
        }
        else {
            _userPosition = nil;
        }
        if ([self.delegate respondsToSelector:@selector(map:didChangeUserPosition:)]) {
            [self.delegate map:self didChangeUserPosition:_userPosition];
        }
    }
    else if ([body[@"type"] isEqualToString:@"followUserModeChange"]) {
        _followUserModeON = [body[@"followUserMode"] boolValue];;
        if ([self.delegate respondsToSelector:@selector(map:didChangeFollowUserMode:)]) {
            [self.delegate map:self didChangeFollowUserMode:_followUserModeON];
        }
    }
    else if ([body[@"type"] isEqualToString:@"directionsStart"]) {
        if ([self.delegate respondsToSelector:@selector(map:didStartDirections:)]) {
            NSString* info = body[@"info"];
            [self.delegate map:self didStartDirections:info];
        }
    }
    else if ([body[@"type"] isEqualToString:@"directionsStop"]) {
        if ([self.delegate respondsToSelector:@selector(map:didStopDirections:)]) {
            NSString* info = body[@"info"];
            [self.delegate map:self didStopDirections:info];
        }
    }
    else if ([body[@"type"] isEqualToString:@"monitoredUuidsChange"]) {
        monitoredUuids = body[@"uuids"];
        [ self updateMonitoring: monitoredUuids ];
    }
    else if ([body[@"type"] isEqualToString:@"apiResponse"]) {
        NSString* hash = body[@"hash"];
        NSString* returnedType = body[@"returnedType"];
        
        if ([returnedType isEqualToString:@"place"]) {
            NSDictionary* response = body[@"response"];
            NSString* err = body[@"error"];
            void(^_handler)(MWZPlace*, NSError*);
            _handler = callbackMemory[hash];
            NSError* error = nil;
            if (err != nil && ![@"" isEqualToString:err]) {
                error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
            }
            if (response[@"_id"] != nil){
                MWZPlace* place = [[MWZPlace alloc] initFromDictionnary:body[@"response"]];
                _handler(place, error);
            }
            else {
                _handler(nil, error);
            }
        }
        else if ([returnedType isEqualToString:@"places"]) {
            NSMutableArray* places = [[NSMutableArray alloc] init];
            NSArray* response = body[@"response"];
            NSString* err = body[@"error"];
            void(^_handler)(NSArray*, NSError*);
            _handler = callbackMemory[hash];
            NSError* error = nil;
            if (err != nil && ![@"" isEqualToString:err]) {
                error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
            }
            if (response.count > 0){
                for (NSDictionary* dic in response) {
                    MWZPlace* place = [[MWZPlace alloc] initFromDictionnary:dic];
                    [places addObject:place];
                }
                _handler([[NSArray alloc] initWithArray:places], error);
            }
            else {
                _handler(nil, error);
            }
        }
        else if ([returnedType isEqualToString:@"venue"]) {
            NSDictionary* response = body[@"response"];
            void(^_handler)(MWZVenue*, NSError*);
            _handler = callbackMemory[hash];
            NSString* err = body[@"error"];
            NSError* error = nil;
            if (err != nil && ![@"" isEqualToString:err]) {
                error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
            }

            if (response[@"_id"] != nil){
                MWZVenue* venue = [[MWZVenue alloc] initFromDictionnary:body[@"response"]];
                _handler(venue, error);
            }
            else {
                _handler(nil, error);
            }
        }
        else if ([returnedType isEqualToString:@"placeList"]) {
            NSDictionary* response = body[@"response"];
            void(^_handler)(MWZPlaceList*, NSError*);
            _handler = callbackMemory[hash];
            NSString* err = body[@"error"];
            NSError* error = nil;
            if (err != nil && ![@"" isEqualToString:err]) {
                error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
            }

            if (response[@"_id"] != nil){
                MWZPlaceList* placeList = [[MWZPlaceList alloc] initFromDictionnary:body[@"response"]];
                _handler(placeList, error);
            }
            else {
                _handler(nil, error);
            }
        }
        else if ([returnedType isEqualToString:@"placeLists"]) {
            NSMutableArray* placeLists = [[NSMutableArray alloc] init];
            NSArray* response = body[@"response"];
            void(^_handler)(NSArray*, NSError*);
            _handler = callbackMemory[hash];
            NSString* err = body[@"error"];
            NSError* error = nil;
            if (err != nil && ![@"" isEqualToString:err]) {
                error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
            }

            if (response.count > 0){
                for (NSDictionary* dic in response) {
                    MWZPlaceList* placeList = [[MWZPlaceList alloc] initFromDictionnary:dic];
                    [placeLists addObject:placeList];
                }
                _handler([[NSArray alloc] initWithArray:placeLists], error);
            }
            else {
                _handler(nil, error);
            }
        }
        else if ([returnedType isEqualToString:@"showDirections"]) {
            void(^_handler)(NSError*);
            _handler = callbackMemory[hash];
            NSString* err = body[@"error"];
            NSError* error = nil;
            if (err != nil && ![@"" isEqualToString:err]) {
                error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
            }
            _handler(error);
            
        }
        else if ([returnedType isEqualToString:@"showDirections"]) {
            void(^_handler)(NSError*);
            _handler = callbackMemory[hash];
            NSString* err = body[@"error"];
            NSError* error = nil;
            if (err != nil && ![@"" isEqualToString:err]) {
                error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
            }
            _handler(error);
            
        }
        else if ([returnedType isEqualToString:@"access"]) {
            void(^_handler)(BOOL);
            _handler = callbackMemory[hash];
            BOOL b = [body[@"response"] boolValue];
            _handler(b);
        }
        else if ([returnedType isEqualToString:@"loadUrl"]) {
            void(^_handler)(NSError*);
            _handler = callbackMemory[hash];
            NSString* err = body[@"error"];
            NSError* error = nil;
            if (err != nil && ![@"" isEqualToString:err]) {
                error = [[NSError alloc] initWithDomain:@"MWZResponseError" code:0 userInfo:nil];
            }
            _handler(error);
        }

        [callbackMemory removeObjectForKey:hash];
        [callbackMemory allKeys];
    }
    
}

- (void) fitBounds:(MWZLatLonBounds*) bounds {
    [self executeJS:[NSString stringWithFormat:@"map.fitBounds(new L.LatLngBounds(new L.LatLng(%@, %@), new L.LatLng(%@, %@)));", bounds.southWest.latitude, bounds.southWest.longitude, bounds.northEast.latitude, bounds.northEast.longitude]];
}

- (void) centerOnCoordinates: (NSNumber*) lat longitude: (NSNumber*) lon floor: (NSNumber*) floor zoom: (NSNumber*) zoom {
    if (floor == nil && zoom == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%@,%@)", lat, lon]];
    }
    else if (floor == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%@,%@, null, %@)", lat, lon, zoom]];
    }
    else if (zoom == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%@,%@,%@,null)", lat, lon, floor]];
    }
    else {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%@,%@,%@,%@)", lat, lon, floor, zoom ]];
    }
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

- (MWZLatLon*) getCenter {
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
- (MWZMeasurement*) getUserPosition {
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
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (latitude != nil) {
        [positionDic setObject:latitude forKey:@"latitude"];
    }
    if (longitude != nil) {
        [positionDic setObject:longitude forKey:@"longitude"];
    }
    if (floor != nil) {
        [positionDic setObject:floor forKey:@"floor"];
    }
    
    if (positionDic.count > 0) {
        [positionDic setObject:@0 forKey:@"accuracy"];
        NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
        NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
        [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.setUserPosition(%@)", userPositionString ]];
    }
    else {
        [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.setUserPosition(null)" ]];
    }
    
}

- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (latitude != nil) {
        [positionDic setObject:latitude forKey:@"latitude"];
    }
    if (longitude != nil) {
        [positionDic setObject:longitude forKey:@"longitude"];
    }
    if (floor != nil) {
        [positionDic setObject:floor forKey:@"floor"];
    }
    if (accuracy != nil) {
        [positionDic setObject:accuracy forKey:@"accuracy"];
    }
    if (positionDic.count > 0) {
        [positionDic setObject:@0 forKey:@"accuracy"];
        NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
        NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
        [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.setUserPosition(%@)", userPositionString ]];
    }
    else {
        [self executeJS:[NSString stringWithFormat:@"Mapwize.Location.setUserPosition(null)" ]];
    }
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
    [self executeJS:[NSString stringWithFormat:@"map.loadUrl('%@', function(err){if (err) {map.fire('apiResponse', {returnedType:'loadUrl', hash:'%@', response:{}, error:0});}})", url, hash ]];
}

/* Markers */
- (void) addMarkerWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (latitude != nil) {
        [positionDic setObject:latitude forKey:@"lat"];
    }
    if (longitude != nil) {
        [positionDic setObject:longitude forKey:@"lon"];
    }
    if (floor != nil) {
        [positionDic setObject:floor forKey:@"floor"];
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

/* Directions */

- (void) showDirectionsFrom: (MWZPosition*) from to: (MWZPosition*) to completionHandler:(void(^)(NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    [self executeJS:[NSString stringWithFormat:@"map.showDirections(%@,%@,null,function(err){if (err) {map.fire('apiResponse', {returnedType:'showDirections', hash:'%@', response:{}, error:0});}});", [from toStringJSON], [to toStringJSON], hash]];
}

- (void) stopDirections {
    [self executeJS:[NSString stringWithFormat:@"map.stopDirections()"]];
}

/* Language */
- (void) setPreferredLanguage: (NSString*) language {
    [self executeJS:[NSString stringWithFormat:@"map.setPreferredLanguage('%@');", language]];
}

/* Access */
- (void) access: (NSString*) accessKey completionHandler:(void(^)(BOOL)) handler{
    NSString* hash = [self generateHash];
    void(^_handler)(BOOL);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    [self executeJS:[NSString stringWithFormat:@"map.access('%@', function(isValid){map.fire('apiResponse', {returnedType:'access', hash:'%@', response:isValid}, true);});", accessKey, hash ]];
}

/* Margin */

- (void) setBottomMargin: (NSNumber*) margin {
    [self executeJS:[NSString stringWithFormat:@"map.setBottomMargin(%@);", margin ]];
}

- (void) setTopMargin: (NSNumber*) margin {
    [self executeJS:[NSString stringWithFormat:@"map.setTopMargin(%@);", margin ]];
}

/* PlaceStyle */

- (void) setStyle: (MWZPlaceStyle*) style forPlaceById: (NSString*) placeId {
    [self executeJS:[NSString stringWithFormat:@"map.setPlaceStyle('%@', %@);", placeId, [style toStringJSON]]];
}

/* API Request */
-(NSString*) generateHash {
    return [[NSUUID UUID] UUIDString];
}

- (void) getPlaceWithId: (NSString*) placeId completionHandler:(void(^)(MWZPlace*, NSError*)) handler {
    
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlace*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getPlace('%@', function(err, place){map.fire('apiResponse', {returnedType:'place', hash:'%@', response:place, error:err?err.status:''});});", placeId, hash ]];
}

- (void) getPlaceWithAlias: (NSString*) placeAlias inVenue: (NSString*) venueId completionHandler:(void(^)(MWZPlace*, NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlace*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getPlace({alias:'%@', venueId:'%@'}, function(err, place){map.fire('apiResponse', {returnedType:'place', hash:'%@', response:place, error:err?err.status:''});});", placeAlias, venueId, hash ]];
}

- (void) getPlaceWithName: (NSString*) placeName inVenue: (NSString*) venueId completionHandler:(void(^)(MWZPlace*, NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlace*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getPlace({name:'%@', venueId:'%@'}, function(err, place){map.fire('apiResponse', {returnedType:'place', hash:'%@', response:place, error:err?err.status:''});});", placeName, venueId, hash ]];
}

- (void) getVenueWithId: (NSString*) venueId completionHandler:(void(^)(MWZVenue*, NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZVenue*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];

    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getVenue('%@', function(err, venue){map.fire('apiResponse', {returnedType:'venue', hash:'%@', response:venue, error:err?err.status:''});});", venueId, hash ]];
}

- (void) getVenueWithName: (NSString*) venueName completionHandler:(void(^)(MWZVenue*, NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZVenue*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getVenue({venueName:'%@'}, function(err, venue){map.fire('apiResponse', {returnedType:'venue', hash:'%@', response:venue, error:err?err.status:''});});", venueName, hash ]];
}

- (void) getVenueWithAlias: (NSString*) venueAlias completionHandler:(void(^)(MWZVenue*, NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZVenue*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getVenue({venueAlias:'%@'}, function(err, venue){map.fire('apiResponse', {returnedType:'venue', hash:'%@', response:venue, error:err?err.status:''});});", venueAlias, hash ]];
}

- (void) getPlaceListWithId: (NSString*) placeListId completionHandler:(void(^)(MWZPlaceList*, NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlaceList*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getPlaceList('%@', function(err, placeList){map.fire('apiResponse', {returnedType:'placeList', hash:'%@', response:placeList, error:err?err.status:''});});", placeListId, hash ]];
}

- (void) getPlaceListWithName: (NSString*) placeListName inVenue:(NSString*) venueId completionHandler:(void(^)(MWZPlaceList*, NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlaceList*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getPlaceList({name:'%@', venueId:'%@'}, function(err, placeList){map.fire('apiResponse', {returnedType:'placeList', hash:'%@', response:placeList, error:err?err.status:''});});", placeListName, venueId, hash ]];
}

- (void) getPlaceListWithAlias: (NSString*) placeListAlias inVenue:(NSString*) venueId completionHandler:(void(^)(MWZPlaceList*, NSError*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlaceList*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getPlaceList({alias:'%@', venueId:'%@'}, function(err, placeList){map.fire('apiResponse', {returnedType:'placeList', hash:'%@', response:placeList, error:err?err.status:''});});", placeListAlias, venueId, hash ]];
}

- (void) getPlaceListsForVenue:(NSString *)venueId completionHandler:(void (^)(NSArray *, NSError*))handler {
    NSString* hash = [self generateHash];
    void(^_handler)(NSArray*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getPlaceLists('%@', function(err, placeLists){map.fire('apiResponse', {returnedType:'placeLists', hash:'%@', response:placeLists, error:err?err.status:''});});", venueId, hash ]];
}

- (void) getPlacesWithPlaceListId:(NSString *)placeListId completionHandler:(void (^)(NSArray*, NSError*))handler {
    NSString* hash = [self generateHash];
    void(^_handler)(NSArray*, NSError*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.Api.getPlaces({placeListId:'%@'}, function(err, places){map.fire('apiResponse', {returnedType:'places', hash:'%@', response:places, error:err?err.status:''});});", placeListId, hash ]];
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
    MWZMeasurement* m = [[MWZMeasurement alloc] initWithLatitude:@(location.coordinate.latitude) longitude:@(location.coordinate.longitude) floor:nil accuracy:@(location.horizontalAccuracy) valitidy:nil source:@"gps"];
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
