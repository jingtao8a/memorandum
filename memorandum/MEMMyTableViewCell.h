//
//  MEMMyTableViewCell.h
//  memorandum
//
//  Created by yuxintao on 2022/7/30.
//

#import <UIKit/UIKit.h>

@class MEMDataItem;

@interface MEMMyTableViewCell : UITableViewCell

-(void)configWithDataItem:(MEMDataItem *)dataItem;

@end
