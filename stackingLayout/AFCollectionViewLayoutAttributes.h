//
//  AFCollectionViewLayoutAttributes.h
//  stackingLayout
//
//  Created by tangyuhua on 2017/4/7.
//  Copyright © 2017年 tangyuhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic ,assign) CGFloat shadowOpacity;
@property (nonatomic ,assign) CGFloat maskingValue;


@property (nonatomic, assign) BOOL shouldRasterize;
@end
