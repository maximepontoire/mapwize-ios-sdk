#import "MWZPlace.h"

@implementation MWZPlace

- (instancetype)initFromDictionnary:(NSDictionary*)dic {
    self = [super init];
    _identifier = [dic objectForKey:@"_id"];
    _name = [dic objectForKey:@"name"];
    _alias = [dic objectForKey:@"alias"];
    _venueId = [dic objectForKey:@"venueId"];
    _translations = [MWZTranslation parseTranslations:[dic objectForKey:@"translations"]];
    _data = [dic objectForKey:@"data"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZPlace: Identifier=%@ Name=%@ Alias=%@ VenueId=%@", _identifier, _name, _alias, _venueId];
}

@end
