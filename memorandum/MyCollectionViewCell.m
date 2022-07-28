//
//  MyCollectionViewCell.m
//  memorandum
//
//  Created by yuxintao on 2022/7/26.
//

#import "MyCollectionViewCell.h"

@interface MyCollectionViewCell()

@end

@implementation MyCollectionViewCell

-(UIImageView *)image{
    if (!_image) _image = [[UIImageView alloc] init];
    return _image;
}

@end
