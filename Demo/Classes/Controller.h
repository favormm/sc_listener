#import "SCListener.h"
#import "SoundDetector.h"

@interface Controller : UIViewController
{
    SCListener *listener;
    UIProgressView *averageMeter;
    UIProgressView *peakMeter;
    NSTimer *readingTimer;
    SoundDetector *soundDetector;
    NSNotificationCenter *radio;
    UIView *speakerIcon;
}

@property(retain) SCListener *listener;
@property(retain) SoundDetector *soundDetector;
@property(retain) NSNotificationCenter *radio;

@property(retain) IBOutlet UIProgressView *averageMeter;
@property(retain) IBOutlet UIProgressView *peakMeter;
@property(retain) IBOutlet UIView *speakerIcon;

@end
