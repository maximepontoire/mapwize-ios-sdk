#import <Foundation/Foundation.h>

@interface MWZUniverse : NSObject

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* alias;

- (instancetype)initFromDictionary:(NSDictionary*)dic;


@end
