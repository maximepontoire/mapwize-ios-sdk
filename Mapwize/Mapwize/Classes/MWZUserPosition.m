#import "MWZUserPosition.h"

@implementation MWZUserPosition

- (instancetype) initWithDictionary:(NSDictionary*) dic {
    self = [super initWithDictionary:dic];
    _accuracy = [dic objectForKey:@"accuracy"];
    return self;
}

- (instancetype) initWithMWZCoordinate:(MWZCoordinate*) coordinate accuracy:(NSNumber*) accuracy {
    self = [super initWithLatitude:coordinate.latitude longitude:coordinate.longitude floor:coordinate.floor];
    _accuracy = accuracy;
    return self;
}

- (instancetype) initWithLatitude:(double)latitude longitude:(double)longitude floor:(NSNumber *)floor accuracy:(NSNumber*) accuracy {
    self = [super initWithLatitude:latitude longitude:longitude floor:floor];
    _accuracy = accuracy;
    return self;
}
    
- (NSString *)description {
    if (self.floor != nil) {
        return [NSString stringWithFormat: @"MWZCoordinate: <%f,%f> Floor=%@ Accuracy=%@" , self.coordinate.latitude, self.coordinate.longitude, self.floor, self.accuracy];
    }
    else {
        return [NSString stringWithFormat: @"MWZCoordinate: <%f,%f> Accuracy=%@", self.coordinate.latitude, self.coordinate.longitude, self.accuracy];
    }
    
}
    
@end
