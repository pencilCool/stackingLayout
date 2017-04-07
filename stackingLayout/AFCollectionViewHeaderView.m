//
//  AFCollectionViewHeaderView.m
//  stackingLayout
//
//  Created by tangyuhua on 2017/4/7.
//  Copyright © 2017年 tangyuhua. All rights reserved.
//

#import "AFCollectionViewHeaderView.h"
@interface AFCollectionViewHeaderView ()
@property (nonatomic, strong) UILabel *label;
@end
@implementation AFCollectionViewHeaderView


- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    self.backgroundColor = [UIColor orangeColor];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                           CGRectGetWidth(frame),
                                                           CGRectGetHeight(frame))]; self.label.autoresizingMask =
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    return self; }


-(void)setText:(NSString *)text
{
    self.label.text = text;
}

@end
