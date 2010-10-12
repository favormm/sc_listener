#import "Controller.h"

@interface Application : NSObject <UIApplicationDelegate>
{
    Controller *controller;
    UIWindow *window;
}

@property(retain) IBOutlet UIWindow *window;
@property(retain) IBOutlet Controller *controller;

@end

