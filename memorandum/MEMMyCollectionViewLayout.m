//
//  MyCollectionViewLayout.m
//  memorandum
//
//  Created by yuxintao on 2022/7/26.
//

#import "MEMMyCollectionViewLayout.h"

@interface MEMMyCollectionViewLayout ()

@end

@implementation MEMMyCollectionViewLayout

-(instancetype)init{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

@end
