//
//  CollectionViewTransitionManager.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/2/18.
//  Copyright © 2017-2026 Parsifal. All rights reserved.
//

import UIKit

/// Manages a timed, automatic transition between two `UICollectionViewLayout` instances.
///
/// Use this class to trigger a smooth, animated layout switch on a collection view.
/// The transition is driven by a `CADisplayLink` and completes after the specified `duration`.
///
/// ## Usage
/// ```swift
/// let manager = TransitionManager(duration: 0.4,
///                                  collectionView: collectionView,
///                                  toLayout: newLayout)
/// manager.toContentOffset = newContentOffset
/// manager.startInteractiveTransition { }
/// ```
open class TransitionManager {

    // MARK: - Properties

    /// The content offset the collection view should land on after the transition.
    public var toContentOffset = CGPoint.zero

    private weak var collectionView: UICollectionView?
    private let toLayout: UICollectionViewLayout
    private var transitionLayout: CollectionViewTransitionLayout?
    private let duration: TimeInterval
    private var timer: CADisplayLink?
    private var startTime: TimeInterval = 0

    // MARK: - Init

    /// Creates a new `TransitionManager`.
    ///
    /// - Parameters:
    ///   - duration: Duration of the transition animation in seconds.
    ///   - collectionView: The collection view to transition.
    ///   - toLayout: The target layout to transition into.
    public init(duration: TimeInterval,
                collectionView: UICollectionView,
                toLayout: UICollectionViewLayout) {
        self.collectionView = collectionView
        self.duration = duration
        self.toLayout = toLayout
    }

    // MARK: - Public

    /// Starts the interactive layout transition and drives it to completion automatically.
    ///
    /// - Parameter completion: Called when the transition finishes successfully.
    open func startInteractiveTransition(completion: @escaping () -> Void) {
        guard let collectionView = collectionView else { return }

        // Disable interaction for the duration of the transition
        collectionView.isUserInteractionEnabled = false

        transitionLayout = collectionView.startInteractiveTransition(to: toLayout) { [weak self] success, finish in
            guard let self = self, success && finish else { return }
            self.collectionView?.contentOffset = self.toContentOffset
            self.collectionView?.reloadData()
            self.collectionView?.isUserInteractionEnabled = true
            completion()
        } as? CollectionViewTransitionLayout

        startTimer()
    }
}

// MARK: - Timer

private extension TransitionManager {

    func startTimer() {
        startTime = CACurrentMediaTime()
        let link = CADisplayLink(target: self, selector: #selector(updateTransitionProgress))
        if #available(iOS 15.0, *) {
            link.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 120, preferred: 120)
        } else {
            link.preferredFramesPerSecond = 60
        }
        link.add(to: .current, forMode: .common)
        timer = link
    }

    @objc func updateTransitionProgress() {
        guard let timer = timer else { return }

        var progress = (timer.timestamp - startTime) / duration
        progress = max(0, min(1, progress))

        transitionLayout?.transitionProgress = CGFloat(progress)
        transitionLayout?.invalidateLayout()

        if progress >= 1.0 {
            collectionView?.finishInteractiveTransition()
            timer.invalidate()
            self.timer = nil
        }
    }
}
