//
//  MyCollectionViewCell.m
//  memorandum
//
//  Created by yuxintao on 2022/7/26.
//

#import "MEMNoteViewCollectionViewCell.h"


@interface MEMNoteViewCollectionViewCell ()

@end


@implementation MEMNoteViewCollectionViewCell

- (UIImageView *)imageOfNoteView
{
    if (!_imageOfNoteView) {
        _imageOfNoteView = [[UIImageView alloc] init];
    }
    return _imageOfNoteView;
}

@end
