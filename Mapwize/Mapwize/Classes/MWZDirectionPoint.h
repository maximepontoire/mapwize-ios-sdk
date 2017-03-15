#ifndef MWZDirectionPoint_h
#define MWZDirectionPoint_h

@protocol MWZDirectionPoint <NSObject>

- (NSDictionary*) toDirectionDictionary;

- (NSString*) toDirectionStringJSON;

@end

#endif /* MWZDirectionPoint_h */
