#import <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>
#import "SIOSocket.h"
#import "FDDrone.h"


#import <JavaScriptCore/JavaScriptCore.h>
#ifdef __IPHONE_8_0
#import <WebKit/WebKit.h>
#endif
@interface SIOSocket (FDPrivate)
@property (readonly) JSContext *javascriptContext;
@end
