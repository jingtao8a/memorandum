//
//  MEMDataItem.h
//  memorandum
//
//  Created by yuxintao on 2022/7/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MEMNote : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, readonly) NSArray *imageArray; //of UIImage
@property (nonatomic, assign) int numberOfImage;

- (void)removeImageAtIndex:(NSUInteger)index;
- (void)addImage:(UIImage *)image;
- (void)removeAllImages;

@end
