//
//  ViewController.swift
//  CPCollectionViewCaterpillarLayoutDemo
//
//  Created by Parsifal on 2017/1/21.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    fileprivate let reuseIdentifier = "CPCollectionViewCell"
    var itemsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load data
        for item in 0...19 {
            itemsArray.append(String(item))
        }
        
        let cellSize = CGSize(width:60, height:60)
        let configuration = CaterpillarLayoutConfiguration(withCellSize: cellSize,
                                                           visibleCount: 8,
                                                           topCellSizeScale:1.5,
                                                           spacing: 150,
                                                           offsetX: 0,
                                                           offsetY: 100)
        let circleLayout = CollectionViewCaterpillarLayout(withConfiguration: configuration)
        
        let colletionView = UICollectionView.init(frame: view.frame, collectionViewLayout:circleLayout)
        colletionView.showsVerticalScrollIndicator = false
        colletionView.showsHorizontalScrollIndicator = false
        colletionView.backgroundColor = .white
        colletionView.register(CPCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        colletionView.dataSource = self
        colletionView.delegate = self
        view.addSubview(colletionView)
        view.sendSubview(toBack: colletionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CPCollectionViewCell
        cell.textLabel.text = itemsArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.4,
                       options: .autoreverse,
                       animations: {
                        cell.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }) { (true) in
            cell.transform = CGAffineTransform.identity
        }
    }
}

