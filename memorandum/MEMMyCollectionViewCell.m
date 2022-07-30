//
//  MyCollectionViewCell.m
//  memorandum
//
//  Created by yuxintao on 2022/7/26.
//

#import "MEMMyCollectionViewCell.h"

@interface MEMMyCollectionViewCell ()

@end

@implementation MEMMyCollectionViewCell

-(UIImageView *)image{
    if (!_image) _image = [[UIImageView alloc] init];
    return _image;
}

@end
