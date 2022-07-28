//
//  DetailViewController.h
//  memorandum
//
//  Created by yuxintao on 2022/7/25.
//

#import <UIKit/UIKit.h>
#import "BackData.h"

@interface DetailViewController : UIViewController

@property(nonatomic, strong) BackData* backData;
@property(nonatomic, strong) NSIndexPath *indexPath;

@end
