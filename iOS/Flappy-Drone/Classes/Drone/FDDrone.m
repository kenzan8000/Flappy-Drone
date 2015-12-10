#import "FDDrone.h"
#import <libARDiscovery/ARDiscovery.h>
#import <libARController/ARController.h>


#pragma mark - functions
void stateChanged(eARCONTROLLER_DEVICE_STATE newState, eARCONTROLLER_ERROR error, void *customData)
{
    FDDrone *drone = (__bridge FDDrone *)customData;
    if (drone == nil) { return; }

    switch (newState) {
        case ARCONTROLLER_DEVICE_STATE_RUNNING:
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPED:
            dispatch_semaphore_signal(drone.stateSem);
            //dispatch_async(dispatch_get_main_queue(), ^{
            //});
            break;
        case ARCONTROLLER_DEVICE_STATE_STARTING:
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPING:
            break;
        default:
            break;
    }
}

void onCommandReceived (eARCONTROLLER_DICTIONARY_KEY commandKey, ARCONTROLLER_DICTIONARY_ELEMENT_t *elementDictionary, void *customData)
{
    FDDrone *drone = (__bridge FDDrone *)customData;
    if (drone == nil) { return; }

    if ((commandKey == ARCONTROLLER_DICTIONARY_KEY_COMMON_COMMONSTATE_BATTERYSTATECHANGED) && (elementDictionary != NULL)) {
        ARCONTROLLER_DICTIONARY_ARG_t *arg = NULL;
        ARCONTROLLER_DICTIONARY_ELEMENT_t *element = NULL;

        HASH_FIND_STR (elementDictionary, ARCONTROLLER_DICTIONARY_SINGLE_KEY, element);
        if (element != NULL) {
            HASH_FIND_STR (element->arguments, ARCONTROLLER_DICTIONARY_KEY_COMMON_COMMONSTATE_BATTERYSTATECHANGED_PERCENT, arg);
            if (arg != NULL) { [drone setBatteryLevel:arg->value.U8]; }
        }
    }
}


#pragma mark - implementation
@implementation FDDrone


#pragma mark - class method
+ (FDDrone *)sharedInstance
{
    static FDDrone *drone  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        drone = [[FDDrone alloc] init];
    });
    return drone;
}


#pragma mark - initializer


#pragma mark - destruction
- (void)dealloc
{
}


#pragma mark - public api
- (BOOL)connectWithService:(ARService *)service
{
    self.batteryLevel = 100;
    self.stateSem = dispatch_semaphore_create(0);

    ARDISCOVERY_Device_t *discoveryDevice = [self createDiscoveryDeviceWithService:service];
    if (discoveryDevice != NULL) {
        eARCONTROLLER_ERROR error = ARCONTROLLER_OK;
        self.deviceController = ARCONTROLLER_Device_New(discoveryDevice, &error);

        if (error == ARCONTROLLER_OK) {
            error = ARCONTROLLER_Device_AddStateChangedCallback(_deviceController, stateChanged, (__bridge void *)(self));
        }
        if (error == ARCONTROLLER_OK) {
            error = ARCONTROLLER_Device_AddCommandReceivedCallback(_deviceController, onCommandReceived, (__bridge void *)(self));
        }
        if (error == ARCONTROLLER_OK) {
            error = ARCONTROLLER_Device_Start(_deviceController);
        }

        ARDISCOVERY_Device_Delete (&discoveryDevice);
        if (error != ARCONTROLLER_OK) {
            if (_deviceController != NULL) { ARCONTROLLER_Device_Delete(&_deviceController); }
            self.deviceController = NULL;
            return FALSE;
        }
    }
    else { return FALSE; }
    return TRUE;
}

- (void)disconnect
{
    eARCONTROLLER_ERROR error = ARCONTROLLER_OK;
    eARCONTROLLER_DEVICE_STATE state = ARCONTROLLER_Device_GetState(_deviceController, &error);
    if ((error == ARCONTROLLER_OK) && (state != ARCONTROLLER_DEVICE_STATE_STOPPED)) {
        error = ARCONTROLLER_Device_Stop(_deviceController);
        if (error == ARCONTROLLER_OK) { dispatch_semaphore_wait(self.stateSem, DISPATCH_TIME_FOREVER); }
    }
    if (_deviceController != NULL) { ARCONTROLLER_Device_Delete(&_deviceController); }
    self.deviceController = NULL;
}

