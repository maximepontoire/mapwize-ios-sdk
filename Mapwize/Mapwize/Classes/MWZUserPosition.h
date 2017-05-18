#import "MWZCoordinate.h"

@interface MWZUserPosition : MWZCoordinate

@property(nonatomic, strong) NSNumber* accuracy;
    
- (instancetype) initWithDictionary:(NSDictionary*) dic;

- (instancetype) initWithLatitude:(double)latitude longitude:(double)longitude floor:(NSNumber *)floor accuracy:(NSNumber*) accuracy;

- (instancetype) initWithMWZCoordinate:(MWZCoordinate*) coordinate accuracy:(NSNumber*) accuracy;
    
@end
