#import <Foundation/Foundation.h>

@interface MWZTranslation : NSObject

@property NSString* title;
@property NSString* subtitle;
@property NSString* details;
@property NSString* language;

- (instancetype)initFromDictionnary:(NSDictionary*)dic;

+ (NSArray<MWZTranslation*>*) parseTranslations:(NSArray*) translationJSON;


@end
