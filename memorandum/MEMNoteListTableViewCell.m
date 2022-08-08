//
//  MEMMyTableViewCell.m
//  memorandum
//
//  Created by yuxintao on 2022/7/30.
//

#import "MEMNoteListTableViewCell.h"


@interface MEMNoteListTableViewCell ()

@property (nonatomic, strong) UILabel *titleOfThisNoteLabel;
@property (nonatomic, strong) UILabel *contentOfThisNoteLabel;
@property (nonatomic, strong) UIImageView *firstImageOfThisNoteView;

@end


@implementation MEMNoteListTableViewCell

#pragma mark -property
- (UIImageView *)firstImageOfThisNoteView
{
    if (!_firstImageOfThisNoteView) {
        _firstImageOfThisNoteView = [[UIImageView alloc] init];
        _firstImageOfThisNoteView.backgroundColor = [UIColor underPageBackgroundColor];
        _firstImageOfThisNoteView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _firstImageOfThisNoteView;
}

- (UILabel *)titleOfThisNoteLabel
{
    if (!_titleOfThisNoteLabel) {
        _titleOfThisNoteLabel = [[UILabel alloc] init];
        _titleOfThisNoteLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleOfThisNoteLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:24];
    }
    return _titleOfThisNoteLabel;
}

- (UILabel *)contentOfThisNoteLabel
{
    if (!_contentOfThisNoteLabel) {
        _contentOfThisNoteLabel = [[UILabel alloc] init];
        _contentOfThisNoteLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _contentOfThisNoteLabel.font = [UIFont fontWithName:@"Arial" size:16];
    }
    return _contentOfThisNoteLabel;
}

#pragma mark - init

- (void)prepareForReuse
{
    [super prepareForReuse];
    //clear
    self.titleOfThisNoteLabel.text = nil;
    self.contentOfThisNoteLabel.text = nil;
    self.firstImageOfThisNoteView.image = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor underPageBackgroundColor];
        //add self.title to self.contentView
        [self.contentView addSubview:self.titleOfThisNoteLabel];
        //add self.content to self.contentView
        [self.contentView addSubview:self.contentOfThisNoteLabel];

        //add self.myImageView to self.contentView
        [self.contentView addSubview:self.firstImageOfThisNoteView];

        [NSLayoutConstraint activateConstraints:@[
            [self.titleOfThisNoteLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:2.5],
            [self.titleOfThisNoteLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
            [self.titleOfThisNoteLabel.heightAnchor constraintEqualToConstant:30],
            [self.titleOfThisNoteLabel.trailingAnchor constraintEqualToAnchor:self.firstImageOfThisNoteView.leadingAnchor constant:-10],
            [self.contentOfThisNoteLabel.topAnchor constraintEqualToAnchor:self.titleOfThisNoteLabel.bottomAnchor constant:5],
            [self.contentOfThisNoteLabel.leadingAnchor constraintEqualToAnchor:self.titleOfThisNoteLabel.leadingAnchor],
            [self.contentOfThisNoteLabel.heightAnchor constraintEqualToConstant:30],
            [self.contentOfThisNoteLabel.trailingAnchor constraintEqualToAnchor:self.firstImageOfThisNoteView.leadingAnchor constant:-10],
            [self.firstImageOfThisNoteView.heightAnchor constraintEqualToConstant:65],
            [self.firstImageOfThisNoteView.widthAnchor constraintEqualToConstant:65],
            [self.firstImageOfThisNoteView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:250],
            [self.firstImageOfThisNoteView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:2.5]
        ]];
    }
    return self;
}

- (void)configWithNote:(MEMNote *)note
{
    if (note.title) {
        self.titleOfThisNoteLabel.text = [note.title length] ? [@"标题:" stringByAppendingString:note.title] : @"";
    } else {
        self.titleOfThisNoteLabel.text = @"";
    }
    self.contentOfThisNoteLabel.text = note.text ?: @"";
    if ([note.imageArray count]) {
        self.firstImageOfThisNoteView.image = [note.imageArray objectAtIndex:0];
    } else {
        self.firstImageOfThisNoteView.image = nil;
    }
}

@end
