//
//  MyCollectionViewLayout.m
//  memorandum
//
//  Created by yuxintao on 2022/7/26.
//

#import "MyCollectionViewLayout.h"

@interface MyCollectionViewLayout()

@end

@implementation MyCollectionViewLayout

-(instancetype)init{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

@end
