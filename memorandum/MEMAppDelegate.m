//
//  AppDelegate.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "MEMAppDelegate.h"
#import "MEMNoteListViewController.h"
#import "MEMNoteViewController.h"


@interface MEMAppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) UISplitViewController *splitViewController;
@property (nonatomic, assign) BOOL shouldRemoveAddTitle;
@property (nonatomic, assign) BOOL shouldPushSecondaryController;
@end


@implementation MEMAppDelegate

@synthesize window = _window;

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //应用程序启动
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    MEMNoteListViewController *noteListViewController = [[MEMNoteListViewController alloc] init];
    UINavigationController *primaryNavigationController = [[UINavigationController alloc] initWithRootViewController:noteListViewController];


    MEMNoteViewController *secondaryNoteViewController = [[MEMNoteViewController alloc] init];
    secondaryNoteViewController.delegate = noteListViewController;
    [noteListViewController setIndexPathRow:[noteListViewController.noteList.indexArray count]];

    self.shouldPushSecondaryController = YES;
    if ([noteListViewController.noteList.indexArray count]) {
        self.shouldPushSecondaryController = NO;
    }

    _splitViewController = [[UISplitViewController alloc] init];
    _splitViewController.delegate = self;
    _splitViewController.viewControllers = @[ primaryNavigationController, secondaryNoteViewController ];

    self.window.rootViewController = _splitViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //应用程序要退出
    NSLog(@"terminate");
}

#pragma mark - UISplitViewController delegate

//调用之前，将secondarycontroller移出viewcontrollers，若secondarycontroller为nil，则不会调用该代理method
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    NSLog(@"push controller");
    //恢复add标题
    MEMNoteListViewController *noteListViewController = (MEMNoteListViewController *)[[(UINavigationController *)primaryViewController viewControllers] firstObject];
    noteListViewController.rightBarButton.title = @"add";
    self.shouldRemoveAddTitle = YES;
    if (self.shouldPushSecondaryController) {
        [(UINavigationController *)primaryViewController pushViewController:secondaryViewController animated:YES];
    }
    self.shouldPushSecondaryController = YES;
    return YES;
}

//调用之后，将secondarycontroller加入viewcontrollers
- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController
{
    NSLog(@"pop controller");
    NSLog(@"pr%d", [[(UINavigationController *)primaryViewController viewControllers] count]);
    MEMNoteListViewController *noteListViewController = (MEMNoteListViewController *)[[(UINavigationController *)primaryViewController viewControllers] firstObject];
    //删除add标题
    if (self.shouldRemoveAddTitle) {
        noteListViewController.rightBarButton.title = @"";
        self.shouldRemoveAddTitle = NO;
    }

    return nil;
}

@end
