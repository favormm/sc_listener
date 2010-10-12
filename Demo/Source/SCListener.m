//
// SCListener 1.0.1
// http://github.com/stephencelis/sc_listener
//
// (c) 2009-* Stephen Celis, <stephen@stephencelis.com>.
// Released under the MIT License.
//

#import "SCListener.h"

@interface SCListener (Private)

- (void) updateLevels;
- (void) setupQueue;
- (void) setupFormat;
- (void) setupBuffers;
- (void) setupMetering;

@end

static void listeningCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer,
    const AudioTimeStamp *inStartTime, UInt32 inNumberPacketsDescriptions,
    const AudioStreamPacketDescription *inPacketDescs)
{
	SCListener *listener = (id) inUserData;
	if (listener.listening)
		AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

@implementation SCListener

- (void) dealloc
{
	[self stop];
	[super dealloc];
}

- (void) listen
{
	if (queue == nil)
		[self setupQueue];
	AudioQueueStart(queue, NULL);
}

- (void) pause
{
	if (!self.listening)
		return;
	AudioQueueStop(queue, true);
}

- (void) stop
{
	if (queue == nil)
		return;
	AudioQueueDispose(queue, true);
	queue = nil;
}

- (BOOL) listening
{
	if (queue == nil)
		return NO;
	UInt32 isListening, ioDataSize = sizeof(UInt32);
	OSStatus result = AudioQueueGetProperty(queue, kAudioQueueProperty_IsRunning,
        &isListening, &ioDataSize);
	return (result != noErr) ? NO : isListening;
}

#pragma mark Metering

- (float) averagePower
{
    if (!self.listening)
        return -1;
    return [self levels][0].mAveragePower;
}

- (float) peakPower
{
	if (!self.listening)
		return -1;
	return [self levels][0].mPeakPower;
}

- (AudioQueueLevelMeterState*) levels
{
    if (!self.listening)
        return nil;
	[self updateLevels];
	return levels;
}

- (void) updateLevels
{
	UInt32 ioDataSize = format.mChannelsPerFrame * sizeof(AudioQueueLevelMeterState);
	AudioQueueGetProperty(queue, (AudioQueuePropertyID)kAudioQueueProperty_CurrentLevelMeter,
        levels, &ioDataSize);
}

#pragma mark Setup

- (void) setupQueue
{
	if (queue != nil)
		return;
	[self setupFormat];
	[self setupBuffers];
	AudioQueueNewInput(&format, listeningCallback, self, NULL, NULL, 0, &queue);
	[self setupMetering];	
}

- (void) setupFormat
{
#if TARGET_IPHONE_SIMULATOR
	format.mSampleRate = 44100.0;
#else
	UInt32 ioDataSize = sizeof(sampleRate);
	AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &ioDataSize, &sampleRate);
	format.mSampleRate = sampleRate;
#endif
	format.mFormatID = kAudioFormatLinearPCM;
	format.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	format.mFramesPerPacket = format.mChannelsPerFrame = 1;
	format.mBitsPerChannel = 16;
	format.mBytesPerPacket = format.mBytesPerFrame = 2;
}

- (void) setupBuffers
{
	AudioQueueBufferRef buffers[3];
	for (NSInteger i = 0; i < 3; ++i) { 
		AudioQueueAllocateBuffer(queue, 735, &buffers[i]); 
		AudioQueueEnqueueBuffer(queue, buffers[i], 0, NULL); 
	}
}

- (void) setupMetering
{
	levels = (AudioQueueLevelMeterState*) calloc(sizeof(AudioQueueLevelMeterState), format.mChannelsPerFrame);
	UInt32 trueValue = true;
	AudioQueueSetProperty(queue, kAudioQueueProperty_EnableLevelMetering, &trueValue, sizeof(UInt32));
}

@end
