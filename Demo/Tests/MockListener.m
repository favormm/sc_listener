#import "MockListener.h"

@implementation MockListener
@synthesize averagePower, peakPower;

- (void) listen {}
- (void) stop {}

- (void) setPower: (float) power
{
    averagePower = peakPower = power;
}

@end
