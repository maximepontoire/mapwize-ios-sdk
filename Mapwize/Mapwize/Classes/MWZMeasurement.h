#import <Foundation/Foundation.h>

@interface MWZMeasurement : NSObject

@property(nonatomic, strong) NSNumber* latitude;
@property(nonatomic, strong) NSNumber* longitude;
@property(nonatomic, strong) NSNumber* floor;
@property(nonatomic, strong) NSNumber* accuracy;
@property(nonatomic, strong) NSNumber* validUntil;
@property(nonatomic, strong) NSNumber* validity;
@property(nonatomic, strong) NSString* source;

- (instancetype) initWithLatitude: (NSNumber*) latitude longitude: (NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy valitidy: (NSNumber*) validity source: (NSString*) source;
- (instancetype)initFromDictionary:(NSDictionary*)dic;
- (NSString*) toStringJSON;

@end
