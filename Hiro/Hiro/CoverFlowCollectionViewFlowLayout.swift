//
//  CoverFlowCollectionViewFlowLayout.swift
//  Hiro
//
//  Created by Jonathan Long on 9/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class CoverFlowCollectionViewFlowLayout: UICollectionViewLayout {
    private var layoutAttributesCache = [UICollectionViewLayoutAttributes]()
    private var totalNumberOfItems : Int {
        var totalNumberOfItems = 0
        var sections = 0
        while (sections < collectionView?.numberOfSections()){
            totalNumberOfItems += collectionView!.numberOfItemsInSection(sections)
            sections++
        }
        
        return totalNumberOfItems
        
    }
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    private var contentHeight: CGFloat {
        return collectionView!.bounds.height
    }
    private let itemOverlap : CGFloat = 0.25
    private let itemsOnScreen = 5
    
    override func prepareLayout() {
        // 1
//        if layoutAttributesCache.isEmpty {
//            // 2
//            let screenWidth = UIScreen.mainScreen().bounds.width
//            let elementHeight = 9 * (screenWidth / 4) / 16
//            let size = CGSizeMake(screenWidth/4, elementHeight)
//            var xPosition : CGFloat = 0.0
//            
//            for section in 0 ..< collectionView!.numberOfSections(){
//                for item in 0 ..< collectionView!.numberOfItemsInSection(section){
//                    let indexPath = NSIndexPath(forItem: item, inSection: section)
//                    let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//                    layoutAttributes.frame = CGRectMake(xPosition, CGFloat(item * 10), size.width, size.height - 10)
//                    layoutAttributes.alpha = CGFloat(item % Int(itemsOnScreen)) / CGFloat(itemsOnScreen) + 0.2
//                    print("\(layoutAttributes.alpha)")
//                    layoutAttributesCache.append(layoutAttributes)
//                    xPosition += size.width * 0.25
//                }
//            }
//        }
    }
    
    override func invalidateLayout(){
        super.invalidateLayout()
        print("Invalidating layout.")
    }
    
    override func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext){
        super.invalidateLayoutWithContext(context)
        print("Invalidating layout with context.")
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
//        for attributes  in layoutAttributesCache {
//            if CGRectIntersectsRect(attributes.frame, rect) {
//                layoutAttributes.append(attributes)
//            }
//        }
        let indexPath = collectionView?.indexPathForItemAtPoint(CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)))
        print("\(indexPath)")
        return layoutAttributes
    }
    
    override func collectionViewContentSize() -> CGSize{
        return CGSizeMake(contentHeight, contentWidth)
    }
    
}
