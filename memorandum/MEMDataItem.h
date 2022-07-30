//
//  MEMDataItem.h
//  memorandum
//
//  Created by yuxintao on 2022/7/29.
//

#import <Foundation/Foundation.h>

@interface MEMDataItem : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSMutableArray *imageArray; //of UIImage
@property (nonatomic, copy) NSString *title;

@end
