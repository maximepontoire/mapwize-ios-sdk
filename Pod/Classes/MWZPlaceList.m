#import "MWZPlaceList.h"

@implementation MWZPlaceList

- (instancetype)initFromDictionnary:(NSDictionary*)dic {
    self = [super init];
    _identifier = [dic objectForKey:@"_id"];
    _name = [dic objectForKey:@"name"];
    _alias = [dic objectForKey:@"alias"];
    _venueId = [dic objectForKey:@"venueId"];
    _placeIds = [dic objectForKey:@"placeIds"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZPlaceList: Identifier=%@ Name=%@ Alias=%@ VenueId=%@ PlaceIds=%lu", _identifier, _name, _alias, _venueId, _placeIds.count];
}

@end
