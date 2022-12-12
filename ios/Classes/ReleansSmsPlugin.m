#import "ReleansSmsPlugin.h"
#if __has_include(<releans_sms/releans_sms-Swift.h>)
#import <releans_sms/releans_sms-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "releans_sms-Swift.h"
#endif

@implementation ReleansSmsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftReleansSmsPlugin registerWithRegistrar:registrar];
}
@end
