//
//  MEMNoteViewCustomTextView.m
//  memorandum
//
//  Created by yuxintao on 2022/8/4.
//

#import "MEMNoteViewCustomTextView.h"


@interface MEMNoteViewCustomTextView ()

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end


@implementation MEMNoteViewCustomTextView

#pragma mark - initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor underPageBackgroundColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.bounces = NO;
        self.textColor = [UIColor blackColor];
        self.font = [UIFont fontWithName:@"Arial" size:18.0];
        self.placeholder = @"请输入文本";
        self.placeholderColor = [UIColor grayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textHasChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

#pragma mark - notification

- (void)textHasChanged:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

#pragma mark - property

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect
{
    if ([self.text length]) {
        return;
    }
    NSDictionary *attributes = @{
        NSFontAttributeName : self.font,
        NSForegroundColorAttributeName : self.placeholderColor
    };
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;

    [self.placeholder drawInRect:rect withAttributes:attributes];
}

#pragma mark - UIControl

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"textView touchesBegan");
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"textView touchsMoved");
    [super touchesMoved:touches withEvent:event];
    [self.nextResponder touchesMoved:touches withEvent:event];
}

@end
