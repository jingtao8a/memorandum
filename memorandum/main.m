//
//  main.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import <UIKit/UIKit.h>
#import "MEMAppDelegate.h"

int main(int argc, char *argv[])
{
    NSString *appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([MEMAppDelegate class]);
    }

    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}


/*
 x 1.ui + 自动布局bug
 x 2.图片放大跳转（动画还未加)
 x 3.save功能修改
 x 4.键盘遮挡bug
 x 5.图片存储
 x 6.命名
 */
