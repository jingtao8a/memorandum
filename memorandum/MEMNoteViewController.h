//
//  TextViewController.h
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//
#import <UIKit/UIKit.h>
#import "MEMNote.h"
#import "MEMNoteViewControllerDelegate.h"

typedef NS_ENUM(NSInteger, MEMNoteViewControllerCategory) {
    MEMNoteViewControllerCategoryAdd,
    MEMNoteViewControllerCategoryDetail
};


@interface MEMNoteViewController : UIViewController

@property (nonatomic, assign, readonly) MEMNoteViewControllerCategory noteViewControllerCategory;
@property (nonatomic, weak) id<MEMNoteViewControllerDelegate> delegate;

- (instancetype)init;
- (instancetype)initWithNote:(MEMNote *)note;

- (void)setNote:(MEMNote *)note;
- (void)setNoteViewControllerCategory:(MEMNoteViewControllerCategory)noteViewControllerCategory;

@end
