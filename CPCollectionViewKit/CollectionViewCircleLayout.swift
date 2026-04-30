//
//  CollectionViewCircleLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/1/20.
//  Copyright © 2017-2026 Parsifal. All rights reserved.
//

import UIKit

/// Configuration for `CollectionViewCircleLayout`.
/// Inherits all base properties from `LayoutConfiguration`.
open class CircleLayoutConfiguration: LayoutConfiguration {}

/// A `UICollectionViewLayout` subclass that arranges items along a circular arc,
/// centered at the bottom of the collection view.
///
/// Conforms to `CollectionViewLayoutProtocol` for layout transition support.
open class CollectionViewCircleLayout: CollectionViewLayout {

    // MARK: - Properties

    public var configuration: CircleLayoutConfiguration

    // MARK: - Init

    public init(withConfiguration configuration: CircleLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.configuration = CircleLayoutConfiguration(withCellSize: CGSize(width: 50, height: 50))
        super.init(coder: aDecoder)
    }

    // MARK: - UICollectionViewLayout

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return super.layoutAttributesForItem(at: indexPath) }
        return attributesForCollectionView(collectionView: collectionView, indexPath: indexPath)
    }

    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {
            return nil
        }

        if insertIndexPaths.contains(itemIndexPath) && updateAnimationStyle == .custom {
            guard let collectionView = collectionView else { return attributes }
            let x = collectionView.bounds.width / 2
            let y = collectionView.bounds.height + collectionView.contentOffset.y
            attributes.center = CGPoint(x: x - configuration.offsetX,
                                        y: y - configuration.offsetY)
        }

        return attributes
    }

    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else {
            return nil
        }

        if deleteIndexPaths.contains(itemIndexPath) && updateAnimationStyle == .custom {
            guard let collectionView = collectionView else { return attributes }
            let x = collectionView.bounds.width / 2
            let y = collectionView.bounds.height + collectionView.contentOffset.y
            attributes.center = CGPoint(x: x - configuration.offsetX,
                                        y: y - configuration.offsetY)
            attributes.alpha = 0
            attributes.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }

        return attributes
    }

    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }

        let bounds = collectionView.bounds.size
        return CGSize(width: bounds.width,
                      height: bounds.height + CGFloat(cellCount) * configuration.cellSize.height)
    }
}

// MARK: - CollectionViewLayoutProtocol

extension CollectionViewCircleLayout: CollectionViewLayoutProtocol {

    public var currentIndex: Int {
        guard let collectionView = collectionView else { return 0 }

        var index = Int(round(collectionView.contentOffset.y / configuration.cellSize.height))

        if index >= cellCount && cellCount > 0 {
            index = cellCount - 1
        }

        return index
    }

    public func contentOffsetFor(indexPath: IndexPath) -> CGPoint {
        var contentOffset = CGPoint.zero
        contentOffset.y = CGFloat(indexPath.item) * configuration.cellSize.height
        return contentOffset
    }

    public func attributesForCollectionView(collectionView: UICollectionView,
                                            indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else { return nil }

        let contentOffsetY = collectionView.contentOffset.y
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellSize = configuration.cellSize
        let cellWidth = cellSize.width

        var topItemIndex = contentOffsetY / cellSize.height
        topItemIndex = topItemIndex >= CGFloat(cellCount) ? topItemIndex - CGFloat(cellCount) : topItemIndex

        let visibleCount = CGFloat(max(1, cellCount)) / 2
        let index = CGFloat(indexPath.item)

        attributes.size = cellSize

        let itemOffset = index - topItemIndex
        let radian = CGFloat(Double.pi) / visibleCount * itemOffset
        let y = height + contentOffsetY - cellWidth / 2 - cos(radian) * (cellWidth / 2 + configuration.spacing)
        let x = sin(radian) * (cellSize.width / 2 + configuration.spacing) + width / 2

        attributes.center = CGPoint(x: x - configuration.offsetX, y: y - configuration.offsetY)
        attributes.zIndex = round(topItemIndex) == index ? 1000 : indexPath.item

        return attributes
    }
}
