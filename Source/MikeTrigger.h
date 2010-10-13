#import "SCListener.h"

extern NSString *const kSoundStartedNotification;
extern NSString *const kSoundEndedNotification;

@interface MikeTrigger : NSObject
{
    SCListener *listener;
    NSTimer *watchTimer;
    float treshold;
    BOOL soundRunning;
    NSNotificationCenter *radio;
    CFAbsoluteTime pauseStartTime;
    double minPauseDuration;
    NSUInteger state;
}

@property(retain) SCListener *listener;
@property(retain) NSNotificationCenter *radio;

@property(assign) float treshold;
@property(assign) double minPauseDuration;

@property(readonly) BOOL watching;
@property(readonly) BOOL soundRunning;

- (void) startWatching;
- (void) stopWatching;

- (void) forceUpdate;

@end
