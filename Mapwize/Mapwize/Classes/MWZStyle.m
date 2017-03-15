#import "MWZStyle.h"

@implementation MWZStyle

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    _markerUrl = [dictionary objectForKey:@"markerUrl"];
    _markerDisplay = [[dictionary objectForKey:@"markerDisplay"] boolValue];
    _strokeColor = [dictionary objectForKey:@"strokeColor"];
    _strokeOpacity = [dictionary objectForKey:@"strokeOpacity"];
    _strokeWidth = [dictionary objectForKey:@"strokeWidth"];
    _fillColor = [dictionary objectForKey:@"fillColor"];
    _fillOpacity = [dictionary objectForKey:@"fillOpacity"];
    _labelBackgroundColor = [dictionary objectForKey:@"labelBackgroundColor"];
    _labelBackgroundOpacity = [dictionary objectForKey:@"labelBackgroundOpacity"];
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_markerUrl != nil) {
        [dic setObject:_markerUrl forKey:@"markerUrl"];
    }
    [dic setObject:[NSNumber numberWithBool:_markerDisplay] forKey:@"markerDisplay"];
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

- (NSString*) toJSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
