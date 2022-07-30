//
//  MEMTextViewControllerDelegate.h
//  memorandum
//
//  Created by yuxintao on 2022/7/30.
//

@class MEMDataItem, NSIndexPath, MEMTextViewController;

@protocol MEMTextViewControllerDelegate <NSObject>

@required
-(void)textViewController:(MEMTextViewController *)sender dataItem:(MEMDataItem *)dataItem indexPath:(NSIndexPath *)indexPath;

@end
