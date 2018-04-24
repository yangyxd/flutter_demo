#import "UiFlutterPlugin.h"
#import "UIView_Toast.h"


static NSString *const CHANNEL_NAME = @"ui_flutter_plugin";

@implementation UiFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:CHANNEL_NAME // @"ui_flutter_plugin"
            binaryMessenger:[registrar messenger]];

  UIViewController *viewController =
      [UIApplication sharedApplication].delegate.window.rootViewController;
  UiFlutterPlugin* instance = [[UiFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

  // Toast 插件
  if ([@"showToast" isEqualToString:call.method]) {
	toastMethodCall(call, result);
  } else {
    result(FlutterMethodNotImplemented);
  }

  //if ([@"getPlatformVersion" isEqualToString:call.method]) {
  //  result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  //} else {
  //  result(FlutterMethodNotImplemented);
  //}
}

// Toast 插件
-(void)toastMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
	NSString *msg = call.arguments[@"msg"];
	NSString *gravity = call.arguments[@"gravity"];
	NSString *durationTime = call.arguments[@"time"];


	if((durationTime == (id)[NSNull null] || durationTime.length == 0 )) {
		[[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
		  duration: 3
		  position:CSToastPositionBottom];
	} else {
		if([gravity isEqualToString:@"top"]) {
			[[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
				  duration: [durationTime intValue]
				  position:CSToastPositionTop];
		} else if([gravity isEqualToString:@"center"]) {
			[[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
				  duration: [durationTime intValue]
				  position:CSToastPositionCenter];
		} else {
			[[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
				  duration: [durationTime intValue]
				  position:CSToastPositionBottom];
		}
	}

	result(@"done");
}

@end
