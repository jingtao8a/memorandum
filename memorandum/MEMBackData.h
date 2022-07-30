//
//  BackData.h
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import <Foundation/Foundation.h>


@class MEMDataItem;

@interface MEMBackData : NSObject

@property(nonatomic, strong, readonly) NSMutableArray* dataArray;//of MEMDataItem

-(instancetype)initWithFilePath:(NSString *)filePath;

-(void)addObjectOfdataItem:(MEMDataItem *)dataItem;//添加对象
-(void)reviseObjectOfdataItemAtIndex:(MEMDataItem *)dataItem index:(NSInteger)index;//修改对象
-(void)removeObjectOfdataItemAtIndex:(NSInteger)index;//删除对象

-(void)saveToPath:(NSString *)path;//保存文件

@end
