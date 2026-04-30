//
//  LayoutConfiguration.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/1/22.
//  Copyright © 2017-2026 Parsifal. All rights reserved.
//

import UIKit

/// Base configuration class for all CPCollectionViewKit layouts.
///
/// Subclass this to add layout-specific parameters. The `cellSize`, `spacing`,
/// `offsetX`, and `offsetY` properties are available to all layouts.
open class LayoutConfiguration {

    // MARK: - Properties

    /// The size of each cell. Defaults to `(50, 50)` if an invalid value is set.
    public var cellSize: CGSize {
        didSet {
            if cellSize.width <= 0.0 || cellSize.height <= 0.0 {
                cellSize = CGSize(width: 50.0, height: 50.0)
            }
        }
    }

    /// The spacing between adjacent cells.
    public var spacing: CGFloat = 0

    /// A horizontal offset applied to each cell's center position.
    public var offsetX: CGFloat = 0

    /// A vertical offset applied to each cell's center position.
    public var offsetY: CGFloat = 0

    // MARK: - Init

    /// Creates a new configuration with the given cell size and optional spacing/offset values.
    public init(withCellSize cellSize: CGSize,
                spacing: CGFloat = 0.0,
                offsetX: CGFloat = 0.0,
                offsetY: CGFloat = 0.0) {
        self.cellSize = cellSize
        self.spacing = spacing
        self.offsetX = offsetX
        self.offsetY = offsetY
    }
}
