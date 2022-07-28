//
//  BackData.h
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import <Foundation/Foundation.h>

@interface BackData : NSObject

-(void)setData:(NSMutableArray *)dataArray_tmp;
-(void)addText:(NSString *)str Img:(NSMutableArray *)img;//添加对象
//&&&&&&&&&&&&&
-(NSString *)chooseIndex:(NSUInteger)index;//选择指定对象
-(NSInteger)count;//返回对象个数
-(void)revise:(NSDictionary *)obj Index:(NSInteger)index;//修改对象
-(void)removeObject:(NSInteger)index;//删除对象
-(void)saveToPath:(NSString *)path;//保存文件

@end
