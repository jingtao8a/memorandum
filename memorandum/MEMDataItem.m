//
//  MEMDataItem.m
//  memorandum
//
//  Created by yuxintao on 2022/7/29.
//

#import "MEMDataItem.h"

@interface MEMDataItem()<NSCoding, NSSecureCoding>

@end

@implementation MEMDataItem

#pragma mark -property
-(NSString *)text {
    if (!_text) {
        _text = [[NSString alloc] init];
    }
    return _text;
}

-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

-(NSString *)title {
    if (!_title) {
        _title = [[NSString alloc] init];
    }
    return _title;
}

#pragma mark -NSCoding protocol

//序列化
-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.text forKey:@"text"];
    [coder encodeObject:self.imageArray forKey:@"imageArray"];
    [coder encodeObject:self.title forKey:@"title"];
}

//反序列化
-(instancetype) initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.text = [coder decodeObjectForKey:@"text"];
        self.imageArray = [coder decodeObjectForKey:@"imageArray"];
        self.title = [coder decodeObjectForKey:@"title"];
    }
    return self;
}
#pragma mark -NSSecuring protocol

+(BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark -NSCopying protocol

-(id)copyWithZone:(NSZone *)zone {
    MEMDataItem *copyDataItem = [[MEMDataItem alloc] init];
    copyDataItem.text = self.text;
    copyDataItem.imageArray = [[NSMutableArray alloc] initWithArray:self.imageArray];
    copyDataItem.title = self.title;
    return copyDataItem;
}

@end
