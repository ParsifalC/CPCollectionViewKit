//
//  CPCollectionViewLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/1/22.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit

open class CPCollectionViewLayout:UICollectionViewLayout {
    // MARK: Properties
    var cellCount = 0
    var cachedAttributesArray = [UICollectionViewLayoutAttributes]()

    // MARK: Methods
    override open func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        cellCount = collectionView.numberOfItems(inSection: 0)
        cachedAttributesArray.removeAll()
        for i in 0..<cellCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attrbutes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            cachedAttributesArray.append(attrbutes)
        }
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributesArray[indexPath.item]
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for index in 0..<cellCount {
            let attributes = layoutAttributesForItem(at: IndexPath(row:index, section:0))!
            if rect.intersects(attributes.frame) && !attributes.isHidden {
                visibleAttributesArray.append(attributes)
            }
        }
        
        return visibleAttributesArray
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
