//
//  TextViewController.h
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//
#import <UIKit/UIKit.h>
#import "MEMBackData.h"

@interface MEMTextViewController : UIViewController

@property (nonatomic, copy, readonly) NSString *addOrDetailString;

-(instancetype)initOfAddViewController:(id)delegate;
-(instancetype)initOfDetailViewController:(id)delegate indexPath:(NSIndexPath *)indexPath dataItem:(MEMDataItem *)dataItem;

@end
