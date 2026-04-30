//
//  CollectionViewLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/1/22.
//  Copyright © 2017-2026 Parsifal. All rights reserved.
//

import UIKit

/// Defines the animation style used when inserting or deleting items.
public enum ItemUpdateAnimation {
    /// Uses the default iOS insert/delete animation.
    case common
    /// Uses a scale zoom-in/out animation.
    case base
    /// Uses a custom animation defined by the subclass layout.
    case custom
}

/// Protocol that custom layouts can conform to for supporting layout transitions
/// and exposing the current top/center item index.
public protocol CollectionViewLayoutProtocol {

    /// The index of the currently focused/top item.
    var currentIndex: Int { get }

    /// Returns the content offset that would center the given index path.
    func contentOffsetFor(indexPath: IndexPath) -> CGPoint

    /// Returns layout attributes for the given index path in a collection view.
    func attributesForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
}

/// Base layout class for all CPCollectionViewKit layouts.
///
/// Handles common behavior including attribute caching, insert/delete tracking,
/// and pluggable update animation styles.
///
/// - Note: This layout only supports **section 0**. Multi-section usage is not supported.
@MainActor
open class CollectionViewLayout: UICollectionViewLayout {

    // MARK: - Properties

    var cellCount = 0
    var cachedAttributesArray = [UICollectionViewLayoutAttributes]()
    var deleteIndexPaths = [IndexPath]()
    var insertIndexPaths = [IndexPath]()

    /// Controls the animation style applied during item insert/delete updates.
    public var updateAnimationStyle: ItemUpdateAnimation = .common

    // MARK: - UICollectionViewLayout

    override open func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        cellCount = collectionView.numberOfItems(inSection: 0)
        cachedAttributesArray.removeAll()

        for i in 0..<cellCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            cachedAttributesArray.append(attributes)
        }
    }

    open override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        for updateItem in updateItems {
            if updateItem.updateAction == .delete {
                guard let indexPath = updateItem.indexPathBeforeUpdate else { return }
                deleteIndexPaths.append(indexPath)
            } else if updateItem.updateAction == .insert {
                guard let indexPath = updateItem.indexPathAfterUpdate else { return }
                insertIndexPaths.append(indexPath)
            }
        }
    }

    open override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deleteIndexPaths.removeAll()
        insertIndexPaths.removeAll()
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = cachedAttributesArray[indexPath.item]
        attributes.zIndex = indexPath.item
        return attributes
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributesArray = [UICollectionViewLayoutAttributes]()

        for index in 0..<cellCount {
            guard let attributes = layoutAttributesForItem(at: IndexPath(row: index, section: 0)) else { continue }
            if rect.intersects(attributes.frame) && !attributes.isHidden {
                visibleAttributesArray.append(attributes)
            }
        }

        return visibleAttributesArray
    }

    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }

        if updateAnimationStyle == .base, deleteIndexPaths.contains(itemIndexPath) {
            attributes.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            attributes.alpha = 0
        }

        return attributes
    }

    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }

        if updateAnimationStyle == .base, insertIndexPaths.contains(itemIndexPath) {
            attributes.alpha = 1
            attributes.transform = CGAffineTransform(scaleX: 2, y: 2)
        }

        return attributes
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
