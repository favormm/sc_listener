#import <SenTestingKit/SenTestingKit.h>
#import "MikeTrigger.h"
#import "MockListener.h"

@interface MikeTriggerTests : SenTestCase
{
    MikeTrigger *trigger;
    MockListener *listener;
    NSNotificationCenter *radio;
    BOOL overTreshold;
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
    overTreshold = YES;
}

- (void) didCrossTresholdDown
{
    receivedNotification = YES;
    overTreshold = NO;
}

#pragma mark Tests

- (void) testInitialTreshold
{
    STAssertFalse(trigger.overTreshold, @"Not over treshold initially.");
}

- (void) testTresholdUp
{
    [listener setPower:0.7];
    [trigger forceUpdate];
    STAssertTrue(receivedNotification && overTreshold,
        @"Send notification when crossing up the treshold.");

    receivedNotification = NO;
    [listener setPower:0.2];
    [trigger forceUpdate];
    STAssertTrue(receivedNotification && !overTreshold,
        @"Send notification when crossing down the treshold.");
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
