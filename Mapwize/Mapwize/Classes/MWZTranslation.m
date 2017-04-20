#import "MWZTranslation.h"

@implementation MWZTranslation

- (instancetype)initFromDictionary:(NSDictionary*)dic {
    self = [super init];
    _title = [dic objectForKey:@"title"];
    _subTitle = [dic objectForKey:@"subTitle"];
    _details = [dic objectForKey:@"details"];
    _language = [dic objectForKey:@"language"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZTranslation: Language=%@ Title=%@ Subtitle=%@ Details=%@", _language, _title, _subTitle, _details];
}

+ (NSArray<MWZTranslation*>*) parseTranslations:(NSArray*) translationJSON {
    NSMutableArray* translations = [[NSMutableArray alloc] init];
    if (translationJSON != nil) {
        for (NSDictionary* dic in translationJSON) {
            MWZTranslation* translation = [[MWZTranslation alloc] initFromDictionary:dic];
            [translations addObject:translation];
        }
    }
    return [[NSArray alloc] initWithArray:translations];
}

@end
