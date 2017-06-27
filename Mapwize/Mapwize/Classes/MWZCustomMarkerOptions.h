#import <Foundation/Foundation.h>

@interface MWZCustomMarkerOptions : NSObject

@property(nonatomic, strong) NSString* iconUrl;
@property(nonatomic, strong) NSArray<NSNumber*>* iconAnchor;
@property(nonatomic, strong) NSArray<NSNumber*>* iconSize;
    
- (NSDictionary*) toDictionary;
    
@end
