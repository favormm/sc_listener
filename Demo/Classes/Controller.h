#import "SCListener.h"

@interface Controller : UIViewController
{
    SCListener *listener;
    UIProgressView *averageMeter;
    UIProgressView *peakMeter;
    NSTimer *readingTimer;
}

@property(retain) IBOutlet SCListener *listener;
@property(retain) IBOutlet UIProgressView *averageMeter;
@property(retain) IBOutlet UIProgressView *peakMeter;

@end
