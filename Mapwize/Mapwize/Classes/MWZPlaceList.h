#import <Foundation/Foundation.h>
#import "MWZDirectionPoint.h"

@interface MWZPlaceList : NSObject <MWZDirectionPoint>

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* alias;
@property(nonatomic, strong) NSString* venueId;
@property(nonatomic, strong) NSArray* placeIds;
@property(nonatomic, strong) NSDictionary* data;

- (instancetype)initFromDictionary:(NSDictionary*)dic;

- (NSDictionary*) toDirectionDictionary;

- (NSString*) toDirectionStringJSON;

@end
