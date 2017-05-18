#import "MWZApiManager.h"

static NSString *const kAccessUrl = @"/api/v1/access/%@";
static NSString *const kVenueUrl = @"/api/v1/venues/%@";
static NSString *const kVenuesUrl = @"/api/v1/venues";
static NSString *const kUniversesUrl = @"/api/v1/universes";
static NSString *const kPlaceUrl = @"/api/v1/places/%@";
static NSString *const kPlacesUrl = @"/api/v1/places";
static NSString *const kPlacesForPlaceListUrl = @"/api/v1/placeLists/%@/places";
static NSString *const kPlaceListUrl = @"/api/v1/placeLists/%@";
static NSString *const kPlaceListsUrl = @"/api/v1/placeLists";
static NSString *const kDirectionsUrl = @"/api/v1/directions?api_key=%@";
static NSString *const kSearchUrl = @"/api/v1/search?api_key=%@";

@implementation MWZApiManager

- (NSURLSessionDataTask *)getAccessWithAccessKey:(NSString *)accessKey
                                         success:(void (^)(void))success
                                         failure:(void (^)(NSError *error))failure {
    
    NSString* requestUrl = [NSString stringWithFormat:kAccessUrl, accessKey];
    NSDictionary* params;
    if (_apiKey != nil) {
        params = @{@"api_key":_apiKey};
    }
    
    return [self GET:requestUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getUniversesForOrganizationId:(NSString *)organizationId success:(void (^)(NSArray<MWZUniverse*> *universes))success failure:(void (^)(NSError *error))failure {
    if (organizationId == nil || [organizationId isEqualToString:@""]) {
        failure([NSError errorWithDomain:@"An organizationId must be provided" code:401 userInfo:nil]);
        return nil;
    }
    else {
        NSMutableDictionary* params;
        params = [[NSMutableDictionary alloc] init];
        if (_apiKey != nil) {
            [params setObject:_apiKey forKey:@"api_key"];
        }
        [params setObject:organizationId forKey:@"organizationId"];
        return [self GET:kUniversesUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray* responseArray = (NSArray*) responseObject;
            NSMutableArray<MWZUniverse*>* us = [[NSMutableArray alloc] init];
            for (NSDictionary* universeDictionary in responseArray) {
                MWZUniverse* universe = [[MWZUniverse alloc] initFromDictionary:universeDictionary];
                [us addObject:universe];
            }
            success(us);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
}


- (NSURLSessionDataTask *)getVenues:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZVenue*> *venues))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary* params;
    if (options != nil) {
        params = [NSMutableDictionary dictionaryWithDictionary:options];
    }
    else {
        params = [[NSMutableDictionary alloc] init];
    }
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }
    
    return [self GET:kVenuesUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        NSMutableArray<MWZVenue*>* vs = [[NSMutableArray alloc] init];
        for (NSDictionary* venueDictionary in responseArray) {
            MWZVenue* venue = [[MWZVenue alloc] initFromDictionary:venueDictionary];
            [vs addObject:venue];
        }
        success(vs);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getVenuesForOrganizationId:(NSString *)organizationId success:(void (^)(NSArray<MWZVenue*> *venues))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (organizationId != nil) {
        [dic setObject:organizationId forKey:@"organizationId"];
    }
    return [self getVenues:dic success:success failure:failure];
}

- (NSURLSessionDataTask *)getVenueWithId:(NSString *)requestId
                                 success:(void (^)(MWZVenue *venue))success
                                 failure:(void (^)(NSError *error))failure {
    
    
    NSString* requestUrl = [NSString stringWithFormat:kVenueUrl, requestId];
    NSDictionary* params;
    if (_apiKey != nil) {
        params = @{@"api_key":_apiKey};
    }
    
    return [self GET:requestUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* responseDictionary = (NSDictionary*) responseObject;
        MWZVenue* venue = [[MWZVenue alloc] initFromDictionary:responseDictionary];
        success(venue);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getVenueWithParam:(NSString *)param
                                      value:(NSString*) value
                                    success:(void (^)(MWZVenue *venue))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }
    [params setObject:value forKey:param];
    
    return [self GET:kVenuesUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        if (responseArray.count > 0) {
            NSDictionary* venueDictionary = responseArray[0];
            MWZVenue* v = [[MWZVenue alloc] initFromDictionary:venueDictionary];
            success(v);
        }
        else {
            failure([NSError errorWithDomain:@"MapwizeApi" code:404 userInfo:nil]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

    
}

- (NSURLSessionDataTask *)getVenueWithName:(NSString *)name
                                   success:(void (^)(MWZVenue *venue))success
                                   failure:(void (^)(NSError *error))failure {
    
    return [self getVenueWithParam:@"name" value:name success:success failure:failure];
    
}

- (NSURLSessionDataTask *)getVenueWithAlias:(NSString *)alias
                                   success:(void (^)(MWZVenue *venue))success
                                   failure:(void (^)(NSError *error))failure {
    
    return [self getVenueWithParam:@"alias" value:alias success:success failure:failure];
    
}

- (NSURLSessionDataTask *)getPlaces:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZPlace*> *places))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary* params;
    if (options != nil) {
        params = [NSMutableDictionary dictionaryWithDictionary:options];
    }
    else {
        params = [[NSMutableDictionary alloc] init];
    }
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }

    return [self GET:kPlacesUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        NSMutableArray<MWZPlace*>* ps = [[NSMutableArray alloc] init];
        for (NSDictionary* placeDictionary in responseArray) {
            MWZPlace* place = [[MWZPlace alloc] initFromDictionary:placeDictionary];
            [ps addObject:place];
        }
        success(ps);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getPlaceWithId:(NSString *)requestId
                                 success:(void (^)(MWZPlace *venue))success
                                 failure:(void (^)(NSError *error))failure {
    
    NSString* requestUrl = [NSString stringWithFormat:kPlaceUrl, requestId];
    NSDictionary* params;
    if (_apiKey != nil) {
        params = @{@"api_key":_apiKey};
    }
    
    return [self GET:requestUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* responseDictionary = (NSDictionary*) responseObject;
        MWZPlace* place = [[MWZPlace alloc] initFromDictionary:responseDictionary];
        success(place);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getPlaceWithParam:(NSString *)param
                                      value:(NSString*) value
                                    inVenue:(MWZVenue*) venue
                                    success:(void (^)(MWZPlace *place))success
                                    failure:(void (^)(NSError *error))failure {
 
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }
    [params setObject:value forKey:param];
    [params setObject:venue.identifier forKey:@"venueId"];
    
    return [self GET:kPlacesUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        if (responseArray.count > 0) {
            NSDictionary* placeDictionary = responseArray[0];
            MWZPlace* p = [[MWZPlace alloc] initFromDictionary:placeDictionary];
            success(p);
        }
        else {
            failure([NSError errorWithDomain:@"MapwizeApi" code:404 userInfo:nil]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}


- (NSURLSessionDataTask *)getPlaceWithName:(NSString *)name
                                   inVenue:(MWZVenue*) venue
                                   success:(void (^)(MWZPlace *place))success
                                   failure:(void (^)(NSError *error))failure {
    
    return [self getPlaceWithParam:@"name" value:name inVenue:venue success:success failure:failure];
    
}

- (NSURLSessionDataTask *)getPlaceWithAlias:(NSString *)alias
                                   inVenue:(MWZVenue*) venue
                                   success:(void (^)(MWZPlace *place))success
                                   failure:(void (^)(NSError *error))failure {
    
    return [self getPlaceWithParam:@"alias" value:alias inVenue:venue success:success failure:failure];
    
}

- (NSURLSessionDataTask *)getPlacesForVenue:(MWZVenue *)venue
                                withOptions:(NSDictionary*) options
                                    success:(void (^)(NSArray<MWZPlace*>* places))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (options != nil) {
        [params addEntriesFromDictionary:options];
    }
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }
    [params setObject:venue.identifier forKey:@"venueId"];
    
    return [self GET:kPlacesUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        NSMutableArray<MWZPlace*>* ps = [[NSMutableArray alloc] init];
        for (NSDictionary* placeDictionary in responseArray) {
            MWZPlace* place = [[MWZPlace alloc] initFromDictionary:placeDictionary];
            [ps addObject:place];
        }
        success(ps);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getPlaceLists:(NSDictionary<NSString*,NSString*>*) options success:(void (^)(NSArray<MWZPlaceList*> *placeLists))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary* params;
    if (options != nil) {
        params = [NSMutableDictionary dictionaryWithDictionary:options];
    }
    else {
        params = [[NSMutableDictionary alloc] init];
    }
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }
    
    return [self GET:kPlaceListsUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        NSMutableArray<MWZPlaceList*>* pls = [[NSMutableArray alloc] init];
        for (NSDictionary* placeListDictionary in responseArray) {
            MWZPlaceList* placeList = [[MWZPlaceList alloc] initFromDictionary:placeListDictionary];
            [pls addObject:placeList];
        }
        success(pls);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}


- (NSURLSessionDataTask *)getPlacesForPlaceList:(MWZPlaceList *)placeList
                                        success:(void (^)(NSArray<MWZPlace*>* places))success
                                        failure:(void (^)(NSError *error))failure {
    
    NSString* requestUrl = [NSString stringWithFormat:kPlacesForPlaceListUrl, placeList.identifier];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }
    
    return [self GET:requestUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        NSMutableArray<MWZPlace*>* ps = [[NSMutableArray alloc] init];
        for (NSDictionary* placeDictionary in responseArray) {
            MWZPlace* place = [[MWZPlace alloc] initFromDictionary:placeDictionary];
            [ps addObject:place];
        }
        success(ps);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getPlaceListWithId:(NSString *)requestId
                                     success:(void (^)(MWZPlaceList *placeList))success
                                     failure:(void (^)(NSError *error))failure {
 
    NSString* requestUrl = [NSString stringWithFormat:kPlaceListUrl, requestId];
    NSDictionary* params;
    if (_apiKey != nil) {
        params = @{@"api_key":_apiKey};
    }
    
    return [self GET:requestUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* responseDictionary = (NSDictionary*) responseObject;
        MWZPlaceList* placeList = [[MWZPlaceList alloc] initFromDictionary:responseDictionary];
        success(placeList);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

- (NSURLSessionDataTask *)getPlaceListWithParam:(NSString *)param
                                      value:(NSString*) value
                                    inVenue:(MWZVenue*) venue
                                    success:(void (^)(MWZPlaceList *placeList))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }
    [params setObject:value forKey:param];
    [params setObject:venue.identifier forKey:@"venueId"];
    
    return [self GET:kPlaceListsUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        if (responseArray.count > 0) {
            NSDictionary* placeListDictionary = responseArray[0];
            MWZPlaceList* pl = [[MWZPlaceList alloc] initFromDictionary:placeListDictionary];
            success(pl);
        }
        else {
            failure([NSError errorWithDomain:@"MapwizeApi" code:404 userInfo:nil]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}


- (NSURLSessionDataTask *)getPlaceListWithName:(NSString *)name
                                       inVenue:(MWZVenue*) venue
                                       success:(void (^)(MWZPlaceList *placeList))success
                                       failure:(void (^)(NSError *error))failure {
    
    return [self getPlaceListWithParam:@"name" value:name inVenue:venue success:success failure:failure];
    
}

- (NSURLSessionDataTask *)getPlaceListWithAlias:(NSString *)alias
                                       inVenue:(MWZVenue*) venue
                                       success:(void (^)(MWZPlaceList *placeList))success
                                       failure:(void (^)(NSError *error))failure {
    
    return [self getPlaceListWithParam:@"alias" value:alias inVenue:venue success:success failure:failure];
    
}

- (NSURLSessionDataTask *)getPlaceListsForVenue:(MWZVenue *)venue
                                        success:(void (^)(NSArray<MWZPlaceList*>* placeLists))success
                                        failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (_apiKey != nil) {
        [params setObject:_apiKey forKey:@"api_key"];
    }
    [params setObject:venue.identifier forKey:@"venueId"];
    
    return [self GET:kPlaceListsUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* responseArray = (NSArray*) responseObject;
        NSMutableArray<MWZPlaceList*>* ps = [[NSMutableArray alloc] init];
        for (NSDictionary* placeListDictionary in responseArray) {
            MWZPlaceList* placeList = [[MWZPlaceList alloc] initFromDictionary:placeListDictionary];
            [ps addObject:placeList];
        }
        success(ps);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getDirectionsFrom:(id<MWZDirectionPoint>) from
                                         to:(id<MWZDirectionPoint>) to
                                         by: (NSArray<id<MWZDirectionPoint>>*) waypoints
                                withOptions:(MWZDirectionOptions*) options
                                    success:(void (^)(MWZDirection *direction))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSString* requestUrl;
    if (_apiKey != nil) {
        requestUrl = [NSString stringWithFormat:kDirectionsUrl, _apiKey];
    }
    else {
        requestUrl = [NSString stringWithFormat:kDirectionsUrl, @""];
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[options toDictionary] forKey:@"options"];
    
    if (from != nil) {
        [params setObject:[from toDirectionDictionary] forKey:@"from"];
    }
    
    if (to != nil) {
        [params setObject:[to toDirectionDictionary] forKey:@"to"];
    }
    
    if (waypoints != nil) {
        NSMutableArray* waypointsArray = [[NSMutableArray alloc] init];
        for (id<MWZDirectionPoint> point in waypoints) {
            NSDictionary* dic = [point toDirectionDictionary];
            [waypointsArray addObject:dic];
        }
        [params setObject:waypointsArray forKey:@"waypoints"];
    }
    
    return [self POST:requestUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* responseDictionary = (NSDictionary*) responseObject;
        MWZDirection* direction = [[MWZDirection alloc] initFromDictionary:responseDictionary];
        success(direction);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
    
- (NSURLSessionDataTask *)search:(MWZSearchParams*) params
                         success:(void (^)(NSArray<id>*)) success
                         failure:(void (^)(NSError *error))failure {
    
    NSString* requestUrl;
    if (_apiKey != nil) {
        requestUrl = [NSString stringWithFormat:kSearchUrl, _apiKey];
    }
    else {
        requestUrl = [NSString stringWithFormat:kSearchUrl, @""];
    }
    
    return [self POST:requestUrl parameters:[params toDictionary] progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // Success
        NSDictionary* responseDictionary = (NSDictionary*) responseObject;
        NSMutableArray<id>* array = [[NSMutableArray alloc] init];
        if ([responseDictionary objectForKey:@"hits"] != nil) {
            NSArray<NSDictionary*>* hits = [responseDictionary objectForKey:@"hits"];
            for (NSDictionary* hit in hits) {
                id object;
                if ([[hit objectForKey:@"objectClass"] isEqualToString:@"place"]) {
                    object = [[MWZPlace alloc] initFromDictionary:hit];
                }
                else if ([[hit objectForKey:@"objectClass"] isEqualToString:@"venue"]) {
                    object = [[MWZVenue alloc] initFromDictionary:hit];
                }
                else if ([[hit objectForKey:@"objectClass"] isEqualToString:@"placeList"]) {
                    object = [[MWZPlaceList alloc] initFromDictionary:hit];
                }
                [array addObject:object];
            }
        }
        success(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
}

@end
