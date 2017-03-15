#import "MWZDirectionResponsePoint.h"

@implementation MWZDirectionResponsePoint

- (instancetype) initWithPlaceId: (NSString*) placeId {
    self = [super init];
    _placeId = placeId;
    return self;
}

- (instancetype) initWithVenueId: (NSString*) venueId {
    self = [super init];
    _venueId = venueId;
    return self;
}

- (instancetype) initWithPlaceListId: (NSString*) placeListId {
    self = [super init];
    _placeListId = placeListId;
    return self;
}



- (instancetype) initWithLatitude: (NSNumber*) latitude longitude: (NSNumber*) longitude floor:(NSNumber*) floor {
    self = [super init];
    _latitude = latitude;
    _longitude = longitude;
    _floor = floor;
    return self;
}

- (instancetype)initFromDictionary:(NSDictionary*)dic {
    self = [super init];
    _latitude = [dic objectForKey:@"lat"];
    _longitude = [dic objectForKey:@"lon"];
    _floor = [dic objectForKey:@"floor"];
    _placeId = [dic objectForKey:@"placeId"];
    _venueId = [dic objectForKey:@"venueId"];
    _placeListId =[dic objectForKey:@"placeListId"];
    return self;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (_placeId != nil) {
        [positionDic setObject:[self placeId] forKey:@"placeId"];
    }
    if (_venueId != nil) {
        [positionDic setObject:[self venueId] forKey:@"venueId"];
    }
    if (_placeListId != nil) {
        [positionDic setObject:[self placeListId] forKey:@"placeListId"];
    }
    if (_floor != nil) {
        [positionDic setObject:[self floor] forKey:@"floor"];
    }
    if (_latitude != nil) {
        [positionDic setObject:_latitude forKey:@"lat"];
    }
    if (_longitude != nil) {
        [positionDic setObject:_longitude forKey:@"lon"];
    }
    return positionDic;
}

- (NSString*) toStringJSON {
    
    NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:(NSJSONWritingOptions) 0 error:nil];
    NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
    
    return userPositionString;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZDirectionResponsePoint: Latitude=%@ Longitude=%@ Floor=%@ PlaceId=%@ VenueId=%@ PlaceListId=%@", _latitude, _longitude, _floor, _placeId, _venueId, _placeListId];
}

@end
