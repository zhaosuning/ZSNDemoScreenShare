//
//  AppDelegate.m
//  ZSNDemoScreenShare
//
//  Created by zhaosuning on 2023/5/17.
//

#import "AppDelegate.h"
#import "ZSNFirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ZSNFirstViewController *vc = [[ZSNFirstViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    return YES;
}




@end
