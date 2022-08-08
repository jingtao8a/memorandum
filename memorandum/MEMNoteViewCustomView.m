//
//  MEMNoteViewCustomView.m
//  memorandum
//
//  Created by yuxintao on 2022/8/4.
//

#import "MEMNoteViewCustomView.h"


@interface MEMNoteViewCustomView ()


@end


@implementation MEMNoteViewCustomView

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor underPageBackgroundColor];
    }
    return self;
}

#pragma mark - UIControl
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"view touchesMoved");
    [super touchesMoved:touches withEvent:event];
    [self.nextResponder touchesMoved:touches withEvent:event];
}

@end
