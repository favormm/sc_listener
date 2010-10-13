#import "MikeTrigger.h"

enum {
    kStateSoundOff,
    kStateSoundOn,
    kStateSoundEnding
};

static const float kReadingInterval = 0.1;

NSString *const kSoundStartedNotification = @"sound started";
NSString *const kSoundEndedNotification = @"sound ended";

@implementation MikeTrigger
@synthesize treshold, listener, radio, minPauseDuration, soundRunning;

- (id) init
{
    [super init];
    treshold = 0.5;
    minPauseDuration = 0.2;
    return self;
}

- (void) dealloc
{
    [radio release];
    [listener release];
    [super dealloc];
}

- (BOOL) watching
{
    return (watchTimer != nil);
}

- (void) startWatching
{
    if (self.watching)
        return;
    [listener listen];
    state = kStateSoundOff;
    soundRunning = NO;
    watchTimer = [NSTimer scheduledTimerWithTimeInterval:kReadingInterval target:self
        selector:@selector(forceUpdate) userInfo:nil repeats:YES];
}

- (void) stopWatching
{
    [watchTimer invalidate], watchTimer = nil;
}

- (void) forceUpdate
{
    const float level = [listener averagePower];
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    
    switch (state) {
        case kStateSoundOff:
            if (level < treshold)
                break;
            soundRunning = YES;
            state = kStateSoundOn;
            [radio postNotificationName:kSoundStartedNotification object:self];
            break;
        case kStateSoundOn:
            if (level >= treshold)
                break;
            state = kStateSoundEnding;
            pauseStartTime = now;
            // Fall through to turn off immediately if minPauseDuration == 0.
        case kStateSoundEnding:
            if (level >= treshold) {
                state = kStateSoundOn;
                break;
            }
            if (now - pauseStartTime >= minPauseDuration) {
                state = kStateSoundOff;
                soundRunning = NO;
                [radio postNotificationName:kSoundEndedNotification object:self];
            }
            break;
    }
}

@end
