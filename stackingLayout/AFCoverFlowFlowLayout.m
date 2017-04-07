//
//  AFCoverFlowFlowLayout.m
//  stackingLayout
//
//  Created by tangyuhua on 2017/4/7.
//  Copyright © 2017年 tangyuhua. All rights reserved.
//

#import "AFCoverFlowFlowLayout.h"
#import "AFCollectionViewLayoutAttributes.h"


#define ACTIVE_DISTANCE 100
#define TRANSLATE_DISTANCE 100
#define ZOOM_FACTOR 0.2f
#define FLOW_OFFSET 40
#define INACTIVE_GREY_VALUE 0.6f


@implementation AFCoverFlowFlowLayout




-(id)init {
    if (!(self = [super init])) return nil;
    // Set up our basic properties
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal; self.itemSize = CGSizeMake(180, 180);
    // Gets items up close to one another self.minimumLineSpacing = -60;
    // Makes sure we only have 1 row of items in portrait mode
    
    self.minimumInteritemSpacing = 200;
    return self;
}
+(Class)layoutAttributesClass {
    return [AFCollectionViewLayoutAttributes class];
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    // Very important — needed to re-layout the cells when scrolling.
    return YES;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    // We're going to calculate the rect of the collection view visisble to the user.
    CGRect visibleRect = CGRectMake( self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    for (UICollectionViewLayoutAttributes* attributes in layoutAttributesArray) {
        // We're going to calculate the rect of the collection
        // view visible to the user.
        // That way, we can avoid laying out cells that are not visible.
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            [self applyLayoutAttributes:attributes forVisibleRect:visibleRect]; }
    }
    return layoutAttributesArray; }
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    // We're going to calculate the rect of the collection view visible // to the user.
    CGRect visibleRect = CGRectMake(
                                    self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    [self applyLayoutAttributes:attributes forVisibleRect:visibleRect];
    return attributes;
}



-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes forVisibleRect:(CGRect)visibleRect
{
    // Applies the cover flow effect to the given layout attributes.
    // We want to skip supplementary views.
    if (attributes.representedElementKind) return;
    // Calculate the distance from the center of the visible rect to the // center of the attributes. Then normalize it so we can compare them // all. This way, all items further away than the active get the same
    // transform.
    CGFloat distanceFromVisibleRectToItem =
    CGRectGetMidX(visibleRect) - attributes.center.x;
    CGFloat normalizedDistance = distanceFromVisibleRectToItem / ACTIVE_DISTANCE;
    // Handy for use in making a number negative selectively
    BOOL isLeft = distanceFromVisibleRectToItem > 0;
    // Default values
    CATransform3D transform = CATransform3DIdentity; CGFloat maskAlpha = 0.0f;
    if (fabsf(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE) {
        // We're close enough to apply the transform in relation to // how far away from the center we are.
        transform = CATransform3DTranslate( CATransform3DIdentity,
                                           (isLeft? - FLOW_OFFSET : FLOW_OFFSET)*
                                           ABS(distanceFromVisibleRectToItem/TRANSLATE_DISTANCE), 0,
                                           (1 - fabsf(normalizedDistance)) * 40000 + (isLeft? 200 : 0));
        // Set the perspective of the transform. transform.m34 = -1/(4.6777f * self.itemSize.width);
        // Set the zoom factor.
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance)); transform = CATransform3DRotate(transform,
                                                                                                      (isLeft? 1 : -1) * fabsf(normalizedDistance) * 45 * M_PI / 180,
                                                                                                      0,
                                                                                                      1,
                                                                                                      0);
        transform = CATransform3DScale(transform, zoom, zoom, 1); attributes.zIndex = 1;
        CGFloat ratioToCenter = (ACTIVE_DISTANCE - fabsf(distanceFromVisibleRectToItem)) / ACTIVE_DISTANCE;
        // Interpolate between 0.0f and INACTIVE_GREY_VALUE
        maskAlpha = INACTIVE_GREY_VALUE + ratioToCenter *(-INACTIVE_GREY_VALUE);}
    
    else {
        // We're too far away - just apply a standard // perspective transform.
        transform.m34 = -1/(4.6777 * self.itemSize.width); transform = CATransform3DTranslate(transform,
                                                                                              isLeft? -FLOW_OFFSET : FLOW_OFFSET, 0, 0); transform = CATransform3DRotate(transform, (
                                                                                                                                                                                     isLeft? 1 : -1) * 45 * M_PI / 180, 0, 1, 0); attributes.zIndex = 0;
        maskAlpha = INACTIVE_GREY_VALUE; }
    attributes.transform3D = transform;
    // Rasterize the cells for smoother edges.
    [(AFCollectionViewLayoutAttributes *)attributes
setShouldRasterize:YES];
    [(AFCollectionViewLayoutAttributes *)attributes
                          setMaskingValue:maskAlpha];
}

@end
