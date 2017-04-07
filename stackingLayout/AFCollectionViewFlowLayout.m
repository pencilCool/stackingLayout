//
//  AFCollectionViewFlowLayout.m
//  stackingLayout
//
//  Created by tangyuhua on 2017/4/7.
//  Copyright © 2017年 tangyuhua. All rights reserved.
//

#import "AFCollectionViewFlowLayout.h"

@implementation AFCollectionViewFlowLayout


-(id)init {
    if (!(self = [super init])) return nil;
    self.itemSize = CGSizeMake(200, 200);
    self.sectionInset = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f); self.minimumInteritemSpacing = 13.0f;
    self.minimumLineSpacing = 13.0f;
    return self; }

@end
