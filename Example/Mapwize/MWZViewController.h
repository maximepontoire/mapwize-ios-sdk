@import UIKit;
@import Mapwize;
#import "CoreLocation/CoreLocation.h"

@interface MWZViewController : UIViewController <MWZMapDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationButton;
@property (weak, nonatomic) IBOutlet MWZMapView *myMapView;

@end
