#import "MWZStyle.h"

@implementation MWZStyle

BOOL markerDisplayDefined = false;

- (instancetype)initFromDictionary:(NSDictionary*)dictionary {
    self = [super init];
    _markerUrl = [dictionary objectForKey:@"markerUrl"];
    _markerDisplay = [[dictionary objectForKey:@"markerDisplay"] boolValue];
    _strokeColor = [dictionary objectForKey:@"strokeColor"];
    if ([_strokeColor isEqualToString:@""]) {
        _strokeColor = nil;
    }
    _strokeOpacity = [dictionary objectForKey:@"strokeOpacity"];
    if (![_strokeOpacity isKindOfClass:NSClassFromString(@"NSNumber")]) {
        _strokeOpacity = nil;
    }
    _strokeWidth = [dictionary objectForKey:@"strokeWidth"];
    if (![_strokeWidth isKindOfClass:NSClassFromString(@"NSNumber")]) {
        _strokeWidth = nil;
    }
    _fillColor = [dictionary objectForKey:@"fillColor"];
    if ([_fillColor isEqualToString:@""]) {
        _fillColor = nil;
    }
    _fillOpacity = [dictionary objectForKey:@"fillOpacity"];
    if (![_fillOpacity isKindOfClass:NSClassFromString(@"NSNumber")]) {
        _fillOpacity = nil;
    }
    _labelBackgroundColor = [dictionary objectForKey:@"labelBackgroundColor"];
    if ([_labelBackgroundColor isEqualToString:@""]) {
        _labelBackgroundColor = nil;
    }
    _labelBackgroundOpacity = [dictionary objectForKey:@"labelBackgroundOpacity"];
    if (![_labelBackgroundOpacity isKindOfClass:NSClassFromString(@"NSNumber")]) {
        _labelBackgroundOpacity = nil;
    }
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_markerUrl != nil) {
        [dic setObject:_markerUrl forKey:@"markerUrl"];
    }
    if (markerDisplayDefined) {
        [dic setObject:[NSNumber numberWithBool:_markerDisplay] forKey:@"markerDisplay"];
    }
    if (_strokeColor != nil) {
        [dic setObject:_strokeColor forKey:@"strokeColor"];
    }
    if (_strokeOpacity != nil) {
        [dic setObject:_strokeOpacity forKey:@"strokeOpacity"];
    }
    if (_strokeWidth != nil) {
        [dic setObject:_strokeWidth forKey:@"strokeWidth"];
    }
    if (_fillColor != nil) {
        [dic setObject:_fillColor forKey:@"fillColor"];
    }
    if (_fillOpacity != nil) {
         [dic setObject:_fillOpacity forKey:@"fillOpacity"];
    }
    if (_labelBackgroundColor != nil) {
        [dic setObject:_labelBackgroundColor forKey:@"labelBackgroundColor"];
    }
    if (_labelBackgroundOpacity != nil) {
        [dic setObject:_labelBackgroundOpacity forKey:@"labelBackgroundOpacity"];
    }
    return dic;
}

- (void) setMarkerDisplay:(BOOL)markerDisplay {
    _markerDisplay = markerDisplay;
    markerDisplayDefined = true;
}

- (NSString*) toJSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
