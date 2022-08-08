//
//  MyTableViewController.h
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import <UIKit/UIKit.h>
#import "MEMNoteList.h"


@interface MEMNoteListViewController : UIViewController

@property (nonatomic, strong, readonly) UIBarButtonItem *rightBarButton;
@property (nonatomic, strong, readonly) MEMNoteList *noteList;

- (void)setIndexPathRow:(NSInteger)indexPathRow;
@end
