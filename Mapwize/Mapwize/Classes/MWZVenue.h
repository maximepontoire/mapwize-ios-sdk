#import <Foundation/Foundation.h>
#import "MWZGeometry.h"

@interface MWZVenue : NSObject

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* alias;
@property(nonatomic, strong) NSString* defaultLanguage;
@property(nonatomic, strong) NSArray<NSString*>* supportedLanguages;
@property(nonatomic, strong) MWZGeometry* geometry;
@property(nonatomic, strong) MWZCoordinate* marker;
@property(nonatomic, strong) NSString* icon;
@property(nonatomic) BOOL isPublished;
@property(nonatomic) BOOL areQrcodesDeployed;
@property(nonatomic) BOOL areIbeaconsDeployed;
@property(nonatomic, strong) NSDictionary* data;


- (instancetype)initFromDictionary:(NSDictionary*)dic;

- (MWZBounds*) getBounds;

@end
