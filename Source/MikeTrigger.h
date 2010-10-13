#import "SCListener.h"

extern NSString *const kSoundStartedNotification;
extern NSString *const kSoundEndedNotification;

@interface MikeTrigger : NSObject
{
    SCListener *listener;
    NSTimer *watchTimer;
    float treshold;
    BOOL overTreshold;
    NSNotificationCenter *radio;
}

@property(retain) SCListener *listener;
@property(retain) NSNotificationCenter *radio;

@property(assign) float treshold;
@property(readonly) BOOL watching;
@property(readonly) BOOL overTreshold;

- (void) startWatching;
- (void) stopWatching;

- (void) forceUpdate;

@end
