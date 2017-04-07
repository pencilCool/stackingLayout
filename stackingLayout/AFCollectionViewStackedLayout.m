//
//  AFCollectionViewStackedLayout.m
//  stackingLayout
//
//  Created by tangyuhua on 2017/4/7.
//  Copyright © 2017年 tangyuhua. All rights reserved.
//

#import "AFCollectionViewStackedLayout.h"
#import "AFCollectionViewLayoutAttributes.h"


#define STACK_FOOTER_GAP 12

#define STACK_FOOTER_HEIGHT 12

#define ITEM_SIZE 50

#define VISIBLE_ITEMS_PER_STACK 10

@interface AFCollectionViewStackedLayout ()
@property (nonatomic, assign) NSInteger numberOfStacks;
@property (nonatomic, assign) CGSize pageSize;


@property (nonatomic, assign) UIEdgeInsets stacksInsets;
@property (nonatomic, assign) CGFloat numberOfStacksAcross;
@property (nonatomic, assign) CGFloat minimumInterStackSpacing;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGSize stackSize;
@property (nonatomic, assign) NSInteger numberOfStackRows;
@property (nonatomic, strong) NSMutableArray *stackFrames;


@property (nonatomic, assign) CGSize contentSize;




@end
@implementation AFCollectionViewStackedLayout


- (void)prepareLayout
{
    [super prepareLayout];
    [self prepareStacksLayout];
}


- (void)prepareStacksLayout {
    self.numberOfStacks = [self.collectionView numberOfSections];
    self.pageSize = self.collectionView.bounds.size;
    CGFloat availableWidth =
    self.pageSize.width - (self.stacksInsets.left + self.stacksInsets.right);
    self.numberOfStacksAcross =
    floorf((availableWidth + self.minimumInterStackSpacing) /
           (self.stackSize.width + self.minimumInterStackSpacing));
    CGFloat spacing =
    floorf((availableWidth - (self.numberOfStacksAcross *
                              self.stackSize.width)) / (self.numberOfStacksAcross - 1));
    self.numberOfStackRows =
    ceilf(self.numberOfStacks / (float)self.numberOfStacksAcross);
    self.stackFrames = [NSMutableArray array];
    int stackColumn = 0;
    int stackRow = 0;
    CGFloat left = self.stacksInsets.left; CGFloat top = self.stacksInsets.top;
    for (int stack = 0; stack < self.numberOfStacks; stack++) {
        CGRect stackFrame = (CGRect){{left, top}, self.stackSize}; [self.stackFrames addObject:[NSValue valueWithCGRect:stackFrame]];
        left += self.stackSize.width + spacing; stackColumn += 1;
        if (stackColumn >= self.numberOfStacksAcross) {
            left = self.stacksInsets.left; top +=
            self.stackSize.height + STACK_FOOTER_GAP +
            STACK_FOOTER_HEIGHT + self.minimumLineSpacing;
            stackColumn = 0;
            stackRow += 1;
        } }
    self.contentSize = CGSizeMake(self.pageSize.width,
                                  MAX(self.pageSize.height,
                                      self.stacksInsets.top + (self.numberOfStackRows *
                                                               (self.stackSize.height + STACK_FOOTER_GAP + STACK_FOOTER_HEIGHT)) + ((self.numberOfStackRows - 1) * self.minimumLineSpacing) + self.stacksInsets.bottom));

}

- (UICollectionViewLayoutAttributes
   *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    
        CGRect stackFrame = [self.stackFrames[path.section] CGRectValue];
        AFCollectionViewLayoutAttributes* attributes = [AFCollectionViewLayoutAttributes
                                                        layoutAttributesForCellWithIndexPath:path];
        attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        attributes.center =
        CGPointMake(CGRectGetMidX(stackFrame), CGRectGetMidY(stackFrame));
        CGFloat angle = 0;
        if (path.item == 1) angle = 5;
        else if (path.item == 2) angle = -5;
        attributes.transform3D =
        CATransform3DMakeRotation(angle * M_PI / 180, 0, 0, 1);
        attributes.alpha = path.item >= VISIBLE_ITEMS_PER_STACK? 0 : 1;
        attributes.zIndex =
        path.item >= VISIBLE_ITEMS_PER_STACK ?
        0 : VISIBLE_ITEMS_PER_STACK - path.item;
        attributes.hidden = path.item >= VISIBLE_ITEMS_PER_STACK; attributes.shadowOpacity =
        path.item >= VISIBLE_ITEMS_PER_STACK? 0 : 0.5;
    
    return attributes;
    
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    for (int stack = 0; stack < self.numberOfStacks; stack++) {
        CGRect stackFrame = [self.stackFrames[stack] CGRectValue]; stackFrame.size.height +=
        (STACK_FOOTER_GAP + STACK_FOOTER_HEIGHT);
        if (CGRectIntersectsRect(stackFrame, rect)) {
            NSInteger itemCount = [self.collectionView numberOfItemsInSection:stack];
            for (int item = 0; item < itemCount; item++) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:stack];
                [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            } }
    }
    return attributes;
}


@end
