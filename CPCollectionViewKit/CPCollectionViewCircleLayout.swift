//
//  CPCollectionViewCircleLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/1/20.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit

open class CPCircleLayoutConfiguration:CPLayoutConfiguration {
    
    public var visibleCount:Int = 1
    
    // MARK: Methods
    public init(withCellSize cellSize:CGSize,
                visibleCount:Int,
                spacing:CGFloat = 0.0,
                offsetX:CGFloat = 0.0,
                offsetY:CGFloat = 0.0) {
        self.visibleCount = visibleCount
        super.init(withCellSize:cellSize,
                   spacing:spacing,
                   offsetX:offsetX,
                   offsetY:offsetY)
    }
    
}

open class CPCollectionViewCircleLayout:CPCollectionViewLayout {
    // MARK: Properties
    public var configuration:CPCircleLayoutConfiguration

    // MARK: Methods
    public init(withConfiguration configuration:CPCircleLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.configuration = CPCircleLayoutConfiguration.init(withCellSize: CGSize(width:50, height:50), visibleCount: 1)
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
        let visibleCount = CGFloat(configuration.visibleCount)/2
        let index = CGFloat(indexPath.item)
        attributes.size = cellSize
        attributes.isHidden = false
        
        var itemOffset = index-topItemIndex
        //example:0,1,2,3,4 exposedItem=2,visibleCount=2 0==-2 1==-1 2==0 3==1 4==2
        if itemOffset>=0 && itemOffset<=visibleCount ||
            itemOffset<0 && fabsf(Float(itemOffset))<Float(visibleCount) ||
            itemOffset>0 && (CGFloat(cellCount)-itemOffset)<visibleCount ||
            itemOffset<0 && (CGFloat(cellCount)+itemOffset)<visibleCount{
            if itemOffset>0 && (CGFloat(cellCount)-itemOffset)<visibleCount {
                itemOffset -= CGFloat(cellCount)
            }
            if itemOffset<0 && (CGFloat(cellCount)+itemOffset)<visibleCount {
                itemOffset += CGFloat(cellCount)
            }
            
            let floatPI = CGFloat(M_PI)
            let radian = CGFloat(floatPI/visibleCount*itemOffset)
            let y = height+contentOffsetY-cellWidth/2-cos(radian)*(cellWidth/2+configuration.spacing)
            let x = sin(radian)*(cellSize.width/2+configuration.spacing)+width/2
            attributes.center = CGPoint(x:x-configuration.offsetX, y:y-configuration.offsetY)
        } else {
            attributes.isHidden = true
        }
//            print("topItemIndex:\(topItemIndex) itemOffset:\(itemOffset) isHidden:\(attributes.isHidden)")
        return attributes
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return CGSize.zero }
        let bounds = collectionView.bounds.size
        return CGSize(width:bounds.width, height:bounds.height+CGFloat(cellCount)*configuration.cellSize.height)
    }
}
