#import <Foundation/Foundation.h>
#import "MWZTranslation.h"
#import "MWZStyle.h"
#import "MWZGeometry.h"
#import "MWZDirectionPoint.h"


@interface MWZPlace : NSObject <MWZDirectionPoint>

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* alias;
@property(nonatomic, strong) NSString* venueId;
@property(nonatomic, strong) NSNumber* floor;
@property(nonatomic, strong) NSArray<MWZTranslation*>* translations;
@property(nonatomic, strong) NSNumber* order;
@property(nonatomic, strong) NSString* placeTypeId;
@property(nonatomic) BOOL isPublished;
@property(nonatomic) BOOL isSearchable;
@property(nonatomic) BOOL isVisible;
@property(nonatomic) BOOL isClickable;
@property(nonatomic, strong) NSArray<NSString*>* tags;
@property(nonatomic, strong) MWZStyle* style;
@property(nonatomic, strong) MWZGeometry* geometry;
@property(nonatomic, strong) MWZCoordinate* marker;
@property(nonatomic, strong) MWZCoordinate* entrance;

@property NSDictionary* data;


- (instancetype)initFromDictionary:(NSDictionary*)dic;

- (MWZBounds*) getBounds;

- (NSDictionary*) toDirectionDictionary;
- (NSString*) toDirectionStringJSON;

@end
