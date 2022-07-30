//
//  AppDelegate.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "AppDelegate.h"
#import "MEMTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;

#pragma mark -AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //应用程序启动
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    MEMTableViewController *myTableViewController = [[MEMTableViewController alloc] init];
    [navigationController pushViewController:myTableViewController animated:YES];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application {
    // 应用程序即将进入后台
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    //应用程序已经进入后台
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    //应用程序即将进入前台
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    // 应用程序已经进入前台
}

-(void)applicationWillTerminate:(UIApplication *)application {
    //应用程序要退出
    NSLog(@"terminate");
}



@end
