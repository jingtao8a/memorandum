//
//  MEMTextViewControllerDelegate.h
//  memorandum
//
//  Created by yuxintao on 2022/7/30.
//

@class MEMNoteViewController, MEMNote;

@protocol MEMNoteViewControllerDelegate <NSObject>

@required
- (void)noteViewController:(MEMNoteViewController *)sender didFinishEdittingNote:(MEMNote *)note;

@end
