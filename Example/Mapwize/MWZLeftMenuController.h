#import <UIKit/UIKit.h>
#import "MWZViewController.h"

@interface MWZLeftMenuController : UITableViewController <CLLocationManagerDelegate>
@property MWZMapView* mapController;
@property NSArray *menuItems;
@property NSArray *selectors;
@property CLLocationManager* manager;

@end
