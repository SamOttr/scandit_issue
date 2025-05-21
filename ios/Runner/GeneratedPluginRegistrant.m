//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<camera_avfoundation/CameraPlugin.h>)
#import <camera_avfoundation/CameraPlugin.h>
#else
@import camera_avfoundation;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

#if __has_include(<scandit_flutter_datacapture_barcode/ScanditFlutterDataCaptureBarcode.h>)
#import <scandit_flutter_datacapture_barcode/ScanditFlutterDataCaptureBarcode.h>
#else
@import scandit_flutter_datacapture_barcode;
#endif

#if __has_include(<scandit_flutter_datacapture_core/ScanditFlutterDataCaptureCore.h>)
#import <scandit_flutter_datacapture_core/ScanditFlutterDataCaptureCore.h>
#else
@import scandit_flutter_datacapture_core;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CameraPlugin registerWithRegistrar:[registry registrarForPlugin:@"CameraPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [ScanditFlutterDataCaptureBarcode registerWithRegistrar:[registry registrarForPlugin:@"ScanditFlutterDataCaptureBarcode"]];
  [ScanditFlutterDataCaptureCore registerWithRegistrar:[registry registrarForPlugin:@"ScanditFlutterDataCaptureCore"]];
}

@end
