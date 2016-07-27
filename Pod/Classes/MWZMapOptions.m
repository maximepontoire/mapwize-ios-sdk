#import "MWZMapOptions.h"

@implementation MWZMapOptions

- (instancetype) init {
    self =  [super init];
    self.locationEnabled = YES;
    self.beaconsEnabled = NO;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZMapOptions: ApiKey=%@ MaxBounds=%@ MinZoom=%@Center=%@ Zoom=%@ Floor=%@ LocationEnabled=%@ BeaconsEnabled=%@", _apiKey, _maxBounds, _minZoom, _center, _zoom, _floor, _locationEnabled ? @"YES" : @"NO", _beaconsEnabled ? @"YES" : @"NO"];
}

@end
