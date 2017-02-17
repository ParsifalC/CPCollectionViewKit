//
//  CPCollectionViewStageLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/2/17.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import Foundation

open class CPStageLayoutConfiguration: CPLayoutConfiguration {
    
}

open class CPCollectionViewStageLayout: CPCollectionViewLayout {
    
    public var configuration: CPStageLayoutConfiguration
    
    public init(withConfiguration configuration: CPStageLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.configuration =  CPStageLayoutConfiguration(withCellSize: CGSize(width: 100, height: 100))
        super.init(coder: aDecoder)
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)!
        guard let collectionView = collectionView else { return  attributes}
        
        let item = CGFloat(indexPath.item)
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellSize = configuration.cellSize
        let cellHeight = cellSize.height
        var centerX: CGFloat = 0.0
        var centerY: CGFloat = 0.0
        let topItemIndex = collectionView.contentOffset.y/cellHeight
        let itemOffset = item-topItemIndex
                
        return attributes
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize }
        let cellWidth = configuration.cellSize.width
        let width = CGFloat(cellCount-1)*cellWidth+collectionView.bounds.height
        return CGSize(width: width, height: collectionView.bounds.height)
    }

}
