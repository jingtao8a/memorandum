//
//  MEMPresentBigImageOfNoteViewController.m
//  memorandum
//
//  Created by yuxintao on 2022/8/4.
//

#import "MEMPresentBigImageViewController.h"


@interface MEMPresentBigImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bigImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *bigImage;

@end


@implementation MEMPresentBigImageViewController

#pragma mark - initialization

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _bigImage = image;
    }
    return self;
}
#pragma mark - controller lifecycle

- (void)viewDidLoad
{
    //add scrollView to self.view
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    CGFloat widthScale = CGRectGetWidth(self.scrollView.frame) / _bigImage.size.width;
    CGFloat heightScale = CGRectGetHeight(self.scrollView.frame) / _bigImage.size.height;
    _scrollView.minimumZoomScale = MIN(widthScale, heightScale);
    _scrollView.maximumZoomScale = 2;

    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), widthScale * _bigImage.size.height);
    _bigImageView = [[UIImageView alloc] initWithFrame:rect];
    _bigImageView.image = _bigImage;
    _scrollView.contentSize = _bigImageView.frame.size;
    [_scrollView addSubview:_bigImageView];

    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

#pragma mark - UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImageView;
}

@end
