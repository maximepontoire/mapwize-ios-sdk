#import <Foundation/Foundation.h>

@interface MWZTranslation : NSObject

@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* subTitle;
@property(nonatomic, strong) NSString* details;
@property(nonatomic, strong) NSString* language;

- (instancetype)initFromDictionary:(NSDictionary*)dic;

+ (NSArray<MWZTranslation*>*) parseTranslations:(NSArray*) translationJSON;


@end
