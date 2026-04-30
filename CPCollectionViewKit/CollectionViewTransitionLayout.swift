//
//  CollectionViewTransitionLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/2/18.
//  Copyright © 2017-2026 Parsifal. All rights reserved.
//

import UIKit

/// A `UICollectionViewTransitionLayout` subclass that smoothly interpolates
/// between two layouts that conform to `CollectionViewLayoutProtocol`.
///
/// Used in conjunction with `TransitionManager` to animate layout changes.
open class CollectionViewTransitionLayout: UICollectionViewTransitionLayout {

    // MARK: - Properties

    /// The content offset of the source layout before transition starts.
    public var fromContentOffset = CGPoint.zero

    /// The content offset of the destination layout after transition completes.
    public var toContentOffset = CGPoint.zero

    private var attributesArray = [UICollectionViewLayoutAttributes]()

    // MARK: - Transition Progress

    open override var transitionProgress: CGFloat {
        didSet {
            transitionProgressUpdated(currentProgress: transitionProgress)
        }
    }

    private func transitionProgressUpdated(currentProgress: CGFloat) {
        guard let collectionView = collectionView else { return }

        let fromProgress = currentProgress
        let toProgress = 1 - currentProgress

        let offset = CGPoint(
            x: toProgress * fromContentOffset.x + fromProgress * toContentOffset.x,
            y: toProgress * fromContentOffset.y + fromProgress * toContentOffset.y
        )
        collectionView.contentOffset = offset
    }

    // MARK: - UICollectionViewLayout

    open override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let cellCount = collectionView.numberOfItems(inSection: 0)
        attributesArray.removeAll()

        for index in 0..<cellCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            let fromAttributes: UICollectionViewLayoutAttributes?
            let toAttributes: UICollectionViewLayoutAttributes?

            if let protocol_ = self.currentLayout as? CollectionViewLayoutProtocol {
                fromAttributes = protocol_.attributesForCollectionView(collectionView: collectionView, indexPath: indexPath)
            } else {
                fromAttributes = self.currentLayout.layoutAttributesForItem(at: indexPath)
            }

            if let protocol_ = self.nextLayout as? CollectionViewLayoutProtocol {
                toAttributes = protocol_.attributesForCollectionView(collectionView: collectionView, indexPath: indexPath)
            } else {
                toAttributes = self.nextLayout.layoutAttributesForItem(at: indexPath)
            }

            guard let from = fromAttributes, let to = toAttributes else { continue }

            let fx = from.center.x
            let fy = from.center.y
            let tx = to.center.x
            let ty = to.center.y

            var center = CGPoint(x: fx, y: fy)
            center.x = interpolate(from: fx, to: tx)
            center.y = fx == tx
                ? interpolate(from: fy, to: ty)
                : ty + ((fy - ty) * (center.x - tx)) / (fx - tx)
            attributes.center = center

            var newSize = from.size
            newSize.width = interpolate(from: from.size.width, to: to.size.width)
            newSize.height = interpolate(from: from.size.height, to: to.size.height)
            attributes.size = newSize
            attributes.zIndex = to.zIndex

            let toAlpha = to.isHidden ? 0 : to.alpha
            attributes.alpha = interpolate(from: from.alpha, to: toAlpha)

            var newScale = CGAffineTransform.identity
            newScale.a = interpolate(from: from.transform.a, to: to.transform.a)
            newScale.d = interpolate(from: from.transform.d, to: to.transform.d)
            attributes.transform = newScale

            attributesArray.append(attributes)
        }
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Bug fix: return only attributes whose frames intersect rect, not the full array.
        return attributesArray.filter { rect.intersects($0.frame) }
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: - Private

    /// Linearly interpolates from `from` to `to` using the current `transitionProgress`.
    private func interpolate(from fromValue: CGFloat, to toValue: CGFloat) -> CGFloat {
        return (toValue - fromValue) * transitionProgress + fromValue
    }
}
