@interface MockListener : NSObject
{
    float averagePower;
    float peakPower;
}

@property(assign) float averagePower;
@property(assign) float peakPower;

- (void) setPower: (float) power;

- (void) listen;
- (void) stop;

@end
