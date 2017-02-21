//
//  ViewController.swift
//  CPCollectionViewStackLayoutTransitionDemo
//
//  Created by Parsifal on 2017/2/18.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

enum LayoutType {
    case flowLayout
    case stageLayout
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "CPCollectionViewCell"
    var dataArray = [(index: Int, color: UIColor)]()
    var flowLayout: UICollectionViewFlowLayout!
    var stageLayout: CPCollectionViewStageLayout!
    var currentLayoutType: LayoutType = .flowLayout

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data Array
        for index in 0...29 {
            dataArray.append((index, randomColor()))
        }
        
        //UI
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: view.bounds.width/3,
                                     height: view.bounds.width/3)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        let stageConfiguration = CPStageLayoutConfiguration.init(withCellSize: CGSize(width: 50, height: 50))
        stageLayout = CPCollectionViewStageLayout(withConfiguration: stageConfiguration)
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(Double(arc4random_uniform(256))/255.0),
                       green: CGFloat(Double(arc4random_uniform(256))/255.0),
                       blue: CGFloat(Double(arc4random_uniform(256))/255.0),
                       alpha: 1)
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = dataArray[indexPath.item].color
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = currentLayoutType == .flowLayout ? stageLayout : flowLayout
        collectionView.setCollectionViewLayout(layout, animated: true) { (_) in
            self.currentLayoutType = self.currentLayoutType == .flowLayout ? .stageLayout : .flowLayout
        }
    }
}
