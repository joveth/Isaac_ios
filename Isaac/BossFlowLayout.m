//
//  BossFlowLayout.m
//  Isaac
//
//  Created by Shuwei on 15/7/23.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "BossFlowLayout.h"
#define numColumns 2


@implementation BossFlowLayout

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn)
    {
        if (nil == attributes.representedElementKind)
        {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    NSInteger remainder=indexPath.row%numColumns;
    CGFloat positonX=currentItemAttributes.frame.size.width*remainder+8*(remainder+1);
    if (indexPath.item < numColumns){
        CGRect f = currentItemAttributes.frame;
        f.origin.y = 8;
        f.origin.x = positonX;
        currentItemAttributes.frame = f;
        return currentItemAttributes;
    }
    NSIndexPath* ipPrev = [NSIndexPath indexPathForItem:indexPath.item-numColumns inSection:indexPath.section];
    CGRect fPrev = [self layoutAttributesForItemAtIndexPath:ipPrev].frame;
    CGFloat YPointNew = fPrev.origin.y + fPrev.size.height + 8;
    CGRect f = currentItemAttributes.frame;
    f.origin.y = YPointNew;
    f.origin.x = positonX;
    currentItemAttributes.frame = f;
    return currentItemAttributes;
}

@end
