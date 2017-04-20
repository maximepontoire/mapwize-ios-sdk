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

- (MWZBounds*) getBounds {
    return [_geometry getBounds];
}

-(NSString *)description {
    return [NSString stringWithFormat: @"MWZVenue: Identifier=%@ Name=%@ Alias=%@", _identifier, _name, _alias];
}

@end
