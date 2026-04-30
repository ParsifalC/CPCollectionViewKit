//
//  CollectionViewWheelLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2016/12/30.
//  Copyright © 2017-2026 Parsifal. All rights reserved.
//

import UIKit

/// Defines the anchor position of the wheel relative to the collection view.
public enum WheelLayoutType: Int {
    case leftBottom = 0
    case rightBottom
    case leftTop
    case rightTop
    case leftCenter
    case rightCenter
    case topCenter
    case bottomCenter
}

/// Configuration for `CollectionViewWheelLayout`.
public struct WheelLayoutConfiguration {

    /// The size of each cell. Minimum value is `(50, 50)`.
    public var cellSize: CGSize {
        didSet {
            if cellSize.width <= 0.0 || cellSize.height <= 0.0 {
                cellSize = CGSize(width: 50.0, height: 50.0)
            }
        }
    }

    /// The radius of the wheel arc in points. Must be > 0.
    public var radius: Double {
        didSet {
            if radius <= 0 { radius = 200.0 }
        }
    }

    /// The angular spacing (in degrees) between adjacent cells. Must be > 0.
    public var angular: Double {
        didSet {
            if angular <= 0 { angular = 20.0 }
        }
    }

    /// Whether cells fade out as they move away from the center of the arc.
    public var fadeAway: Bool

    /// Whether cells scale down as they move away from the center of the arc.
    public var zoomInOut: Bool

    /// Maximum scrollable content height (or width for horizontal wheels). `0` means auto.
    public var maxContentHeight: Double

    /// Additional padding added to the scroll content size.
    public var contentHeightPadding: Double

    /// Deprecated: use `contentHeightPadding` instead.
    @available(*, deprecated, renamed: "contentHeightPadding")
    public var contentHeigthPadding: Double {
        get { contentHeightPadding }
        set { contentHeightPadding = newValue }
    }

    /// The anchor position of the wheel.
    public var wheelType: WheelLayoutType

    // MARK: - Init

    public init(withCellSize cellSize: CGSize,
                radius: Double,
                angular: Double,
                wheelType: WheelLayoutType,
                zoomInOut: Bool = false,
                fadeAway: Bool = true,
                maxContentHeight: Double = 0.0,
                contentHeightPadding: Double = 0.0) {
        self.cellSize = cellSize
        self.radius = radius
        self.angular = angular
        self.wheelType = wheelType
        self.zoomInOut = zoomInOut
        self.fadeAway = fadeAway
        self.maxContentHeight = maxContentHeight
        self.contentHeightPadding = contentHeightPadding
    }
}

/// A `UICollectionViewLayout` subclass that arranges items along a wheel (arc) shape.
///
/// Supports 8 anchor positions and optional zoom/fade effects.
open class CollectionViewWheelLayout: CollectionViewLayout {

    // MARK: - Properties

    private var invisibleCellCount = 0.0
    open var configuration: WheelLayoutConfiguration

    // MARK: - Init

    public init(withConfiguration configuration: WheelLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.configuration = WheelLayoutConfiguration(withCellSize: CGSize(width: 50, height: 50),
                                                      radius: 100,
                                                      angular: 30,
                                                      wheelType: .leftBottom)
        super.init(coder: aDecoder)
    }

    // MARK: - UICollectionViewLayout

    override open func prepare() {
        super.prepare()

        guard let collectionView = collectionView, cellCount > 0 else { return }

        if configuration.wheelType == .bottomCenter || configuration.wheelType == .topCenter {
            invisibleCellCount = Double(collectionView.contentOffset.x / configuration.cellSize.width)
        } else {
            invisibleCellCount = Double(collectionView.contentOffset.y / configuration.cellSize.height)
        }
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView,
              let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return super.layoutAttributesForItem(at: indexPath)
        }

        let viewSize = collectionView.bounds.size
        let cellSize = configuration.cellSize
        let angular = configuration.angular
        let radius = configuration.radius
        let fadeAway = configuration.fadeAway
        let contentOffset = collectionView.contentOffset
        let visibleCellIndex = Double(indexPath.item) - invisibleCellCount
        var angle = angular / 90.0 * visibleCellIndex * Double.pi * 0.5
        let angleOffset = asin(Double(cellSize.width) / radius)

        var translation = CGAffineTransform.identity

        attributes.size = cellSize
        attributes.isHidden = true

