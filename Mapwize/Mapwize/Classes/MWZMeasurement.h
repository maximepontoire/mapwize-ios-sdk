#import <Foundation/Foundation.h>

@interface MWZMeasurement : NSObject

@property double latitude;
@property double longitude;
@property(nonatomic, strong) NSNumber* floor;
@property(nonatomic, strong) NSNumber* accuracy;
@property(nonatomic, strong) NSNumber* validUntil;
@property(nonatomic, strong) NSNumber* validity;
@property(nonatomic, strong) NSString* source;

- (instancetype) initWithLatitude: (double) latitude longitude: (double) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy valitidy: (NSNumber*) validity source: (NSString*) source;
- (instancetype)initFromDictionary:(NSDictionary*)dic;
- (NSString*) toStringJSON;

@end
