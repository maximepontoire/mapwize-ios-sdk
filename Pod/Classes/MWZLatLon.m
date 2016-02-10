#import "MWZLatLon.h"

@implementation MWZLatLon

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude{
    self = [super init];
    _latitude = latitude;
    _longitude = longitude;
    return self;
}

- (instancetype)initFromDictionnary:(NSDictionary*)dic {
    self = [super init];
    _latitude = [[dic objectForKey:@"lat"] doubleValue];
    _longitude = [[dic objectForKey:@"lng"] doubleValue];
    return self;
}

- (instancetype)initFromArray:(NSArray*)array {
    self = [super init];
    _latitude = [[array objectAtIndex:0] doubleValue];
    _longitude = [[array objectAtIndex:1] doubleValue];
    return self;
}

- (instancetype)initFromLeaflet:(NSString*)json {
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSObject *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingOptions) 0 error:nil];

    if ([jsonObject isKindOfClass:[NSArray class]]) {
        return [self initFromArray:(NSArray *) jsonObject];
    } else {
        return [self initFromDictionnary:(NSDictionary *) jsonObject];
    }
}

- (NSArray*) toArray {
    NSMutableArray* array = [[NSMutableArray alloc] initWithObjects: @(_latitude), @(_longitude), nil];
    return array;
}


@end
