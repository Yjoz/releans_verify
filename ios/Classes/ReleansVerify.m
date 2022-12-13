#import "ReleansVerify.h"
#if __has_include(<releans_verify/releans_verify-Swift.h>)
#import <releans_verify/releans_verify-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "releans_verify-Swift.h"
#endif

@implementation ReleansVerify
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftReleansVerifyPlugin registerWithRegistrar:registrar];
}
@end