- (void)emergency
{
    _deviceController->miniDrone->sendPilotingEmergency(_deviceController->miniDrone);
}

- (void)takeoff
{
    _deviceController->miniDrone->sendPilotingTakeOff(_deviceController->miniDrone);
}

- (void)land
{
    _deviceController->miniDrone->sendPilotingLanding(_deviceController->miniDrone);
}

- (void)startGazUp
{
    _deviceController->miniDrone->setPilotingPCMDGaz(_deviceController->miniDrone, 50);
}

- (void)stopGazUp
{
    _deviceController->miniDrone->setPilotingPCMDGaz(_deviceController->miniDrone, 0);
}

- (void)startGazDown
{
    _deviceController->miniDrone->setPilotingPCMDGaz(_deviceController->miniDrone, -50);
}

- (void)stopGazDown
{
    _deviceController->miniDrone->setPilotingPCMDGaz(_deviceController->miniDrone, 0);
}

- (void)startYawLeft
{
    _deviceController->miniDrone->setPilotingPCMDYaw(_deviceController->miniDrone, -50);
}

- (void)stopYawLeft
{
    _deviceController->miniDrone->setPilotingPCMDYaw(_deviceController->miniDrone, 0);
}

- (void)startYawRight
{
    _deviceController->miniDrone->setPilotingPCMDYaw(_deviceController->miniDrone, 50);
}

- (void)stopYawRight
{
    _deviceController->miniDrone->setPilotingPCMDYaw(_deviceController->miniDrone, 0);
}

- (void)startRollLeft
{
    _deviceController->miniDrone->setPilotingPCMDFlag(_deviceController->miniDrone, 1);
    _deviceController->miniDrone->setPilotingPCMDRoll(_deviceController->miniDrone, -50);
}

- (void)stopRollLeft
{
    _deviceController->miniDrone->setPilotingPCMDFlag(_deviceController->miniDrone, 0);
    _deviceController->miniDrone->setPilotingPCMDRoll(_deviceController->miniDrone, 0);
}

- (void)startRollRight
{
    _deviceController->miniDrone->setPilotingPCMDFlag(_deviceController->miniDrone, 1);
    _deviceController->miniDrone->setPilotingPCMDRoll(_deviceController->miniDrone, 50);
}

- (void)stopRollRight
{
    _deviceController->miniDrone->setPilotingPCMDFlag(_deviceController->miniDrone, 0);
    _deviceController->miniDrone->setPilotingPCMDRoll(_deviceController->miniDrone, 0);
}

- (void)startPitchForward
{
    _deviceController->miniDrone->setPilotingPCMDFlag(_deviceController->miniDrone, 1);
    _deviceController->miniDrone->setPilotingPCMDPitch(_deviceController->miniDrone, 50);
}

- (void)stopPitchForward
{
    _deviceController->miniDrone->setPilotingPCMDFlag(_deviceController->miniDrone, 0);
    _deviceController->miniDrone->setPilotingPCMDPitch(_deviceController->miniDrone, 0);
}

- (void)startPitchBack
{
    _deviceController->miniDrone->setPilotingPCMDFlag(_deviceController->miniDrone, 1);
    _deviceController->miniDrone->setPilotingPCMDPitch(_deviceController->miniDrone, -50);
}

- (void)stopPitchBack
{
    _deviceController->miniDrone->setPilotingPCMDFlag(_deviceController->miniDrone, 0);
    _deviceController->miniDrone->setPilotingPCMDPitch(_deviceController->miniDrone, 0);
}


#pragma mark - private api
/**
 * create drone device
 * @param service ARService
 * @return drone device
 **/
- (ARDISCOVERY_Device_t *)createDiscoveryDeviceWithService:(ARService *)service
{
    ARDISCOVERY_Device_t *device = NULL;
    eARDISCOVERY_ERROR errorDiscovery = ARDISCOVERY_OK;
    device = ARDISCOVERY_Device_New (&errorDiscovery);
    if (errorDiscovery == ARDISCOVERY_OK) {
        ARBLEService *bleService = service.service;
        errorDiscovery = ARDISCOVERY_Device_InitBLE (device, ARDISCOVERY_PRODUCT_MINIDRONE, (__bridge ARNETWORKAL_BLEDeviceManager_t)(bleService.centralManager), (__bridge ARNETWORKAL_BLEDevice_t)(bleService.peripheral));
    }
    return device;
}


@end
