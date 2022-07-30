//
//  MEMMyTableViewCell.m
//  memorandum
//
//  Created by yuxintao on 2022/7/30.
//

#import "MEMMyTableViewCell.h"
#import "MEMDataItem.h"

@interface MEMMyTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *myImageView;

@end


@implementation MEMMyTableViewCell

#pragma mark -property
-(UIImageView *)myImageView {
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
        _myImageView.backgroundColor = [UIColor whiteColor];
    }
    return _myImageView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}

#pragma mark -init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellHeight = [UIScreen mainScreen].bounds.size.height / 10;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

        //add self.title to self.contentView
        CGRect rect = CGRectMake(0, 0, 0.5 * screenWidth, 0.4 * cellHeight);
        self.titleLabel.frame = rect;
        [self addSubview:self.titleLabel];
        
        //add self.content to self.contentView
        rect = CGRectMake(0, 0.4 * cellHeight, 0.6 * screenWidth, 0.6 * cellHeight);
        self.contentLabel.frame = rect;
        [self addSubview:self.contentLabel];
        
        //add self.myImageView to self.contentView
        rect = CGRectMake(0.5 * screenWidth, 0, 0.2 * screenWidth, cellHeight);
        self.myImageView.frame = rect;
        [self addSubview:self.myImageView];
    }
    return self;
}

-(void)configWithDataItem:(MEMDataItem *)dataItem {
    self.titleLabel.text = [@"TITLE: " stringByAppendingString: dataItem.title];
    self.contentLabel.text = [@"TEXT: " stringByAppendingString: dataItem.text];
    if ([dataItem.imageArray count]) {
        self.myImageView.image = [dataItem.imageArray objectAtIndex:0];
    } else {
        self.myImageView.image = nil;
    }
}

@end
