//
//  CPCollectionViewCircleLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/1/20.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit

open class CPCircleLayoutConfiguration:CPLayoutConfiguration {

}

open class CPCollectionViewCircleLayout: CPCollectionViewLayout {
    // MARK: Properties
    public var configuration: CPCircleLayoutConfiguration
    public var currentIndex: Int {
        get {
            guard let collectionView = collectionView else { return 0 }
            var index = Int(round(collectionView.contentOffset.y/configuration.cellSize.height))
            
            if index>=cellCount && cellCount>0 {
                index = cellCount-1
            }
            
            return index
        }
    }

    // MARK: Methods
    public init(withConfiguration configuration: CPCircleLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.configuration = CPCircleLayoutConfiguration(withCellSize: CGSize(width:50, height:50))
        super.init(coder: aDecoder)
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)!
        guard let collectionView = collectionView else { return attributes }
        let contentOffsetY = collectionView.contentOffset.y
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellSize = configuration.cellSize
        let cellWidth = cellSize.width
        var topItemIndex = contentOffsetY/cellSize.height
        topItemIndex = topItemIndex>=CGFloat(cellCount) ? topItemIndex-CGFloat(cellCount) : topItemIndex
        var visibleCount = CGFloat(max(1, cellCount))/2
        let index = CGFloat(indexPath.item)
        
        attributes.size = cellSize
        
        var itemOffset = index-topItemIndex
        let floatPI = CGFloat(M_PI)
        let radian = CGFloat(floatPI/visibleCount*itemOffset)
        let y = height+contentOffsetY-cellWidth/2-cos(radian)*(cellWidth/2+configuration.spacing)
        let x = sin(radian)*(cellSize.width/2+configuration.spacing)+width/2
        attributes.center = CGPoint(x:x-configuration.offsetX, y:y-configuration.offsetY)
        attributes.zIndex = round(topItemIndex)==index ? 1000 : indexPath.item
        
//        print("topItemIndex:\(topItemIndex) itemOffset:\(itemOffset) isHidden:\(attributes.isHidden)")
        return attributes
    }
    
    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {
            return nil
        }
        
        if insertIndexPaths.contains(itemIndexPath) && updateAnimationStyle == .custom {
            let x = collectionView!.bounds.width/2
            let y = collectionView!.bounds.height+collectionView!.contentOffset.y
            attributes.center = CGPoint(x: x-configuration.offsetX,
                                        y: y-configuration.offsetY)
        }
        
        return attributes
    }
    
    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else {
            return nil
        }
        
        if deleteIndexPaths.contains(itemIndexPath)
            && updateAnimationStyle == .custom {
            let x = collectionView!.bounds.width/2
            let y = collectionView!.bounds.height+collectionView!.contentOffset.y
            attributes.center = CGPoint(x: x-configuration.offsetX,
                                        y: y-configuration.offsetY)
        }
        
        return attributes
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return CGSize.zero }
        let bounds = collectionView.bounds.size
        return CGSize(width:bounds.width, height:bounds.height+CGFloat(cellCount)*configuration.cellSize.height)
    }
}
