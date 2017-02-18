//
//  CPCollectionViewStageLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/2/17.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import Foundation

public enum CPMoveAnimationStyle {
    case none
    case waltz
    case somefault
}

public enum CPLeaveStageAnimationStyle {
    case fadeAway
    case zoomin
    case outOfBoundary
    case fadeAwayAndZoomin
    case blend
}

open class CPStageLayoutConfiguration: CPLayoutConfiguration {
    
    public var topCellSize = CGSize(width: 100, height: 100)
    public var moveAnimationStyle: CPMoveAnimationStyle = .none
    public var leaveStageAnimationStyle: CPLeaveStageAnimationStyle = .fadeAway
    
}

open class CPCollectionViewStageLayout: CPCollectionViewLayout {
    
    public var configuration: CPStageLayoutConfiguration
    public var currentIndex: Int {
        get {
            if let collectionView = collectionView {
                return Int(round(collectionView.contentOffset.x/configuration.cellSize.width))
            }
            
            return 0
        }
    }
    
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
        var cellSize = configuration.cellSize
        let topCellSize = configuration.topCellSize
        let cellHeight = cellSize.height
        let cellWidth = cellSize.width
        var centerX: CGFloat = 0.0
        var centerY: CGFloat = 0.0
        let topItemIndex = collectionView.contentOffset.x/cellWidth
        let itemOffset = item-topItemIndex
        
        attributes.isHidden = false
        
        if itemOffset > -1 && itemOffset<0 {
            if configuration.leaveStageAnimationStyle == .outOfBoundary
                || configuration.leaveStageAnimationStyle == .blend{
                centerX = collectionView.contentOffset.x+(fabs(itemOffset)+0.5)*width
            } else {
                centerX = collectionView.contentOffset.x+0.5*width
            }
            centerY = (height-cellHeight)/2

            if configuration.leaveStageAnimationStyle == .fadeAway
                || configuration.leaveStageAnimationStyle == .fadeAwayAndZoomin
                || configuration.leaveStageAnimationStyle == .blend {
                attributes.alpha = (1+itemOffset)
            } else {
                attributes.alpha = 1
            }
            
            if configuration.leaveStageAnimationStyle == .zoomin
                || configuration.leaveStageAnimationStyle == .fadeAwayAndZoomin
                || configuration.leaveStageAnimationStyle == .blend {
                cellSize = CGSize(width: (1+itemOffset)*topCellSize.width,
                                  height: (1+itemOffset)*topCellSize.height)
            } else {
                cellSize = topCellSize
            }
        } else if itemOffset<=1 && itemOffset>=0 {
            centerX = ((width-cellWidth)/2)*(1-itemOffset)+cellWidth/2+collectionView.contentOffset.x
            centerY = ((cellHeight/2-height)/(2))*(1-itemOffset)+height-cellHeight/2
            cellSize = CGSize(width: (cellWidth-topCellSize.width)*itemOffset+topCellSize.width,
                              height: (cellHeight-topCellSize.height)*itemOffset+topCellSize.height)
        } else if itemOffset>1 {
            centerX = collectionView.contentOffset.x+(itemOffset-0.5)*cellWidth+(itemOffset-1)*configuration.spacing
            centerY = height-cellHeight/2
        } else {
            attributes.isHidden = true
            centerX = -width
            centerY = -height
        }
        
        let rotateFactor = fabs(itemOffset*100).remainder(dividingBy: 100)/100
        
        switch configuration.moveAnimationStyle {
        case .waltz where itemOffset>0:
            attributes.transform3D =  CATransform3DRotate(attributes.transform3D, CGFloat(M_PI*2)*rotateFactor, 0, 1, 0)
        case .somefault where itemOffset>0:
            attributes.transform3D =  CATransform3DRotate(attributes.transform3D, CGFloat(M_PI*2)*rotateFactor, 0, 0, 1)
        default:
            attributes.transform3D = CATransform3DIdentity
        }
        
//        print("item:\(item) itemOffset:\(itemOffset) topItemIndex:\(topItemIndex)")
        
        attributes.size = cellSize
        attributes.center = CGPoint(x: centerX+configuration.offsetX,
                                    y: centerY+configuration.offsetY)
        
        return attributes
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize }
        let cellWidth = configuration.cellSize.width
        let width = CGFloat(cellCount-1)*cellWidth+collectionView.bounds.height
        return CGSize(width: width, height: collectionView.bounds.height)
    }

}
