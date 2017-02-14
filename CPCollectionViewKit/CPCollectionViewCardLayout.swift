//
//  CPCollectionViewCardLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/2/13.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import Foundation

open class CPCardLayoutConfiguration: CPLayoutConfiguration {
    
    public var fadeFactor: CGFloat = 0//(0,1)
    public var scaleFactorX: CGFloat = 0//zoomin:(-1,0) zoomout:(0,1)
    public var scaleFactorY: CGFloat = 0//zoomin:(-1,0) zoomout:(0,1)
    public var rotateFactor: CGFloat = 0//0-1
    public var stopAtItemBoundary: Bool = true
    
}

open class CPCollectionViewCardLayout: CPCollectionViewLayout {
    
    public var configuration: CPCardLayoutConfiguration
    
    public init(withConfiguration configuration: CPCardLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.configuration =  CPCardLayoutConfiguration(withCellSize: CGSize(width: 100, height: 100))
        super.init(coder: aDecoder)
    }
    
    open override func prepare() {
        super.prepare()
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)!
        guard let collectionView = collectionView else { return  attributes}
        
        let item = CGFloat(indexPath.item)
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellSize = configuration.cellSize
        let cellWidth = cellSize.width
        let cellHeight = cellSize.height
        var centerX: CGFloat = 0.0
        var centerY: CGFloat = 0.0
        let topItemIndex = calculateTopItemIndex(contentOffset: collectionView.contentOffset.x)
        let itemOffset = item-topItemIndex
        
        attributes.size = cellSize
        centerX = (item+0.5)*cellWidth+item*configuration.spacing
        centerY = height/2.0
        attributes.center = CGPoint(x: centerX+configuration.offsetX, y: centerY+configuration.offsetY)
        
        attributes.alpha = 1-configuration.fadeFactor*fabs(itemOffset)

        let scaleFactorX = fabs(1-configuration.scaleFactorX*fabs(itemOffset))
        let scaleFactorY = fabs(1-configuration.scaleFactorY*fabs(itemOffset))
        let scaleTransform = CGAffineTransform(scaleX: scaleFactorX, y: scaleFactorY)
        
        let rotateFactor = configuration.rotateFactor*itemOffset
        let rotateTransform = CGAffineTransform(rotationAngle: rotateFactor)
    
        let transform = rotateTransform.concatenating(scaleTransform)
        attributes.transform = transform
        
        //print("index:\(item) topItemIndex:\(topItemIndex) itemOffset:\(itemOffset)")
        return attributes
    }
    
    func calculateTopItemIndex(contentOffset: CGFloat) -> CGFloat {
        let cellWidth = configuration.cellSize.width
        let cellHeight = configuration.cellSize.height

        guard cellWidth+configuration.spacing != 0 else { return 0 }
        return  (contentOffset)/(cellWidth+configuration.spacing)
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard configuration.stopAtItemBoundary else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let cellWidth = configuration.cellSize.width
        let cellHeight = configuration.cellSize.height

        let topItemIndex = round(calculateTopItemIndex(contentOffset: proposedContentOffset.x))
        let x = (cellWidth+configuration.spacing)*topItemIndex
        let y = proposedContentOffset.y
        return CGPoint(x: x, y: y)
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize }
        let cellWidth = configuration.cellSize.width
        let cellHeight = configuration.cellSize.height
        let spacing = configuration.spacing
        var width = CGFloat(cellCount)*cellWidth+max(CGFloat(cellCount-1), 0)*spacing+2*configuration.offsetX
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
}
