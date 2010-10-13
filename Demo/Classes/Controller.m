#import "Controller.h"

@implementation Controller
@synthesize listener, averageMeter, peakMeter, soundDetector, radio;

- (void) dealloc
{
    [radio release];
    [soundDetector release];
    [listener release];
    [super dealloc];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    
    // Reset UI.
    [averageMeter setProgress:0];
    [peakMeter setProgress:0];
    
    // Start receiving the sound events.
    [listener listen];
    [soundDetector startWatching];
    
    // Watch for sound events.
    [radio addObserver:self selector:@selector(soundDidStart)
        name:kSoundDidStartNotification object:soundDetector];
    [radio addObserver:self selector:@selector(soundDidStop)
        name:kSoundDidStopNotification object:soundDetector];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [radio removeObserver:self];
    [soundDetector stopWatching];
    [listener stop];
    [super viewWillDisappear:animated];
}

#pragma mark Metering

- (void) viewDidAppear: (BOOL) animated
{
    readingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
        selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

- (void) updateMeters
{
    [averageMeter setProgress:[listener averagePower]];
    [peakMeter setProgress:[listener peakPower]];
}

#pragma mark Sound Events

- (void) soundDidStart {
    NSLog(@"Sound started.");
}

- (void) soundDidStop {
    NSLog(@"Sound stopped.");
}

@end
