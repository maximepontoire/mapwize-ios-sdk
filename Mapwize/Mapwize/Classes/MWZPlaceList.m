#import "MWZPlaceList.h"

@implementation MWZPlaceList

- (instancetype)initFromDictionary:(NSDictionary*)dic {
    self = [super init];
    _identifier = [dic objectForKey:@"_id"];
    _name = [dic objectForKey:@"name"];
    _alias = [dic objectForKey:@"alias"];
    _venueId = [dic objectForKey:@"venueId"];
    _placeIds = [dic objectForKey:@"placeIds"];
    _data = [dic objectForKey:@"data"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZPlaceList: Identifier=%@ Name=%@ Alias=%@ VenueId=%@ PlaceIds=%lu", _identifier, _name, _alias, _venueId, (unsigned long) _placeIds.count];
}

- (NSDictionary*) toDirectionDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_identifier forKey:@"placeListId"];
    return dic;
}

- (NSString*) toDirectionStringJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDirectionDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
