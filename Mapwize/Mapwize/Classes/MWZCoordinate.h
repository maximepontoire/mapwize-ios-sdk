#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MWZDirectionPoint.h"

@interface MWZCoordinate : NSObject <MWZDirectionPoint>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSNumber* floor;

- (instancetype) initWithLatitude:(double) latitude longitude:(double) longitude floor:(NSNumber*) floor;

- (instancetype) initWithArray:(NSArray*) array;

- (instancetype) initWithDictionary:(NSDictionary*) dic;

- (CLLocationCoordinate2D) coordinate;

- (double) latitude;

- (double) longitude;

- (NSNumber*) floor;

- (NSDictionary*) toDictionary;

- (NSArray*) toArray;

- (NSDictionary*) toDirectionDictionary;

- (NSString*) toDirectionStringJSON;

@end
