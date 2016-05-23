#import "MWZTranslation.h"

@implementation MWZTranslation

- (instancetype)initFromDictionnary:(NSDictionary*)dic {
    self = [super init];
    _title = [dic objectForKey:@"title"];
    _subtitle = [dic objectForKey:@"subtitle"];
    _details = [dic objectForKey:@"details"];
    _language = [dic objectForKey:@"language"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZTranslation: Language=%@ Title=%@ Subtitle=%@ Details=%@", _language, _title, _subtitle, _details];
}

+ (NSArray<MWZTranslation*>*) parseTranslations:(NSArray*) translationJSON {
    NSMutableArray* translations = [[NSMutableArray alloc] init];
    if (translationJSON != nil) {
        for (NSDictionary* dic in translationJSON) {
            MWZTranslation* translation = [[MWZTranslation alloc] initFromDictionnary:dic];
            [translations addObject:translation];
        }
    }
    return [[NSArray alloc] initWithArray:translations];
}

@end
