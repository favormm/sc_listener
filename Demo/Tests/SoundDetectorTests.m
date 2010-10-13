#import <SenTestingKit/SenTestingKit.h>
#import "SoundDetector.h"
#import "MockListener.h"

@interface SoundDetectorTests : SenTestCase
{
    SoundDetector *detector;
    MockListener *listener;
    NSNotificationCenter *radio;
    BOOL soundRunning;
    BOOL receivedNotification;
}

@end

@implementation SoundDetectorTests

#pragma mark Setup

- (void) setUp
{
    [super setUp];
    detector = [[SoundDetector alloc] init];
    listener = [[MockListener alloc] init];
    radio = [[NSNotificationCenter alloc] init];
    [detector setListener:(id)listener];
    [detector setRadio:radio];
    [detector setTreshold:0.5];
    
    [radio addObserver:self selector:@selector(didCrossTresholdUp)
        name:kSoundDidStartNotification object:detector];
    [radio addObserver:self selector:@selector(didCrossTresholdDown)
        name:kSoundDidStopNotification object:detector];
}

- (void) tearDown
{
    [radio removeObserver:self];
    [radio release];
    [listener release];
    [detector release];
    [super tearDown];
}

#pragma mark Notification Support

- (void) didCrossTresholdUp
{
    receivedNotification = YES;
    soundRunning = YES;
}

- (void) didCrossTresholdDown
{
    receivedNotification = YES;
    soundRunning = NO;
}

#pragma mark Tests

- (void) testInitialTreshold
{
    STAssertFalse(detector.soundRunning, @"Sound not running initially.");
}

- (void) testTresholdUp
{
    [listener setPower:0.7];
    [detector setMinPauseDuration:0];
    [detector forceUpdate];
    STAssertTrue(receivedNotification && soundRunning,
        @"Send notification when sound starts.");

    receivedNotification = NO;
    [listener setPower:0.2];
    [detector forceUpdate];
    STAssertTrue(receivedNotification && !soundRunning,
        @"Send notification when sound stops.");
}

- (void) testRepeatedOverstep
{
    [listener setPower:0.7];
    [detector forceUpdate];
    receivedNotification = NO;
    [listener setPower:0.9];
    [detector forceUpdate];
    STAssertFalse(receivedNotification,
        @"Do not send resend the notification.");
}

@end
