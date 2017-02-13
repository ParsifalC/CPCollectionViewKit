//
//  CPColletionViewCell.swift
//  CPCollectionViewWheelLayout-Swift
//
//  Created by Parsifal on 2016/12/29.
//  Copyright © 2016年 Parsifal. All rights reserved.
//

import UIKit

class CPCollectionViewCell: UICollectionViewCell {
    
    // MARK:- Public Properties
    public var textLabel:UILabel!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private Methods
    fileprivate func setupViews(frame:CGRect) {
        contentView.backgroundColor = .yellow
        contentView.layer.masksToBounds = true
        let labelFrame = CGRect(x:0, y:0, width:frame.width, height:frame.height)
        textLabel = UILabel.init(frame: labelFrame)
        textLabel.font = .systemFont(ofSize: 20)
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = frame.width/2
        textLabel.frame = CGRect(x:0, y:0, width:frame.width, height:frame.height)
    }
    
}
