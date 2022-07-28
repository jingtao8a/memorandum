//
//  BackData.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "BackData.h"

@interface BackData()
//&&&&&&&&&&&&&风格,变量命名不用 _
@property(nonatomic, strong) NSMutableArray* dataArray;//of NSDictionary { @"text" : NSString, @"img", NSMutableArray(of NSStrings)}
@end

@implementation BackData
#pragma mark -property
-(NSMutableArray *)dataArray{
    if (!_dataArray) _dataArray = [[NSMutableArray alloc] init];
    return _dataArray;
}

#pragma mark -operation about dataArray
-(void)setData:(NSMutableArray *)dataArray_tmp {//set dataArray
    self.dataArray = dataArray_tmp;
}

-(void)addText:(NSString *)str Img:(NSMutableArray *)img{//add object to dataArray
    [self.dataArray addObject:@{@"text" : str, @"img" : img}];
}

-(NSDictionary *)chooseIndex:(NSUInteger)index{//choose object in dataArray
    return self.dataArray[index];
}

-(NSInteger)count{//return the count of dataArray
    return [self.dataArray count];
}

-(void)revise:(NSDictionary *)obj Index:(NSInteger)index {//change one object in dataArray
    self.dataArray[index] = obj;
}

-(void)removeObject:(NSInteger)index{//remove one object in dataArray
    [self.dataArray removeObjectAtIndex:index];
}

-(void)saveToPath:(NSString *)path{//save dataArray to file
    [self.dataArray writeToFile:path atomically:YES];
}
@end
