#import "Controller.h"

@implementation Controller
@synthesize listener, averageMeter, peakMeter;

- (void) dealloc
{
    [listener release];
    [super dealloc];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    [averageMeter setProgress:0];
    [peakMeter setProgress:0];
    [listener listen];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [listener stop];
    [super viewWillDisappear:animated];
}

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

@end