        switch configuration.wheelType {
        case .leftBottom:
            attributes.center = CGPoint(x: contentOffset.x + cellSize.width / 2.0,
                                        y: contentOffset.y + viewSize.height - cellSize.height / 2)
            if angle <= (Double.pi * 0.5 + 2.0 * angleOffset + angular / 90.0) && angle >= -angleOffset {
                attributes.isHidden = false
                translation = CGAffineTransform(translationX: CGFloat(sin(angle) * radius),
                                                y: -(CGFloat(cos(angle) * radius) + cellSize.height / 2.0))
            }

        case .rightBottom:
            attributes.center = CGPoint(x: contentOffset.x + viewSize.width - cellSize.width / 2.0,
                                        y: contentOffset.y + viewSize.height - cellSize.height / 2)
            if angle <= (Double.pi * 0.5 + 2.0 * angleOffset + angular / 90.0) && angle >= -angleOffset {
                attributes.isHidden = false
                translation = CGAffineTransform(translationX: CGFloat(-sin(angle) * radius),
                                                y: -(CGFloat(cos(angle) * radius) + cellSize.height / 2.0))
            }

        case .leftTop:
            attributes.center = CGPoint(x: contentOffset.x + cellSize.width / 2.0,
                                        y: contentOffset.y)
            if angle <= (Double.pi * 0.5 + 2.0 * angleOffset + angular / 90.0) && angle >= -angleOffset {
                attributes.isHidden = false
                translation = CGAffineTransform(translationX: CGFloat(cos(angle) * radius),
                                                y: (CGFloat(sin(angle) * radius) + cellSize.height / 2.0))
            }

        case .rightTop:
            attributes.center = CGPoint(x: contentOffset.x + viewSize.width - cellSize.width / 2.0,
                                        y: contentOffset.y)
            if angle <= (Double.pi * 0.5 + 2.0 * angleOffset + angular / 90.0) && angle >= -angleOffset {
                attributes.isHidden = false
                translation = CGAffineTransform(translationX: CGFloat(-cos(angle) * radius),
                                                y: (CGFloat(sin(angle) * radius) + cellSize.height / 2.0))
            }

        case .leftCenter:
            attributes.center = CGPoint(x: contentOffset.x + cellSize.width / 2.0,
                                        y: contentOffset.y + viewSize.height / 2)
            angle = visibleCellIndex * angular / 180 * Double.pi
            if angle <= (Double.pi + 2.0 * angleOffset + angular / 180.0) && angle >= -angleOffset {
                attributes.isHidden = false
                translation = CGAffineTransform(translationX: CGFloat(sin(angle) * radius),
                                                y: -CGFloat(cos(angle) * radius))
            }

        case .rightCenter:
            attributes.center = CGPoint(x: contentOffset.x + viewSize.width - cellSize.width / 2.0,
                                        y: contentOffset.y + viewSize.height / 2)
            if angle <= (Double.pi + 2.0 * angleOffset + angular / 180.0) && angle >= -angleOffset {
                attributes.isHidden = false
                translation = CGAffineTransform(translationX: -CGFloat(sin(angle) * radius),
                                                y: -CGFloat(cos(angle) * radius))
            }

        case .topCenter:
            attributes.center = CGPoint(x: contentOffset.x + viewSize.width / 2.0,
                                        y: contentOffset.y + cellSize.height / 2)
            angle = visibleCellIndex * angular / 180 * Double.pi
            if angle <= (Double.pi + 2.0 * angleOffset + angular / 180.0) && angle >= -angleOffset {
                attributes.isHidden = false
                translation = CGAffineTransform(translationX: -CGFloat(cos(angle) * radius),
                                                y: CGFloat(sin(angle) * radius))
            }

        case .bottomCenter:
            attributes.center = CGPoint(x: contentOffset.x + viewSize.width / 2.0,
                                        y: contentOffset.y + viewSize.height - cellSize.height / 2)
            angle = visibleCellIndex * angular / 180 * Double.pi
            if angle <= (Double.pi + 2.0 * angleOffset + angular / 180.0) && angle >= -angleOffset {
                attributes.isHidden = false
                translation = CGAffineTransform(translationX: -CGFloat(cos(angle) * radius),
                                                y: -CGFloat(sin(angle) * radius))
            }
        }

        attributes.transform = translation

        let fadeFactor: Double
        switch configuration.wheelType {
        case .bottomCenter, .topCenter, .rightCenter, .leftCenter:
            fadeFactor = 1 - abs(angle - Double.pi * 0.5) * 0.5
        default:
            fadeFactor = 1 - abs(angle - Double.pi / 4)
        }

        attributes.alpha = CGFloat(fadeAway ? fadeFactor : 1.0)

        if configuration.zoomInOut {
            attributes.size = CGSize(width: cellSize.width * CGFloat(fadeFactor),
                                     height: cellSize.height * CGFloat(fadeFactor))
        } else {
            attributes.size = cellSize
        }

        return attributes
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var mutableAttributes = [UICollectionViewLayoutAttributes]()

        for index in 0..<cellCount {
            if let attributes = layoutAttributesForItem(at: IndexPath(item: index, section: 0)),
               rect.contains(attributes.frame) || rect.intersects(attributes.frame) {
                mutableAttributes.append(attributes)
            }
        }

        return mutableAttributes
    }

    override open var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }

        let viewSize = collectionView.bounds.size
        let visibleCellCount: CGFloat
        let contentSize: CGSize

        switch configuration.wheelType {
        case .bottomCenter, .topCenter:
            visibleCellCount = CGFloat(180.0 / configuration.angular + 1.0)
            contentSize = CGSize(
                width: viewSize.width
                    + (CGFloat(cellCount) - visibleCellCount) * configuration.cellSize.width
                    + CGFloat(configuration.contentHeightPadding),
                height: viewSize.height
            )
        case .rightCenter, .leftCenter:
            visibleCellCount = CGFloat(180.0 / configuration.angular + 1.0)
            contentSize = CGSize(
                width: viewSize.width,
                height: viewSize.height
                    + (CGFloat(cellCount) - visibleCellCount) * configuration.cellSize.height
                    + CGFloat(configuration.contentHeightPadding)
            )
        default:
            visibleCellCount = CGFloat(90.0 / configuration.angular + 1.0)
            contentSize = CGSize(
                width: viewSize.width,
                height: viewSize.height
                    + (CGFloat(cellCount) - visibleCellCount) * configuration.cellSize.height
                    + CGFloat(configuration.contentHeightPadding)
            )
        }

        return contentSize
    }
}
