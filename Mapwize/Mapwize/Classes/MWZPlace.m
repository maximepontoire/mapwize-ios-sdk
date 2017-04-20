#import "MWZPlace.h"
#import "MWZGeometryFactory.h"

@implementation MWZPlace

- (instancetype)initFromDictionary:(NSDictionary*)dic {
    self = [super init];
    _identifier = [dic objectForKey:@"_id"];
    _name = [dic objectForKey:@"name"];
    _alias = [dic objectForKey:@"alias"];
    _venueId = [dic objectForKey:@"venueId"];
    _floor = [dic objectForKey:@"floor"];
    _translations = [MWZTranslation parseTranslations:[dic objectForKey:@"translations"]];
    _order = [dic objectForKey:@"order"];
    _placeTypeId = [dic objectForKey:@"placeTypeId"];
    _isPublished = [[dic objectForKey:@"isPublished"] boolValue];
    _isSearchable = [[dic objectForKey:@"isSearchable"] boolValue];
    _isVisible = [[dic objectForKey:@"isVisible"] boolValue];
    _isClickable = [[dic objectForKey:@"isClickable"] boolValue];
    _tags = [dic objectForKey:@"tags"];
    _style = [[MWZStyle alloc] initWithDictionary:[dic objectForKey:@"style"]];
    _geometry = [MWZGeometryFactory geometryWithDictionary:[dic objectForKey:@"geometry"]];
    _marker = [[MWZCoordinate alloc] initWithDictionary:[dic objectForKey:@"marker"]];
    _entrance = [[MWZCoordinate alloc] initWithDictionary:[dic objectForKey:@"entrance"]];
    _data = [dic objectForKey:@"data"];
    return self;
}

- (NSDictionary*) toDirectionDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_identifier forKey:@"placeId"];
    return dic;
}

- (NSString*) toDirectionStringJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDirectionDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (MWZBounds*) getBounds {
    return [_geometry getBounds];
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZPlace: Identifier=%@ Name=%@ Alias=%@ VenueId=%@", _identifier, _name, _alias, _venueId];
}

@end
