//
//  BackData.h
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import <Foundation/Foundation.h>
#import "MEMNote.h"


@interface MEMNoteList : NSObject

@property (nonatomic, strong, readonly) NSArray *indexArray; //of NSString(index)


- (instancetype)init;

- (void)addNote:(MEMNote *)note;                             //添加对象
- (void)updateNote:(MEMNote *)note atIndex:(NSInteger)index; //修改对象
- (void)removeNoteAtIndex:(NSInteger)index;                  //删除对象
- (MEMNote *)getNoteAtIndex:(NSInteger)index;                //获取指定索引的对象

@end
