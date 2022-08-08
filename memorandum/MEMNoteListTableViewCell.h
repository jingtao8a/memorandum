//
//  MEMMyTableViewCell.h
//  memorandum
//
//  Created by yuxintao on 2022/7/30.
//

#import <UIKit/UIKit.h>
#import "MEMNote.h"


@interface MEMNoteListTableViewCell : UITableViewCell

- (void)configWithNote:(MEMNote *)note;

@end
