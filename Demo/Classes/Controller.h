#import "SCListener.h"
#import "MikeTrigger.h"

@interface Controller : UIViewController
{
    SCListener *listener;
    UIProgressView *averageMeter;
    UIProgressView *peakMeter;
    NSTimer *readingTimer;
    MikeTrigger *soundDetector;
    NSNotificationCenter *radio;
}

@property(retain) SCListener *listener;
@property(retain) MikeTrigger *soundDetector;
@property(retain) NSNotificationCenter *radio;

@property(retain) IBOutlet UIProgressView *averageMeter;
@property(retain) IBOutlet UIProgressView *peakMeter;

@end
