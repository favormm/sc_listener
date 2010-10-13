@class Controller;

@interface Application : NSObject <UIApplicationDelegate>
{
    Controller *controller;
    UIWindow *window;
}

@property(retain) IBOutlet UIWindow *window;

@end

