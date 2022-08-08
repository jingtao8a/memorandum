//
//  MEMDataItem.m
//  memorandum
//
//  Created by yuxintao on 2022/7/29.
//

#import "MEMNote.h"


@interface MEMNote () <NSCoding, NSSecureCoding>

@property (nonatomic, strong, readwrite) NSArray *imageArray; //of UIImage

@end


@implementation MEMNote

#pragma mark - property

- (NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

#pragma mark - operation of imageArray

- (void)removeImageAtIndex:(NSUInteger)index
{
    [(NSMutableArray *)self.imageArray removeObjectAtIndex:index];
}

- (void)addImage:(UIImage *)image
{
    [(NSMutableArray *)self.imageArray addObject:image];
}

- (void)removeAllImages
{
    [(NSMutableArray *)self.imageArray removeAllObjects];
}

#pragma mark - NSCoding protocol

//序列化
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.text forKey:@"text"];
    [coder encodeInt:self.numberOfImage forKey:@"numberOfImage"];
    [coder encodeObject:self.title forKey:@"title"];
}

//反序列化
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.text = [coder decodeObjectForKey:@"text"];
        self.numberOfImage = [coder decodeIntForKey:@"numberOfImage"];
        self.title = [coder decodeObjectForKey:@"title"];
    }
    return self;
}

#pragma mark -NSSecuring protocol

+ (BOOL)supportsSecureCoding
{
    return YES;
}


#pragma mark -NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    MEMNote *copyNote = [[MEMNote alloc] init];
    copyNote.text = self.text;
    copyNote.imageArray = [[NSMutableArray alloc] initWithArray:self.imageArray];
    copyNote.title = self.title;
    return copyNote;
}

@end
