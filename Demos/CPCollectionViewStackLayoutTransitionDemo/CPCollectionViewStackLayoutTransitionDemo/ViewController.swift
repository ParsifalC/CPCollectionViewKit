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
    var circleLayout: CPCollectionViewCircleLayout!
    var currentLayoutType: LayoutType = .flowLayout
    var transitionManager: TransitionManager!
    var flowCellSize: CGSize!
    var fromContentOffset = CGPoint(x: 0, y: 0)
    var toContentOffset = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data Array
        for index in 0...19 {
            dataArray.append((index, randomColor()))
        }
        
        flowCellSize = CGSize(width: view.bounds.width/3,
                              height: view.bounds.width/3)
        
        //UI
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = flowCellSize
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
        var layout: UICollectionViewLayout = stageLayout
        var layoutType = LayoutType.stageLayout
        toContentOffset = stageLayout.contentOffsetFor(indexPath: indexPath)
        fromContentOffset = collectionView.contentOffset
        
        if currentLayoutType == .stageLayout {
            layout = flowLayout
            layoutType = .flowLayout
            let y = floor(CGFloat(indexPath.item) / 3.0) * flowCellSize.height
            toContentOffset = CGPoint(x: 0, y: min(flowLayout.collectionViewContentSize.height-collectionView.bounds.height, y))
        }

        transitionManager = TransitionManager(duration: 1, collectionView: collectionView, toLayout: layout)
        
        transitionManager.startInteractiveTransition {
            self.collectionView.contentOffset = self.toContentOffset
            self.currentLayoutType = layoutType
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = CPCollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        customTransitionLayout.fromContentOffset = fromContentOffset
        customTransitionLayout.toContentOffset = toContentOffset
        return customTransitionLayout
    }
    
}
