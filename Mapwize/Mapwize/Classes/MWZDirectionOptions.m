#import "MWZDirectionOptions.h"

@implementation MWZDirectionOptions

- (instancetype) init {
    self =  [super init];
    self.isAccessible = NO;
    self.waypointOptimize = NO;
    return self;
}



- (NSString*) toStringJSON {
    NSData *optionsJson = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    return [[NSString alloc] initWithData:optionsJson encoding:NSUTF8StringEncoding];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* optionsDic = [[NSMutableDictionary alloc] init];
    [optionsDic setObject:[NSNumber numberWithBool:self.isAccessible] forKey:@"isAccessible"];
    [optionsDic setObject:[NSNumber numberWithBool:self.waypointOptimize] forKey:@"waypointOptimize"];
    return optionsDic;
}

@end
