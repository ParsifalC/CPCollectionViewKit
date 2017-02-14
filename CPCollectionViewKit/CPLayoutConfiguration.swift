//
//  CPLayoutConfiguration.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/1/22.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit

open class CPLayoutConfiguration {
    
    // MARK: Properties
    public var cellSize:CGSize {
        didSet {
            if cellSize.width<=0.0 || cellSize.height<=0.0 {
                cellSize = CGSize.init(width: 50.0, height: 50.0)
            }
        }
    }
    
    public var fadeAway:Bool = true
    public var visibleCount:Int = 1
    public var spacing:CGFloat = 0
    public var offsetX:CGFloat = 0
    public var offsetY:CGFloat = 0
    
    // MARK: Methods
    public init(withCellSize cellSize:CGSize,
                visibleCount:Int,
                fadeAway:Bool = true,
                spacing:CGFloat = 0.0,
                offsetX:CGFloat = 0.0,
                offsetY:CGFloat = 0.0) {
        self.cellSize = cellSize
        self.visibleCount = visibleCount
        self.spacing = spacing
        self.offsetX = offsetX
        self.offsetY = offsetY
    }
}
