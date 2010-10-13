#import <SenTestingKit/SenTestingKit.h>
#import "MikeTrigger.h"
#import "MockListener.h"

@interface MikeTriggerTests : SenTestCase
{
    MikeTrigger *trigger;
    MockListener *listener;
    NSNotificationCenter *radio;
    BOOL soundRunning;
    BOOL receivedNotification;
}

@end

@implementation MikeTriggerTests

#pragma mark Setup

- (void) setUp
{
    [super setUp];
    trigger = [[MikeTrigger alloc] init];
    listener = [[MockListener alloc] init];
    radio = [[NSNotificationCenter alloc] init];
    [trigger setListener:(id)listener];
    [trigger setRadio:radio];
    [trigger setTreshold:0.5];
    
    [radio addObserver:self selector:@selector(didCrossTresholdUp)
        name:kSoundStartedNotification object:trigger];
    [radio addObserver:self selector:@selector(didCrossTresholdDown)
        name:kSoundEndedNotification object:trigger];
}

- (void) tearDown
{
    [radio removeObserver:self];
    [radio release];
    [listener release];
    [trigger release];
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
    STAssertFalse(trigger.soundRunning, @"Sound not running initially.");
}

- (void) testTresholdUp
{
    [listener setPower:0.7];
    [trigger setMinPauseDuration:0];
    [trigger forceUpdate];
    STAssertTrue(receivedNotification && soundRunning,
        @"Send notification when sound starts.");

    receivedNotification = NO;
    [listener setPower:0.2];
    [trigger forceUpdate];
    STAssertTrue(receivedNotification && !soundRunning,
        @"Send notification when sound stops.");
}

- (void) testRepeatedOverstep
{
    [listener setPower:0.7];
    [trigger forceUpdate];
    receivedNotification = NO;
    [listener setPower:0.9];
    [trigger forceUpdate];
    STAssertFalse(receivedNotification,
        @"Do not send resend the notification.");
}

@end
