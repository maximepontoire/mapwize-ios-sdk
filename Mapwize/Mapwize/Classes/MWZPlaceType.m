#import "MWZPlaceType.h"

@implementation MWZPlaceType

- (instancetype)initFromDictionary:(NSDictionary*) dic {
    self = [super init];
    _identifier = [dic objectForKey:@"_id"];
    _name = [dic objectForKey:@"name"];
    _style = [[MWZStyle alloc] initFromDictionary:[dic objectForKey:@"style"]];
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_identifier forKey:@"id"];
    [dic setObject:_name forKey:@"name"];
    [dic setObject:[_style toDictionary] forKey:@"style"];
    return dic;
}

@end
