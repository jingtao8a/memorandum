//
//  BackData.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "MEMBackData.h"
#import "MEMDataItem.h"
#import <UIKit/UIKit.h>

@interface MEMBackData ()///<NSCoding, NSSecureCoding>

@property(nonatomic, strong, readwrite) NSMutableArray* dataArray;//of MEMDataItem

@end

@implementation MEMBackData

#pragma mark -init

-(instancetype)initWithFilePath:(NSString *)filePath {
    self = [super init];
    NSLog(@"FILEPATH:%@", filePath);
    self.dataArray = [[NSMutableArray alloc] init];
    if (self) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSLog(@"file exist\n");
            NSMutableArray *tmpDataArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
            //反序列化
            for (NSData *tmpData in tmpDataArray) {
                NSError *error = nil;
                MEMDataItem *tmpMEMDataItem = [NSKeyedUnarchiver unarchiveObjectWithData:tmpData];
                if (error) {
                    NSLog(@"unarchivedObjectOfClass：%@\n", [error localizedDescription]);
                } else {
                    [self.dataArray addObject:tmpMEMDataItem];
                }
            }
        } else {
            NSLog(@"empty file\n");
        }
    }
    return self;
}

#pragma mark -operation about dataArray

-(void)addObjectOfdataItem:(MEMDataItem *)dataItem {//add object to dataArray
    [self.dataArray addObject:dataItem];
}

-(void)reviseObjectOfdataItemAtIndex:(MEMDataItem *)dataItem index:(NSInteger)index {//change one object in dataArray
    [self.dataArray replaceObjectAtIndex:index withObject:dataItem];
}

-(void)removeObjectOfdataItemAtIndex:(NSInteger)index{//remove one object in dataArray
    [self.dataArray removeObjectAtIndex:index];
}

-(void)saveToPath:(NSString *)path{//save dataArray to file
    NSUInteger n = [self.dataArray count];
    for (NSUInteger index = 0; index < n; ++index) {
        NSError *error = nil;
        MEMDataItem *tmpDataItem = [self.dataArray objectAtIndex:index];
        //序列化
        NSData* tmpData = [NSKeyedArchiver archivedDataWithRootObject:tmpDataItem requiringSecureCoding:YES error:&error];
        if (error) {
            NSLog(@"archivedDataWithRootObject:%@\n", [error localizedDescription]);
        } else {
            [self.dataArray replaceObjectAtIndex:index withObject:tmpData];
        }
    }
    [self.dataArray writeToFile:path atomically:YES];
    NSLog(@"write to file\n");
}
/*
#pragma mark -NSCoding
//序列化
-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.dataArray forKey:@"dataArray"];
}

//反序列化
-(instancetype) initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.dataArray = [coder decodeObjectForKey:@"dataArray"];
    }
    return self;
}

#pragma mark -NSSecureCoding

+(BOOL)supportsSecureCoding {
    return YES;
}
*/
@end
