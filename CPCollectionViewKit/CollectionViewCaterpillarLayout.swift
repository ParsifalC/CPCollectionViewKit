//
//  CollectionViewCaterpillarLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/1/21.
//  Copyright © 2017-2026 Parsifal. All rights reserved.
//

import UIKit

/// Configuration for `CollectionViewCaterpillarLayout`.
open class CaterpillarLayoutConfiguration: LayoutConfiguration {

    // MARK: - Properties

    /// Scale factor applied to the topmost (center) cell. Range: (0, 1].
    public var topCellSizeScale: CGFloat

    /// Number of cells visible at one time on each side of the center cell.
    public var visibleCount: Int = 1

    /// Whether non-center cells fade out as they move away from the center.
    public var fadeAway: Bool = true

    // MARK: - Init

    public init(withCellSize cellSize: CGSize,
                visibleCount: Int,
                fadeAway: Bool = true,
                topCellSizeScale: CGFloat = 1.0,
                spacing: CGFloat = 0.0,
                offsetX: CGFloat = 0.0,
                offsetY: CGFloat = 0.0) {
        self.topCellSizeScale = topCellSizeScale
        self.visibleCount = visibleCount
        self.fadeAway = fadeAway
        super.init(withCellSize: cellSize,
                   spacing: spacing,
                   offsetX: offsetX,
                   offsetY: offsetY)
    }
}

/// A `UICollectionViewLayout` subclass that arranges items in a caterpillar-style
/// circular arc, where the center item is largest and adjacent items curve away.
open class CollectionViewCaterpillarLayout: CollectionViewLayout {

    // MARK: - Properties

    open var configuration: CaterpillarLayoutConfiguration

    // MARK: - Init

    public init(withConfiguration configuration: CaterpillarLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.configuration = CaterpillarLayoutConfiguration(withCellSize: CGSize(width: 50, height: 50),
                                                            visibleCount: 1)
        super.init(coder: aDecoder)
    }

    // MARK: - UICollectionViewLayout

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath),
              let collectionView = collectionView else { return nil }

        let floatCellCount = CGFloat(cellCount)
        let contentOffsetY = collectionView.contentOffset.y
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellSize = configuration.cellSize
        let topCellSizeScale = configuration.topCellSizeScale
        let cellWidth = cellSize.width
        let cellSpacing = configuration.spacing

        var topItemIndex = contentOffsetY / cellSize.height
        topItemIndex = topItemIndex >= floatCellCount ? topItemIndex - floatCellCount : topItemIndex
        topItemIndex = topItemIndex < 0 ? topItemIndex + floatCellCount : topItemIndex

        let visibleCount = CGFloat(min(configuration.visibleCount, cellCount)) / 2
        let index = CGFloat(indexPath.item)

        attributes.size = configuration.cellSize
        attributes.isHidden = false

        var itemOffset = index - topItemIndex

        if itemOffset < 0 && itemOffset >= -1.0
            || itemOffset >= 0 && itemOffset <= 1
            || itemOffset > 0 && floatCellCount - itemOffset <= 1
            || itemOffset < 0 && floatCellCount + itemOffset <= 1 {

            if itemOffset > 0 && floatCellCount - itemOffset <= 1 {
                itemOffset -= floatCellCount
            }
            if itemOffset < 0 && floatCellCount + itemOffset <= 1 {
                itemOffset += floatCellCount
            }

            // Scale: y = (1-s)*|x| + s
            let scaleFactor: CGFloat = (1 - topCellSizeScale) * abs(itemOffset) + topCellSizeScale
            attributes.size = CGSize(width: cellSize.width * scaleFactor,
                                     height: cellSize.height * scaleFactor)

            // Circular arc positioning
            let radian = CGFloat(Double.pi / 2 * Double(itemOffset))
            let x = sin(radian) * (cellSpacing / 2) + width / 2
            let y = height / 2 + contentOffsetY - cos(radian) * (cellSpacing / 2)
            attributes.center = CGPoint(x: x, y: y)

        } else if abs(itemOffset) < visibleCount
            || itemOffset > 0 && (floatCellCount - itemOffset < visibleCount)
            || itemOffset < 0 && (floatCellCount + itemOffset < visibleCount) {

            if itemOffset > 0 && (floatCellCount - itemOffset < visibleCount) {
                itemOffset -= floatCellCount
            }
            if itemOffset < 0 && (floatCellCount + itemOffset < visibleCount) {
                itemOffset += floatCellCount
            }

            // Vertical linear positioning
            let x = itemOffset > 0 ? (width / 2 + cellSpacing / 2) : (width / 2 - cellSpacing / 2)
            let y = height / 2 + contentOffsetY + (abs(itemOffset) - 1) * cellSpacing / 2
            attributes.center = CGPoint(x: x, y: y)

        } else {
            attributes.center = CGPoint(x: -cellWidth, y: height + contentOffsetY + cellSize.height)
            attributes.isHidden = true
        }

        attributes.center = CGPoint(x: attributes.center.x + configuration.offsetX,
                                    y: attributes.center.y + configuration.offsetY)

        if configuration.fadeAway {
            attributes.alpha = 1 - abs(itemOffset) / visibleCount
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
