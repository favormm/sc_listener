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

- (void) listen;
- (void) pause;
- (void) stop;

- (float) averagePower;
- (float) peakPower;
- (AudioQueueLevelMeterState*) levels;

@end
