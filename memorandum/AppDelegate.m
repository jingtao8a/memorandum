//
//  AppDelegate.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "AppDelegate.h"
#import "MyTableViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) UIWindow *window;

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
    MyTableViewController *myTableViewController = [[MyTableViewController alloc] init];
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


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"memorandum"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
