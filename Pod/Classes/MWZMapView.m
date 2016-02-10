#import "MWZMapView.h"
#import <WebKit/WebKit.h>
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"

#define SERVER_URL @"https://www.mapwize.io"

@implementation MWZMapView {
    WKWebView* _webview;
    NSNumber* _floor;
    NSArray* _floors;
    
    BOOL _isWebviewLoaded;
    NSMutableArray* _jsQueue;
    
    MWZMapOptions* _options;
}

//- (void) loadWebview {
//    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
//    [userContentController addScriptMessageHandler:self name:@"MWZMapEvent"];
//    
//    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
//    [configuration setUserContentController: userContentController];
//    
//    _webview = [[WKWebView alloc] initWithFrame:[self frame] configuration:configuration];
//    _webview.navigationDelegate = self;
//    [self addSubview:_webview];
//}

- (void) loadMapWithOptions: (MWZMapOptions*) options {
    _isWebviewLoaded = NO;
    _jsQueue = [[NSMutableArray alloc] init];

    /*
     * Loads the webview
     */
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"MWZMapEvent"];
    
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    [configuration setUserContentController: userContentController];
    
    _webview = [[WKWebView alloc] initWithFrame:[self frame] configuration:configuration];
    _webview.navigationDelegate = self;
    [self addSubview:_webview];
    
//    NSBundle* bundle = [self getBundle];
//    NSString *htmlFilePath = [bundle pathForResource:@"map" ofType:@"html"];
//    NSString *htmlTemplate = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
//
//    NSString *html = [htmlTemplate stringByReplacingOccurrencesOfString:@"{{SDK_BASE_URL}}" withString:@"http://localhost:3000/sdk/mapwize.js/1.0.x/"];
    
    //[_webview loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.mapwize.io"]];
    
    [_webview loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/sdk/mapwize-ios-sdk/1.0.x/map.html", SERVER_URL]]]];
    [self executeJS:[NSString stringWithFormat:@"Mapwize.config.SERVER = '%@'", SERVER_URL]];
    
    /*
     * Handles the options
     */
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
    
    NSData *optionsJson = [NSJSONSerialization dataWithJSONObject:optionsDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* optionsString = [[NSString alloc] initWithData:optionsJson encoding:NSUTF8StringEncoding];
    
    /*
     * Set up the map with the options
     */
    [self executeJS:[NSString stringWithFormat:@"var map = Mapwize.map('map',%@);",optionsString]];

    /*
     * Register the event handlers
     */
    [self executeJS:@"map.on('click', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, latlng:e.latlng});});"];
    [self executeJS:@"map.on('floorsChanged', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, floors:this._floors});});"];
    [self executeJS:@"map.on('floorChanged', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, floor:this._floor});});"];
    [self executeJS:@"map.on('placeClick', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, place:e.place});});"];

}
//
//- (NSBundle*) getBundle {
//    NSBundle* podBundle = [NSBundle bundleForClass: self.classForCoder];
//    NSURL* bundleURL = [podBundle URLForResource: @"Mapwize" withExtension: @"bundle"];
//    NSBundle* bundle = [NSBundle bundleWithURL: bundleURL];
//    return bundle;
//}

- (void) executeJS:(NSString*) js {
    
    if (_isWebviewLoaded) {
//        NSLog(@"\"%@\"", js);
        //[_webview evaluateJavaScript:[NSString stringWithFormat:@"console.log('%@')", js] completionHandler:nil];
        [_webview evaluateJavaScript:js completionHandler:nil];
        
    } else {
//        NSLog(@"QUEUED: \"%@\"", js);
        [_jsQueue addObject:js];
    }
    
}

/*
 * Handle the full load of the webview. Any command that was queued so far is executed.
 */
- (void)webView:(WKWebView *)_webView didFinishNavigation:(WKNavigation *)navigation {
    
//    NSLog(@"Webview loaded");
    
    while ([_jsQueue count] > 0) {
        
        NSString* js = [_jsQueue objectAtIndex:0];
        [_jsQueue removeObjectAtIndex:0];
        
//        NSLog(@"%@", js);
        //[_webview evaluateJavaScript:[NSString stringWithFormat:@"console.log('%@')", js] completionHandler:nil];
        [_webview evaluateJavaScript:js completionHandler:nil];
        
    }
    
    _isWebviewLoaded = YES;
    
}

/*
 * Handle the events sent by the js sdk
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    NSLog(@"Message : %@", message.body);
    
    NSDictionary* body = message.body;
    
    if ([body[@"type"] isEqualToString:@"click"]) {
        if (self.delegate != nil) {
            NSDictionary* latlng = body[@"latlng"];
            NSNumber* lat = latlng[@"lat"];
            NSNumber* lng = latlng[@"lng"];
            [self.delegate map:self didClick:[[MWZLatLon alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]]];
        }
    }
    if ([body[@"type"] isEqualToString:@"floorsChanged"]) {
        _floors = body[@"floors"];
        if (self.delegate != nil) {
            [self.delegate map:self didChangeFloors:_floors];
        }
    }
    if ([body[@"type"] isEqualToString:@"floorChanged"]) {
        _floor = body[@"floor"];
        if (self.delegate != nil) {
            [self.delegate map:self didChangeFloor:_floor];
        }
    }
    if ([body[@"type"] isEqualToString:@"placeClick"]) {
        if (self.delegate != nil) {
            [self.delegate map:self didClickOnPlace:body[@"place"]];
        }
    }
    
}

- (void) fitBounds:(MWZLatLonBounds*) bounds {
    [self executeJS:[NSString stringWithFormat:@"map.fitBounds(new L.LatLngBounds(new L.LatLng(%f, %f), new L.LatLng(%f, %f)));", bounds.southWest.latitude, bounds.southWest.longitude, bounds.northEast.latitude, bounds.northEast.longitude]];
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

- (void) access: (NSString*) accessKey {
    [self executeJS:[NSString stringWithFormat:@"map.access('%@', function(){});", accessKey ]];
}

@end
