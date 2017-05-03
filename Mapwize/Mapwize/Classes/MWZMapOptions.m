#import "MWZMapOptions.h"

@implementation MWZMapOptions

- (instancetype) init {
    self =  [super init];
    self.locationEnabled = YES;
    self.beaconsEnabled = NO;
    self.showUserPositionControl = YES;
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* optionsDic = [[NSMutableDictionary alloc] init];
    if (_apiKey != nil) {
        [optionsDic setObject:_apiKey forKey:@"apiKey"];
    }
    if (_maxBounds != nil) {
        [optionsDic setObject:[_maxBounds toArray] forKey:@"maxBounds"];
    }
    if (_bounds != nil) {
        [optionsDic setObject:[_bounds toArray] forKey:@"bounds"];
    }
    if (_center != nil) {
        [optionsDic setObject:[_center toArray] forKey:@"center"];
    }
    if (_zoom != nil) {
        [optionsDic setObject:_zoom forKey:@"zoom"];
    }
    if (_floor != nil) {
        [optionsDic setObject:_floor forKey:@"floor"];
    }
    if (_accessKey != nil) {
        [optionsDic setObject:_accessKey forKey:@"accessKey"];
    }
    if (_language != nil) {
        [optionsDic setObject:_language forKey:@"language"];
    }
    if (_minZoom != nil) {
        [optionsDic setObject:_minZoom forKey:@"minZoom"];
    }
    [optionsDic setObject:@0 forKey:@"useBrowserLocation"];
    [optionsDic setObject:[NSNumber numberWithBool:_showUserPositionControl] forKey:@"showUserPositionControl"];
    [optionsDic setObject:@0 forKey:@"zoomControl"];
    
    return optionsDic;
}

- (NSString*) toJSONString {
    NSData *optionsJson = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    return [[NSString alloc] initWithData:optionsJson encoding:NSUTF8StringEncoding];

}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZMapOptions: ApiKey=%@ MaxBounds=%@ MinZoom=%@Center=%@ Zoom=%@ Floor=%@ LocationEnabled=%@ BeaconsEnabled=%@", _apiKey, _maxBounds, _minZoom, _center, _zoom, _floor, _locationEnabled ? @"YES" : @"NO", _beaconsEnabled ? @"YES" : @"NO"];
}

@end
