//
//  CarouselCollectionViewFlowLayout.swift
//  Hiro
//
//  Created by Jonathan Long on 9/25/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
extension CGFloat {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}

class CarouselCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let item_size : CGFloat = 450.0
    let active_distance = 200
    let zoom_factor = 0.2
    let padding : CGFloat = 20
    let max_angle : CGFloat = 80
    let perspective : CGFloat = 1.0 / -400
    
    var layoutCache = [UICollectionViewLayoutAttributes]()
    
    var orientation : UIInterfaceOrientation = .Portrait
    
    override func prepareLayout() {
        super.prepareLayout()
        self.initLayoutProperties()
    }
    
    func initLayoutProperties(){
        orientation = UIApplication.sharedApplication().statusBarOrientation
        itemSize = CGSizeMake(item_size, CGFloat((9/16) * item_size))
        if UIInterfaceOrientationIsPortrait(orientation){
            scrollDirection = .Vertical
            sectionInset = UIEdgeInsetsMake(0, 200, 0, 200)
        } else {
            scrollDirection = .Horizontal
            sectionInset = UIEdgeInsetsMake(200, 0, 200, 0)
        }
        
        minimumLineSpacing = padding
        minimumInteritemSpacing = padding
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("layout attributes for elements in rect")
        if let layoutArray : Array<UICollectionViewLayoutAttributes> = super.layoutAttributesForElementsInRect(rect) {
            layoutCache = layoutArray
            let visibleRect = CGRectMake((collectionView?.contentOffset.x)!, (collectionView?.contentOffset.y)!, (collectionView?.bounds.size.width)!, (collectionView?.bounds.size.height)!)
            for attributes in layoutArray {
                if CGRectIntersectsRect(attributes.frame, rect) {
                    
//                    let d = UIInterfaceOrientationIsPortrait(orientation) ? CGRectGetMidY(visibleRect) - attributes.center.y : CGRectGetMidX(visibleRect) - attributes.center.x
//                    let width = visibleRect.size.width
//
//                    let height = visibleRect.size.height
                    
//                    let dRatio = UIInterfaceOrientationIsPortrait(orientation) ? d / (width / CGFloat(2)) : d / (height / CGFloat(2));
                    
//                    let angle = max_angle * dRatio
//                    let radians = angle.degreesToRadians
//                    var rotationAndPerspectiveTransform = CATransform3DIdentity;
//                    rotationAndPerspectiveTransform.m34 = perspective;
//                    
//                    rotationAndPerspectiveTransform = /*UIInterfaceOrientationIsPortrait(orientation) ? CATransform3DRotate(rotationAndPerspectiveTransform, radians, 1.0, 0.0, 0.0) : */CATransform3DRotate(rotationAndPerspectiveTransform, radians, 0.0, 1.0, 0.0);
//                    
//                    attributes.transform3D = rotationAndPerspectiveTransform;
                    
                    
                }
            }
            return layoutArray
        }
        
        return nil
    }
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        print("itemIndexPath: \(itemIndexPath)")
        return layoutCache[itemIndexPath.row]
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
/*


/*
Scale based on position on screen

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {

NSArray* array = [super layoutAttributesForElementsInRect:rect];
CGRect visibleRect;
visibleRect.origin = self.collectionView.contentOffset;
visibleRect.size = self.collectionView.bounds.size;

for(UICollectionViewLayoutAttributes* attributes in array) {

if(CGRectIntersectsRect(attributes.frame, rect)){

CGFloat distance = CGRectGetMidX(visibleRect)-attributes.center.x;
CGFloat normalizedDistance = distance/ACTIVE_DISTANCE;

if(ABS(distance)<ACTIVE_DISTANCE){

CGFloat zoom = 1+ZOOM_FACTOR*(1-ABS(normalizedDistance));
attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
attributes.zIndex = round(zoom);
}
}
}

return array;
}
*/

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {

CGFloat offsetAdjustment = MAXFLOAT;
CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds)/2.0);
CGFloat verticalCenter = proposedContentOffset.y + (CGRectGetHeight(self.collectionView.bounds)/2.0);

CGRect targetRectHorizontal = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
CGRect targetRectVertical = CGRectMake(0.0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);

NSArray *array  = UIInterfaceOrientationIsPortrait(_orientation)?
[super layoutAttributesForElementsInRect:targetRectVertical] :
[super layoutAttributesForElementsInRect:targetRectHorizontal];

for(UICollectionViewLayoutAttributes* layoutAttributes in array) {

CGFloat itemHorizontalCenter = layoutAttributes.center.x;
CGFloat itemVerticalCenter = layoutAttributes.center.y;

if(UIInterfaceOrientationIsPortrait(_orientation)){

if(ABS(itemVerticalCenter-verticalCenter) < ABS(offsetAdjustment)){
offsetAdjustment = itemVerticalCenter-verticalCenter;
}
}else{

if(ABS(itemHorizontalCenter-horizontalCenter) < ABS(offsetAdjustment)){
offsetAdjustment = itemHorizontalCenter-horizontalCenter;
}
}

}

return UIInterfaceOrientationIsPortrait(_orientation)?
CGPointMake(proposedContentOffset.x, proposedContentOffset.y+offsetAdjustment) :
CGPointMake(proposedContentOffset.x+offsetAdjustment, proposedContentOffset.y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

return YES;
}
@end*/