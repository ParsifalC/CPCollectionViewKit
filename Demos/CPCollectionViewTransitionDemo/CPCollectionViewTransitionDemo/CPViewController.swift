//
//  CPViewController.swift
//  CPCollectionViewTransitionDemo
//
//  Created by Parsifal on 2017/2/28.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class CPViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "CPCollectionViewCell"
    var dataArray = [(index: Int, color: UIColor)]()
    var fromLayout: UICollectionViewLayout!
    var toLayout: UICollectionViewLayout!
    var transitionManager: TransitionManager!
    var fromContentOffset = CGPoint(x: 0, y: 0)
    var toContentOffset = CGPoint(x: 0, y: 0)
    
    static func createViewController(fromLayout: UICollectionViewLayout, toLayout: UICollectionViewLayout) -> CPViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let transitionViewController = sb.instantiateViewController(withIdentifier: "CPViewController") as!
        CPViewController
        transitionViewController.fromLayout = fromLayout
        transitionViewController.toLayout = toLayout
        return transitionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data Array
        for index in 0...19 {
            dataArray.append((index, randomColor()))
        }
        
        collectionView.setCollectionViewLayout(fromLayout, animated: false, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(Double(arc4random_uniform(256))/255.0),
                       green: CGFloat(Double(arc4random_uniform(256))/255.0),
                       blue: CGFloat(Double(arc4random_uniform(256))/255.0),
                       alpha: 1)
    }
    
}

extension CPViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = dataArray[indexPath.item].color
        
        return cell
    }
    
}

extension CPViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fromContentOffset = collectionView.contentOffset

        if toLayout is CPCollectionViewStageLayout {
            toContentOffset = (toLayout as! CPCollectionViewStageLayout).contentOffsetFor(indexPath: indexPath)
        } else if toLayout is UICollectionViewFlowLayout {
            let cellSize = (toLayout as! UICollectionViewFlowLayout).itemSize
            let y = floor(CGFloat(indexPath.item) / 3.0) * cellSize.height
            toContentOffset = CGPoint(x: 0, y: min(fabs(toLayout.collectionViewContentSize.height-collectionView.bounds.height), y))
        }
        
        transitionManager = TransitionManager(duration: 0.6, collectionView: collectionView, toLayout: toLayout)
        
        transitionManager.startInteractiveTransition {
            self.collectionView.contentOffset = self.toContentOffset
            self.toLayout = self.fromLayout
            self.fromLayout = self.collectionView.collectionViewLayout
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = CPCollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        customTransitionLayout.fromContentOffset = fromContentOffset
        customTransitionLayout.toContentOffset = toContentOffset
        return customTransitionLayout
    }
    
}
