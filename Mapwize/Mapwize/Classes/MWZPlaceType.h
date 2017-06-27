#import <Foundation/Foundation.h>
#import "MWZStyle.h"

@interface MWZPlaceType : NSObject

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) MWZStyle* style;

- (instancetype)initFromDictionary:(NSDictionary*) dic;

- (NSDictionary*) toDictionary;

@end
