
#include <sys/types.h>
#import <SpringBoard/SpringBoard.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIAlertController.h>

@protocol SBSettingsWindowMethods
- (BOOL)respondsToSelector:(SEL)selector;
- (id)applicationWithBundleIdentifier:(id)bundle;
- (void)animateLaunchApplication:(id)app;
- (void)activateApplicationAnimated:(id)app;
@end

@interface SBIconController : UIViewController

@end

@interface SBUIController : NSObject
@property (nonatomic) SBIconController *iconController;
+ (id)sharedInstance;

- (BOOL)respondsToSelector:(SEL)selector;
- (void)animateLaunchApplication:(id)app;
- (void)activateApplicationAnimated:(id)app;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)bundle;
@end

@interface SBIconView : UIView
@property(nullable, nonatomic,copy) NSArray *gestureRecognizers;
@property(nonatomic,copy) NSString *applicationBundleIdentifierForShortcuts;

- (void)launchApp;

@end


@interface UIView(findvc)
-(UIViewController*)findViewController;
@end

@implementation UIView(find)
-(UIViewController*)findViewController
{
    UIResponder* target= self;
    while (target) {
        target = target.nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return (UIViewController*)target;
}
@end


%hook SpringBoard
- (void)_menuButtonDown:(id)down
{
	%orig;
	
}
%end

%hook SBIconView

- (void)didMoveToWindow{
	%log;
	%orig;  
}

- (void)touchesEnded:(id)arg1 withEvent:(id)arg2 {
	%log;
	%orig;
}

static BOOL isShowAlert = NO;

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {
	%log;
	%orig;
	
}

- (void)touchesCancelled:(id)arg1 withEvent:(id)arg2 {
	%log;
	%orig;
}

- (void)touchesMoved:(id)arg1 withEvent:(id)arg2 {
	%log;
	%orig;
}

- (void)tapGestureDidChange:(id)ges
{	%log(@"点击状态改变");
	%orig;
}

%new
- (void)launchApp {
	Class SBApplicationController = objc_getClass("SBApplicationController");
	id <SBSettingsWindowMethods> appController = [SBApplicationController sharedInstance];
	id app = [appController applicationWithBundleIdentifier:self.applicationBundleIdentifierForShortcuts];
	Class SBUIController = objc_getClass("SBUIController");
    id <SBSettingsWindowMethods> uiController = [SBUIController sharedInstance];
	%log(@"获取到App数==%@",app);
	if (app) {
		if([uiController respondsToSelector:@selector(animateLaunchApplication:)])
		{
			%log(@"uiController==animateLaunchApplication");
		[	uiController animateLaunchApplication:app];
		}
		else
		{
			%log(@"uiController==activateApplicationAnimated");
			[uiController activateApplicationAnimated:app];
		}
	}
	
}

%end

%hook SBUIController



- (void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(id)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
	%log;
	__block int clickCount = 0;
	UIViewController *vc = self.iconController;
	UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"机主是谁？" message:@"请选择机主" preferredStyle:(UIAlertControllerStyleAlert)];
	UIAlertAction *user1 = [UIAlertAction actionWithTitle:@"彭于晏" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
		clickCount++;
		if (clickCount >= 3) {
			// 执行ges
			%log(@"执行原方法");
			%orig;
			return;
		}
		%log(@"点击选项");
		[vc presentViewController:alertVc animated:YES completion:nil];
		isShowAlert = YES;
    }];
	UIAlertAction *user2 = [UIAlertAction actionWithTitle:@"吴彦祖" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
		clickCount++;
		if (clickCount >= 3) {
			// 执行ges
			%log(@"执行原方法");
			%orig;
			return;
		}
		%log(@"点击选项");
		[vc presentViewController:alertVc animated:YES completion:nil];
		isShowAlert = YES;
    }];
    UIAlertAction *user3 = [UIAlertAction actionWithTitle:@"无名氏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
	}];

	[alertVc addAction:user1];
	[alertVc addAction:user2];
	[alertVc addAction:user3];
	[vc presentViewController:alertVc animated:YES completion:nil];
	isShowAlert = YES;
	%log(@"弹窗");
}

%end
