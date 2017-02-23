//
//  CPCollectionViewTransitionLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/2/18.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit

open class CPCollectionViewTransitionLayout: UICollectionViewTransitionLayout {
    
    public var fromContentOffset = CGPoint(x: 0, y: 0)
    public var toContentOffset = CGPoint(x: 0, y: 0)
    var attributesArray = [UICollectionViewLayoutAttributes]()
    
    open override var transitionProgress: CGFloat {
        didSet {
            transitionProgressUpdated(currentProgress: transitionProgress)
        }
    }
    
    func transitionProgressUpdated(currentProgress: CGFloat) {
        if let collectionView = collectionView {
            let fromProgress = currentProgress
            let toProgress = 1 - currentProgress
            
            var offset = CGPoint(x: 0, y: 0)
            offset.x = toProgress * fromContentOffset.x + fromProgress * toContentOffset.x
            offset.y = toProgress * fromContentOffset.y + fromProgress * toContentOffset.y
            collectionView.contentOffset = offset
        }
    }
    
    open override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            let cellCount = collectionView.numberOfItems(inSection: 0)
            attributesArray.removeAll()
            for index in 0..<cellCount {
                let indexPath = IndexPath(item: index, section: 0)
                var attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let fromAttributes = self.currentLayout.layoutAttributesForItem(at: indexPath)
                let toAttributes = self.nextLayout.layoutAttributesForItem(at: indexPath)

                if let fromAttributes = fromAttributes,
                   let toAttributes = toAttributes {
                    let fx = fromAttributes.center.x
                    let fy = fromAttributes.center.y
                    let tx = toAttributes.center.x
                    let ty = toAttributes.center.y
                    
                    var center = CGPoint(x: fx, y: fy)
                    
                    center.x = fx + (tx - fx) * transitionProgress
                    center.y = fx == tx ? ((fy - ty) * transitionProgress + fy) : ty + ((fy - ty) * (center.x - tx)) / (fx - tx)
                    
                    //(y-y2)/(y1-y2) = (x-x2)/(x1-x2)
                    attributes.center = center
                    attributes.size = toAttributes.size
                    attributesArray.append(attributes)
                }
            }
        }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesArray {
            if rect.intersects(attributes.frame) {
                array.append(attributes)
            }
        }
        
        return attributesArray
    }
    
}
