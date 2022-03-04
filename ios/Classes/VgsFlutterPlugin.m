#import "VgsFlutterPlugin.h"
#if __has_include(<vgs_flutter/vgs_flutter-Swift.h>)
#import <vgs_flutter/vgs_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vgs_flutter-Swift.h"
#endif

@implementation VgsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVgsFlutterPlugin registerWithRegistrar:registrar];
}
@end
