#import <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>
#import <libARController/ARCONTROLLER_Device.h>


#pragma mark - interface
@interface FDDrone : NSObject {
}


#pragma mark - properties
@property (nonatomic) ARCONTROLLER_Device_t *deviceController;
@property (nonatomic, assign) uint8_t batteryLevel;
@property (nonatomic) dispatch_semaphore_t stateSem;


#pragma mark - class method
+ (FDDrone *)sharedInstance;


#pragma mark - public api
/**
 * connect drone
 * @param service ARService
 * @return success or failure BOOL
 **/
- (BOOL)connectWithService:(ARService *)service;

/**
 * disconnect drone
 **/
- (void)disconnect;

- (void)emergency;
- (void)takeoff;
- (void)land;

- (void)startGazUp;
- (void)stopGazUp;
- (void)startGazDown;
- (void)stopGazDown;
- (void)startYawLeft;
- (void)stopYawLeft;
- (void)startYawRight;
- (void)stopYawRight;
- (void)startRollLeft;
- (void)stopRollLeft;
- (void)startRollRight;
- (void)stopRollRight;
- (void)startPitchForward;
- (void)stopPitchForward;
- (void)startPitchBack;
- (void)stopPitchBack;


@end
