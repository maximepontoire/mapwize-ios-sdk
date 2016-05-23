#import <Foundation/Foundation.h>

@interface MWZVenue : NSObject

@property NSString* identifier;
@property NSString* name;
@property NSString* alias;
@property NSDictionary* data;

- (instancetype)initFromDictionnary:(NSDictionary*)dic;

@end
