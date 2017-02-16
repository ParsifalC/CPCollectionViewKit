//
//  ViewController.swift
//  CPCollectionViewTimeMachineLayoutDemo
//
//  Created by Parsifal on 2017/2/15.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class ViewController: UIViewController {

    let cellIdentifier = "CPCollectionViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var timeMachineLayout: CPCollectionViewTimeMachineLayout!
    var layoutConfiguration: CPTimeMachineLayoutConfiguration!
    var colorsArray = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...19 {
            colorsArray.append(randomColor())
        }
        
        timeMachineLayout = collectionView.collectionViewLayout as! CPCollectionViewTimeMachineLayout
        layoutConfiguration = timeMachineLayout.configuration
        layoutConfiguration.cellSize = CGSize(width: 250, height: 250)
        layoutConfiguration.visibleCount = 6
        layoutConfiguration.scaleFactor = 0.8
        layoutConfiguration.spacingX = 0
        layoutConfiguration.spacingY = -30
    }

    func randomColor() -> UIColor {
        return UIColor.init(colorLiteralRed: Float(arc4random_uniform(256))/255.0, green: Float(arc4random_uniform(256))/255.0, blue: Float(arc4random_uniform(256))/255.0, alpha: 1)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CPCollectionViewCell
        cell.label.text = "\(indexPath.item)"
        cell.backgroundColor = colorsArray[indexPath.item]
        return cell
    }
    
}
