#import "MikeTrigger.h"

static const float kReadingInterval = 0.1;

NSString *const kSoundStartedNotification = @"sound started";
NSString *const kSoundEndedNotification = @"sound ended";

@implementation MikeTrigger
@synthesize treshold, listener, radio, overTreshold;

- (id) init
{
    [super init];
    treshold = 0.5;
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
    
    if (level >= treshold && !overTreshold) {
        [radio postNotificationName:kSoundStartedNotification object:self];
        overTreshold = YES;
        return;
    }
    
    if (level < treshold && overTreshold) {
        [radio postNotificationName:kSoundEndedNotification object:self];
        overTreshold = NO;
    }
}

@end
