#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioServices.h>

@interface SCListener : NSObject
{
    AudioQueueLevelMeterState *levels;
    AudioStreamBasicDescription format;
    AudioQueueRef queue;
    Float64 sampleRate;
}

@property(readonly) BOOL listening;

// You need to call this before you can read any data.
// Safe to call even if the listener is already running.
- (void) listen;

// Safe to call even when not running.
- (void) pause;

// Safe to call even when not running.
- (void) stop;

// Average mike power, 0–1 including both ends.
// Returns –1 if not currently running.
- (float) averagePower;

// Peak mike power, 0–1 including both ends.
// Returns –1 if not currently running.
- (float) peakPower;

// Returns updated structure with the levels
// for all channels. Not thread safe.
- (AudioQueueLevelMeterState*) levels;

@end
