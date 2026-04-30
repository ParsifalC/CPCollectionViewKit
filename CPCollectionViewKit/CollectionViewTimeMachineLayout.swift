//
//  CollectionViewTimeMachineLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/2/13.
//  Copyright © 2017-2026 Parsifal. All rights reserved.
//

import UIKit

/// Configuration for `CollectionViewTimeMachineLayout`.
open class TimeMachineLayoutConfiguration: LayoutConfiguration {

    /// Maximum number of items visible behind the front card. `0` means no limit.
    public var visibleCount = 0

    /// The smallest cell size shown for the furthest-back card.
    public var minCellSize = CGSize(width: 50, height: 50)

    /// The amount the scale shrinks per step behind the front card. Range: (0, 1).
    public var scaleFactor: CGFloat = 0.5

    /// Horizontal offset (in points) between each stacked card.
    public var spacingX: CGFloat = 20

    /// Vertical offset (in points) between each stacked card.
    public var spacingY: CGFloat = 0

    override public var spacing: CGFloat {
        didSet {
            spacingX = spacing
            spacingY = spacing
        }
    }

    /// If `true`, the stack is reversed so the last item appears on top.
    public var reversed: Bool = false
}

/// A `UICollectionViewLayout` subclass that stacks items like a time machine,
/// where the frontmost card is full-size and cards behind it shrink and shift.
///
/// Conforms to `CollectionViewLayoutProtocol` for layout transition support.
open class CollectionViewTimeMachineLayout: CollectionViewLayout {

    // MARK: - Properties

    public var configuration: TimeMachineLayoutConfiguration

    // MARK: - Init

    public init(withConfiguration configuration: TimeMachineLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.configuration = TimeMachineLayoutConfiguration(withCellSize: CGSize(width: 100, height: 100))
        super.init(coder: aDecoder)
    }

    // MARK: - UICollectionViewLayout

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return super.layoutAttributesForItem(at: indexPath) }
        return attributesForCollectionView(collectionView: collectionView, indexPath: indexPath)
    }

    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize }

        let cellHeight = configuration.cellSize.height
        let height = CGFloat(cellCount - 1) * cellHeight + collectionView.bounds.height
        return CGSize(width: collectionView.bounds.width, height: height)
    }

    // MARK: - Private

    private func calculateTopItemIndex() -> CGFloat {
        guard let collectionView = collectionView else { return 0 }

        if configuration.reversed {
            return CGFloat(cellCount - 1) - collectionView.contentOffset.y / configuration.cellSize.height
        } else {
            return collectionView.contentOffset.y / configuration.cellSize.height
        }
    }
}

// MARK: - CollectionViewLayoutProtocol

extension CollectionViewTimeMachineLayout: CollectionViewLayoutProtocol {

    public var currentIndex: Int {
        let topItemIndex = calculateTopItemIndex()
        var index = Int(round(topItemIndex))

        if cellCount > 0 {
            index = min(cellCount - 1, index)
        } else {
            index = 0
        }

        return max(0, index)
    }

    public func contentOffsetFor(indexPath: IndexPath) -> CGPoint {
        var contentOffset = CGPoint.zero
        contentOffset.y = CGFloat(indexPath.item) * configuration.cellSize.height
        return contentOffset
    }

    public func attributesForCollectionView(collectionView: UICollectionView,
                                            indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else { return nil }

        let item = CGFloat(indexPath.item)
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellSize = configuration.cellSize
        let visibleCount = configuration.visibleCount <= 0
            ? CGFloat(cellCount)
            : CGFloat(min(configuration.visibleCount, cellCount))
        var centerX: CGFloat = 0.0
        var centerY: CGFloat = 0.0

        let topItemIndex = calculateTopItemIndex()
        let itemOffset: CGFloat

        if configuration.reversed {
            itemOffset = topItemIndex - item
            attributes.zIndex = indexPath.item
        } else {
            itemOffset = item - topItemIndex
            attributes.zIndex = -indexPath.item
        }

        attributes.size = cellSize

        if itemOffset < visibleCount + 1 && itemOffset >= -1 {
            centerX = width / 2 + itemOffset * configuration.spacingX
            centerY = height / 2 + collectionView.contentOffset.y + itemOffset * configuration.spacingY

            let scaleFactor = 1 - itemOffset / CGFloat(visibleCount) * configuration.scaleFactor
            attributes.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

            attributes.isHidden = false
            attributes.alpha = itemOffset + 1
        } else {
            centerX = -width / 2
            centerY = -height / 2
            attributes.isHidden = true
        }

        attributes.center = CGPoint(x: centerX + configuration.offsetX,
                                    y: centerY + configuration.offsetY)

        return attributes
    }
}
