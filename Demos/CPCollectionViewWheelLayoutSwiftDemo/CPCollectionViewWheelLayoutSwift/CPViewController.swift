//
//  CPViewController.swift
//  CollectionViewWheelLayout-Swift
//
//  Created by Parsifal on 2016/12/29.
//  Copyright © 2016年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class CPViewController: UIViewController, UICollectionViewDataSource {
    
    fileprivate let reuseIdentifier = "CPCollectionViewCell"
    var colletionView:UICollectionView!
    var itemsArray = [String]()
    
    open var wheelType = WheelLayoutType.leftBottom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load data
        for item in 0...20 {
            itemsArray.append(String(item))
        }
        
        // setup views
        let configuration = WheelLayoutConfiguration.init(withCellSize: CGSize.init(width: 100, height: 100), radius: 200, angular: 20, wheelType:wheelType)
        let wheelLayout = CollectionViewWheelLayout.init(withConfiguration: configuration)
        colletionView = UICollectionView.init(frame: view.frame, collectionViewLayout:wheelLayout)
        colletionView.showsVerticalScrollIndicator = false
        colletionView.showsHorizontalScrollIndicator = false
        colletionView.backgroundColor = .white
        colletionView.register(CPCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        colletionView.dataSource = self
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
    
    @IBAction func cellSizeChanged(_ sender: UISlider) {
        var configuration = (colletionView.collectionViewLayout as! CollectionViewWheelLayout).configuration
        configuration.cellSize = CGSize.init(width: Double(sender.value), height: Double(sender.value))
        updateCollectionView(withLayoutConfiguration: configuration)
    }

    @IBAction func angularViewChanged(_ sender: UISlider) {
        var configuration = (colletionView.collectionViewLayout as! CollectionViewWheelLayout).configuration
        configuration.angular = Double(sender.value)
        updateCollectionView(withLayoutConfiguration: configuration)
    }
    
    @IBAction func radiusValueChanged(_ sender: UISlider) {
        var configuration = (colletionView.collectionViewLayout as! CollectionViewWheelLayout).configuration
        configuration.radius = Double(sender.value)
        updateCollectionView(withLayoutConfiguration: configuration)
    }
    
    func updateCollectionView(withLayoutConfiguration configuration:WheelLayoutConfiguration) {
        let newLayout = CollectionViewWheelLayout.init(withConfiguration: configuration)
        colletionView.collectionViewLayout.invalidateLayout()
        colletionView.collectionViewLayout = newLayout
        colletionView.reloadData()
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
}
