#import "MWZMapOptions.h"

@implementation MWZMapOptions

- (instancetype) init {
    self =  [super init];
    self.locationEnabled = YES;
    self.locationEnabled = YES;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZMapOptions: ApiKey=%@ MaxBounds=%@ Center=%@ Zoom=%@ Floor=%@ LocationEnabled=%@ BeaconsEnabled=%@", _apiKey, _maxBounds, _center, _zoom, _floor, _locationEnabled, _beaconsEnabled];
}

@end
