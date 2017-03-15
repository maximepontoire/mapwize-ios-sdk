#import "MWZUserPosition.h"

@implementation MWZUserPosition

- (instancetype) initWithDictionary:(NSDictionary*) dic {
    self = [super initWithDictionary:dic];
    _accuracy = [dic objectForKey:@"accuracy"];
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
