//
//  MEMNoteViewCustomTextField.m
//  memorandum
//
//  Created by yuxintao on 2022/8/4.
//

#import "MEMNoteViewCustomTextField.h"


@interface MEMNoteViewCustomTextField ()

@end


@implementation MEMNoteViewCustomTextField

#pragma mark - initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor underPageBackgroundColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.placeholder = @"请输入标题";
    }
    return self;
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
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.bounds) / 2 + 15, CGRectGetWidth(self.bounds), 0.5));
}

#pragma mark - UIControl

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"textField touchesBegan");
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"textField touchesMoved");
    [super touchesMoved:touches withEvent:event];
    [self.nextResponder touchesMoved:touches withEvent:event];
}

@end
