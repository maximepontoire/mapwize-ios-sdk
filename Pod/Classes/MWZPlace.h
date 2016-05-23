#import <Foundation/Foundation.h>
#import "MWZTranslation.h"

@interface MWZPlace : NSObject

@property NSString* identifier;
@property NSString* name;
@property NSString* alias;
@property NSString* venueId;
@property NSArray<MWZTranslation*>* translations;
@property NSDictionary* data;

- (instancetype)initFromDictionnary:(NSDictionary*)dic;

@end
