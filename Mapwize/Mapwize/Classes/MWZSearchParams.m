#import "MWZSearchParams.h"

@implementation MWZSearchParams

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_query != nil) {
        [dic setObject:_query forKey:@"query"];
    }
    if (_venueId != nil) {
        [dic setObject:_venueId forKey:@"venueId"];
    }
    if (_organizationId != nil) {
        [dic setObject:_organizationId forKey:@"organizationId"];
    }
    if (_universeId != nil) {
        [dic setObject:_universeId forKey:@"universeId"];
    }
    return dic;
}
    
@end
