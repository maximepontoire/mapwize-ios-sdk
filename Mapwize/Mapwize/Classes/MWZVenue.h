#import <Foundation/Foundation.h>

@interface MWZVenue : NSObject

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* alias;
@property(nonatomic, strong) NSDictionary* data;

- (instancetype)initFromDictionary:(NSDictionary*)dic;

@end
