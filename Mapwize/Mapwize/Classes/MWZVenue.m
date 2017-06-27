#import "MWZVenue.h"
#import "MWZGeometryFactory.h"

@implementation MWZVenue

- (instancetype)initFromDictionary:(NSDictionary*)dic {
    self = [super init];
    _identifier = [dic objectForKey:@"_id"];
    _name = [dic objectForKey:@"name"];
    _alias = [dic objectForKey:@"alias"];
    _defaultLanguage = [dic objectForKey:@"defaultLanguage"];
    _supportedLanguages = [dic objectForKey:@"supportedLanguages"];
    _icon = [dic objectForKey:@"icon"];
    _geometry = [MWZGeometryFactory geometryWithDictionary:[dic objectForKey:@"geometry"]];
    _data = [dic objectForKey:@"data"];
    _marker = [[MWZCoordinate alloc] initWithDictionary:[dic objectForKey:@"marker"]];
    _isPublished = [[dic objectForKey:@"isPublished"] boolValue];
    _areQrcodesDeployed = [[dic objectForKey:@"areQrcodesDeployed"] boolValue];
    _areIbeaconsDeployed = [[dic objectForKey:@"areIbeaconsDeployed"] boolValue];
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
    [dic setObject:[NSNumber numberWithBool:_isPublished] forKey:@"isPublished"];
    if (_geometry != nil)
        [dic setObject:[_geometry toDictionary] forKey:@"geometry"];
    if (_marker != nil)
        [dic setObject:[_marker toDictionary] forKey:@"marker"];
    if (_data != nil)
        [dic setObject:_data forKey:@"data"];
    if (_defaultLanguage != nil)
        [dic setObject:_defaultLanguage forKey:@"defaultLanguage"];
    if (_supportedLanguages != nil)
        [dic setObject:_supportedLanguages forKey:@"supportedLanguages"];
    
    return dic;

}

- (MWZBounds*) getBounds {
    return [_geometry getBounds];
}

-(NSString *)description {
    return [NSString stringWithFormat: @"MWZVenue: Identifier=%@ Name=%@ Alias=%@", _identifier, _name, _alias];
}

@end
