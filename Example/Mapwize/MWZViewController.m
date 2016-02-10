//
//  MWZViewController.m
//  Mapwize
//
//  Created by Mathieu Gerard on 02/05/2016.
//  Copyright (c) 2016 Mathieu Gerard. All rights reserved.
//

#import "MWZViewController.h"
@import Mapwize;

@interface MWZViewController ()

@end

@implementation MWZViewController

MWZMapView* map;

- (void)viewDidLoad
{
    [super viewDidLoad];
    map = (MWZMapView*)[self view];
    
    MWZMapOptions* options = [[MWZMapOptions alloc] init];
    options.apiKey = @"1f04d780dc30b774c0c10f53e3c7d4ea"; // PASTE YOU API KEY HERE !!! This is a demo key. It is not allowed to use it for production. The key might change at any time without notice.
    
    // You can also use the following options
    //    options.maxBounds = [[MWZLatLonBounds alloc] initWithNorthEast:[[MWZLatLon alloc] initWithLatitude:50.68079714532166 longitude:-4.74609375] southWest:[[MWZLatLon alloc] initWithLatitude:42.16340342422401 longitude:8.61328125]];
    //    options.center = [[MWZLatLon alloc] initWithLatitude:50.63313102137516 longitude:3.020006418228149];
    //    options.zoom = @(19);
    //    options.floor = @(2);
    
    map.delegate = self;
    [map loadMapWithOptions:(MWZMapOptions *) options];
    
    //[map access:@"YOUR_ACCESS_KEY"];
    [map fitBounds:[[MWZLatLonBounds alloc] initWithNorthEast:[[MWZLatLon alloc] initWithLatitude:50.634002069243123856 longitude:3.0215620994567871094] southWest:[[MWZLatLon alloc] initWithLatitude:50.632362036014932016 longitude:3.0191266536712646484]]];
    [map setFloor:@(2)];

}

- (void) map:(MWZMapView*) map didClick:(MWZLatLon*) latlon {
    NSLog(@"didClick %@", latlon);
}

- (void) map:(MWZMapView*) map didClickOnPlace:(NSDictionary*) place {
    NSLog(@"didClickOnPlace %@", place);
}

- (void) map:(MWZMapView*) map didChangeFloor:(NSNumber*) floor {
    NSLog(@"didChangeFloor %@", floor);
}

- (void) map:(MWZMapView*) map didChangeFloors:(NSArray*) floors {
    NSLog(@"didChangeFloors %@", floors);
}

- (void) map:(MWZMapView*) map didFailWithError: (NSError *)error {
    NSLog(@"didFailWithError %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
