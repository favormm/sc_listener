#import "Application.h"
#import "SCListener.h"
#import "SoundDetector.h"
#import "Controller.h"

@implementation Application
@synthesize window;

- (void) setupObjectGraph
{
    SCListener *listener = [[SCListener alloc] init];

    SoundDetector *detector = [[SoundDetector alloc] init];
    [detector setListener:listener];
    [detector setRadio:[NSNotificationCenter defaultCenter]];
    [detector setTreshold:0.1];
    [detector setMinPauseDuration:1.0];
    
    controller = [[Controller alloc] initWithNibName:@"Controller" bundle:nil];
    [controller setListener:listener];
    [controller setSoundDetector:detector];
    [controller setRadio:[NSNotificationCenter defaultCenter]];
    
    [listener release];
    [detector release];
}

- (void) applicationDidFinishLaunching: (UIApplication*) application
{
    [self setupObjectGraph];
    [window addSubview:controller.view];
    [window makeKeyAndVisible];
}

- (void) dealloc
{
    [controller release];
    [window release];
    [super dealloc];
}

@end
