#import "MWZPlace.h"
#import "MWZGeometryFactory.h"

@implementation MWZPlace

- (instancetype)initFromDictionary:(NSDictionary*)dic {
    self = [super init];
    _identifier = [dic objectForKey:@"_id"];
    _name = [dic objectForKey:@"name"];
    _alias = [dic objectForKey:@"alias"];
    _venueId = [dic objectForKey:@"venueId"];
    _venue = [[MWZVenue alloc] initFromDictionary:[dic objectForKey:@"venue"]];
    _floor = [dic objectForKey:@"floor"];
    _translations = [MWZTranslation parseTranslations:[dic objectForKey:@"translations"]];
    _order = [dic objectForKey:@"order"];
    _placeTypeId = [dic objectForKey:@"placeTypeId"];
    _placeType = [[MWZPlaceType alloc] initFromDictionary:[dic objectForKey:@"placeType"]];
    _isPublished = [[dic objectForKey:@"isPublished"] boolValue];
    _isSearchable = [[dic objectForKey:@"isSearchable"] boolValue];
    _isVisible = [[dic objectForKey:@"isVisible"] boolValue];
    _isClickable = [[dic objectForKey:@"isClickable"] boolValue];
    _tags = [dic objectForKey:@"tags"];
    _style = [[MWZStyle alloc] initFromDictionary:[dic objectForKey:@"style"]];
    _geometry = [MWZGeometryFactory geometryWithDictionary:[dic objectForKey:@"geometry"]];
    _marker = [[MWZCoordinate alloc] initWithDictionary:[dic objectForKey:@"marker"]];
    _marker.floor = _floor;
    _entrance = [[MWZCoordinate alloc] initWithDictionary:[dic objectForKey:@"entrance"]];
    _entrance.floor = _floor;
    _data = [dic objectForKey:@"data"];
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (_identifier != nil)
        [dic setObject:_identifier forKey:@"_id"];
    if (_name != nil)
        [dic setObject:_name forKey:@"name"];
    if (_alias != nil)
        [dic setObject:_alias forKey:@"alias"];
    if (_venueId != nil)
        [dic setObject:_venueId forKey:@"venueId"];
    if (_floor != nil)
        [dic setObject:_floor forKey:@"floor"];
    if (_order != nil)
        [dic setObject:_order forKey:@"order"];
    if (_placeTypeId != nil)
        [dic setObject:_placeTypeId forKey:@"placeTypeId"];
    if (_placeType != nil)
        [dic setObject:[_placeType toDictionary] forKey:@"placeType"];
    if (_venue != nil) {
        [dic setObject:[_venue toDictionary] forKey:@"venue"];
    }
    [dic setObject:[NSNumber numberWithBool:_isPublished] forKey:@"isPublished"];
    [dic setObject:[NSNumber numberWithBool:_isSearchable] forKey:@"isSearchable"];
    [dic setObject:[NSNumber numberWithBool:_isVisible] forKey:@"isVisible"];
    [dic setObject:[NSNumber numberWithBool:_isClickable] forKey:@"isClickable"];
    if (_style != nil)
        [dic setObject:[_style toDictionary] forKey:@"style"];
    if (_geometry != nil)
        [dic setObject:[_geometry toDictionary] forKey:@"geometry"];
    if (_marker != nil)
        [dic setObject:[_marker toDictionary] forKey:@"marker"];
    if (_entrance != nil)
        [dic setObject:[_entrance toDictionary] forKey:@"entrance"];
    if (_data != nil)
        [dic setObject:_data forKey:@"data"];
    
    if (_translations != nil) {
        NSMutableArray* transationArray = [[NSMutableArray alloc] init];
        for (MWZTranslation* tr in _translations) {
            [transationArray addObject:[tr toDictionary]];
        }
        [dic setObject:transationArray forKey:@"translations"];
    }
    return dic;
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
