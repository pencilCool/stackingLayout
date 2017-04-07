//
//  AFCollectionViewLayoutAttributes.m
//  stackingLayout
//
//  Created by tangyuhua on 2017/4/7.
//  Copyright © 2017年 tangyuhua. All rights reserved.
//

#import "AFCollectionViewLayoutAttributes.h"

@implementation AFCollectionViewLayoutAttributes



-(id)copyWithZone:(NSZone *)zone {
    AFCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.shadowOpacity = self.shadowOpacity;
    attributes.maskingValue = self.maskingValue;
  
    
    return attributes; }




@end
