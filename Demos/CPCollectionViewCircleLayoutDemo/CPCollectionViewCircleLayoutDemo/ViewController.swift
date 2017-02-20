//
//  ViewController.swift
//  CPCollectionViewCircleLayoutDemo
//
//  Created by Parsifal on 2017/1/21.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    fileprivate let reuseIdentifier = "CPCollectionViewCell"
    var collectionView: UICollectionView!
    var colorsArray = [(item: Int, color: UIColor)]()
    var configuration: CPCircleLayoutConfiguration!
    var circleLayout: CPCollectionViewCircleLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        // load data
        for index in 0...8 {
            colorsArray.append((index,randomColor()))
        }
        
        // Becareful: If visibleCount==itemsCount reused system won't work!!!
        // Recommend: visibleCount<itemsCount
        // It's just a demo below
        configuration = CPCircleLayoutConfiguration(withCellSize: CGSize(width:60, height:60), spacing: 50, offsetX: 0, offsetY: 200)
        circleLayout = CPCollectionViewCircleLayout(withConfiguration: configuration)
        circleLayout.updateAnimationStyle = .custom
        collectionView = UICollectionView.init(frame: view.frame, collectionViewLayout:circleLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(CPCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
    }
    
    func randomColor() -> UIColor {
        return UIColor.init(colorLiteralRed: Float(arc4random_uniform(256))/255.0, green: Float(arc4random_uniform(256))/255.0, blue: Float(arc4random_uniform(256))/255.0, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CPCollectionViewCell
        cell.textLabel.backgroundColor = colorsArray[indexPath.item].color
        cell.textLabel.text = String(colorsArray[indexPath.item].item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.6,
                       options: .autoreverse,
                       animations: { 
                        cell.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }) { (true) in
            cell.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func insertTapped(_ sender: UIButton) {
        collectionView.contentOffset = collectionView.contentOffset

        let count = colorsArray.count
        colorsArray.append((count+1, randomColor()))
        collectionView.insertItems(at: [IndexPath.init(item: count, section: 0)])
        circleLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        guard colorsArray.count>0 else {
            return
        }
        
        collectionView.contentOffset = collectionView.contentOffset
        let index = circleLayout.currentIndex
        print(index)
        colorsArray.remove(at: index)
        collectionView.deleteItems(at: [IndexPath.init(item: index, section: 0)])
        circleLayout.invalidateLayout()
        collectionView.reloadData()
    }
}

