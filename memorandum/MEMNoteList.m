//
//  BackData.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "MEMNoteList.h"
#import <UIKit/UIKit.h>


@interface MEMNoteList ()

@property (nonatomic, strong, readwrite) NSArray *indexArray;      //of NSString(dataFilePath)
@property (nonatomic, copy) NSString *indexFilePath;               //indexfilePath route
@property (nonatomic, strong) NSMutableSet *hashSetOfdataFilePath; //of NSString

@end


@implementation MEMNoteList

#pragma mark - save to disk

- (void)saveIndexFile
{
    [self.indexArray writeToFile:self.indexFilePath atomically:YES];
    NSLog(@"save indexFile\n");
}

- (void)writeNote:(MEMNote *)note toDataFilePath:(NSString *)dataFilePath
{
    NSError *error = nil;
    note.numberOfImage = [note.imageArray count]; //保存图片数量
    //序列化
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:note requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"archivedDataWithRootObject error\n");
    } else {
        [data writeToFile:dataFilePath atomically:YES];
    }
    NSString *newPath = [dataFilePath substringToIndex:[dataFilePath length] - 6];
    BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (ret) {
        NSLog(@"create file folder success");
    } else {
        NSLog(@"crreat file folder error");
    }
    for (int i = 0; i < note.numberOfImage; ++i) {
        NSString *imagePath = [newPath stringByAppendingFormat:@"/image%d.png", i];
        [UIImagePNGRepresentation([note.imageArray objectAtIndex:i]) writeToFile:imagePath atomically:YES];
    }
    NSLog(@"writeDataItem toDataFilePath");
}


#pragma mark - getPath

- (NSString *)getPathWithFileName:(NSString *)fileName
{
    if (!fileName) {
        NSLog(@"fileName is nil");
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *indexFilePath = [documentPath stringByAppendingString:fileName];
    return indexFilePath;
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _indexFilePath = [self getPathWithFileName:@"/index.plist"];
        _hashSetOfdataFilePath = [[NSMutableSet alloc] init];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_indexFilePath]) {
            NSLog(@"file exist\n");
            _indexArray = [[NSMutableArray alloc] initWithContentsOfFile:_indexFilePath];
            for (NSString *dataFilePath in _indexArray) {
                [_hashSetOfdataFilePath addObject:dataFilePath];
            }
        } else {
            NSLog(@"empty file\n");
            _indexArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

#pragma mark - operation of DataItem

- (void)addNote:(MEMNote *)note
{
    NSString *dataFilePath = nil;
    do {
        int suffix = 0;
        for (int i = 0; i < 3; ++i) {
            int tmp = arc4random() % 10;
            suffix = suffix * 10 + tmp;
        }
        dataFilePath = [self getPathWithFileName:[NSString stringWithFormat:@"/data%d.plist", suffix]];
    } while ([self.hashSetOfdataFilePath containsObject:dataFilePath]);

    [(NSMutableArray *)self.indexArray addObject:dataFilePath];
    [self.hashSetOfdataFilePath addObject:dataFilePath];

    [self writeNote:note toDataFilePath:dataFilePath];
    [self saveIndexFile];
}

- (void)updateNote:(MEMNote *)note atIndex:(NSInteger)index
{
    NSString *dataFilePath = [self.indexArray objectAtIndex:index];
    [self writeNote:note toDataFilePath:dataFilePath];
    [self saveIndexFile];
}

- (void)removeNoteAtIndex:(NSInteger)index
{
    NSString *dataFilePath = [self.indexArray objectAtIndex:index];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:dataFilePath error:&error];
    if (error) {
        NSLog(@"remove file error\n");
    }
    NSString *newPath = [dataFilePath substringToIndex:[dataFilePath length] - 6];
    [[NSFileManager defaultManager] removeItemAtPath:newPath error:&error];
    if (error) {
        NSLog(@"remove file folder error\n");
    }
    [self.hashSetOfdataFilePath removeObject:dataFilePath];
    [(NSMutableArray *)self.indexArray removeObjectAtIndex:index];
    [self saveIndexFile];
}

- (MEMNote *)getNoteAtIndex:(NSInteger)index
{
    NSString *dataFilePath = [self.indexArray objectAtIndex:index];
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataFilePath];
    //反序列化
    MEMNote *note = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    NSString *newPath = [dataFilePath substringToIndex:[dataFilePath length] - 6];
    for (int i = 0; i < note.numberOfImage; ++i) {
        NSString *imagePath = [newPath stringByAppendingFormat:@"/image%d.png", i];
        [note addImage:[UIImage imageWithContentsOfFile:imagePath]];
    }
    return note;
}

@end
