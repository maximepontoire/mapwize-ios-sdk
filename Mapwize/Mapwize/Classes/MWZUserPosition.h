#import "MWZCoordinate.h"

@interface MWZUserPosition : MWZCoordinate

@property(nonatomic, strong) NSNumber* accuracy;
    
- (instancetype) initWithDictionary:(NSDictionary*) dic;
    
@end
