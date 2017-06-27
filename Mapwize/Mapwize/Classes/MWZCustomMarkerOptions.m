#import "MWZCustomMarkerOptions.h"

@implementation MWZCustomMarkerOptions

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_iconUrl forKey:@"iconUrl"];
    [dic setObject:_iconAnchor forKey:@"iconAnchor"];
    [dic setObject:_iconSize forKey:@"iconSize"];
    return dic;
}
    
@end
