#import <Foundation/Foundation.h>

@interface MWZStyle : NSObject

@property(nonatomic, strong) NSString* markerUrl;
@property(nonatomic) BOOL markerDisplay;
@property(nonatomic, strong) NSString* strokeColor;
@property(nonatomic, strong) NSNumber* strokeOpacity;
@property(nonatomic, strong) NSNumber* strokeWidth;
@property(nonatomic, strong) NSString* fillColor;
@property(nonatomic, strong) NSNumber* fillOpacity;
@property(nonatomic, strong) NSString* labelBackgroundColor;
@property(nonatomic, strong) NSNumber* labelBackgroundOpacity;

- (instancetype)initFromDictionary:(NSDictionary*)dic;

- (NSDictionary*) toDictionary;

- (NSString*) toJSONString;

@end
