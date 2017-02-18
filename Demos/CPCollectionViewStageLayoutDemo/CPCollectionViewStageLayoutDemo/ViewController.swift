//
//  ViewController.swift
//  CPCollectionViewStageLayoutDemo
//
//  Created by Parsifal on 2017/2/17.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class ViewController: UIViewController {

    let cellIdentifier = "CPCollectionViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var colorsArray = [UIColor]()
    var stageLayout: CPCollectionViewStageLayout!
    var configuration: CPStageLayoutConfiguration!

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...19 {
            colorsArray.append(randomColor())
        }
        
        stageLayout = collectionView.collectionViewLayout as! CPCollectionViewStageLayout
        configuration = stageLayout.configuration
        configuration.moveAnimationStyle = .somefault
        configuration.leaveStageAnimationStyle = .fadeAwayAndZoomin
        configuration.cellSize = CGSize(width: 50, height: 50)
        configuration.topCellSize = CGSize(width: collectionView.bounds.width*0.75,
                                           height: collectionView.bounds.width*0.75)
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
        cell.backgroundColor = colorsArray[indexPath.item]
        cell.label.text = "\(indexPath.item)"
        return cell
    }
    
}

