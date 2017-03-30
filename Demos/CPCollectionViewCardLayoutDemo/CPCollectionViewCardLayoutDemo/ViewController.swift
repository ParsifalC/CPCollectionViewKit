//
//  ViewController.swift
//  CPCollectionViewCardLayoutDemo
//
//  Created by Parsifal on 2017/2/13.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class ViewController: UIViewController {
    
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var scrollDirectionControl: UISegmentedControl!
    @IBOutlet weak var rotateDicretionControl: UISegmentedControl!
    @IBOutlet weak var stopAtBoundarySwitch: UISwitch!
    @IBOutlet weak var fadeFactorSlider: UISlider!
    @IBOutlet weak var rotateFactorSlider: UISlider!
    @IBOutlet weak var scaleFactorXSlider: UISlider!
    @IBOutlet weak var scaleFactorYSlider: UISlider!
    @IBOutlet weak var cellSizeSlider: UISlider!
    @IBOutlet weak var spacingSlider: UISlider!
    @IBOutlet weak var offsetXSlider: UISlider!
    @IBOutlet weak var offsetYSlider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    var configuration: CardLayoutConfiguration!
    var layout: CollectionViewCardLayout!
    let identifier = "CPCardCollectionViewCell"
    var colorsArray = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...19 {
            colorsArray.append(randomColor())
        }
        
        settingView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        settingView.isHidden = true
        
        fadeFactorSlider.minimumValue = 0.0
        fadeFactorSlider.maximumValue = 1.0
        fadeFactorSlider.value = 0.3
        
        rotateFactorSlider.minimumValue = 0
        rotateFactorSlider.maximumValue = Float(M_PI*2.0)
        rotateFactorSlider.value = Float(M_PI_4)
        
        scaleFactorXSlider.minimumValue = 0
        scaleFactorXSlider.maximumValue = 1.0
        scaleFactorXSlider.value = 0.6
        scaleFactorYSlider.minimumValue = 0
        scaleFactorYSlider.maximumValue = 1.0
        scaleFactorYSlider.value = 0.6
        
        cellSizeSlider.minimumValue = 0.1
        cellSizeSlider.maximumValue = 1.0
        cellSizeSlider.value = 1
        
        spacingSlider.minimumValue = 0
        spacingSlider.maximumValue = 100
        spacingSlider.value = 0
        
        offsetXSlider.minimumValue = 0
        offsetXSlider.maximumValue = 100
        offsetXSlider.value = 0
        offsetYSlider.minimumValue = 0
        offsetYSlider.maximumValue = 100
        offsetYSlider.value = 0
        
        layout = collectionView.collectionViewLayout as! CollectionViewCardLayout
        layout.updateAnimationStyle = .custom
        configuration = layout.configuration
        configuration.stopAtItemBoundary = stopAtBoundarySwitch.isOn
        configuration.spacing = CGFloat(spacingSlider.value)
        configuration.offsetX = CGFloat(offsetXSlider.value)
        configuration.fadeFactor = CGFloat(fadeFactorSlider.value)
        configuration.scaleFactorX = CGFloat(scaleFactorXSlider.value)
        configuration.scaleFactorY = CGFloat(scaleFactorYSlider.value)
        configuration.rotateFactor = CGFloat(rotateFactorSlider.value)
        configuration.rotateDirection = rotateDirection()
        configuration.scrollDirection = scrollDirection()
        configuration.cellSize =
            CGSize(width: collectionView.bounds.size.width*CGFloat(cellSizeSlider.value),
                   height: collectionView.bounds.size.height*CGFloat(cellSizeSlider.value))
    }
    
    func randomColor() -> UIColor {
        return UIColor.init(colorLiteralRed: Float(arc4random_uniform(256))/255.0, green: Float(arc4random_uniform(256))/255.0, blue: Float(arc4random_uniform(256))/255.0, alpha: 1)
    }
    
    func rotateDirection() -> CardRotationAxis {
        switch rotateDicretionControl.selectedSegmentIndex {
        case 0:
            return .x
        case 1:
            return .y
        default:
            return .z
        }
    }
    
    func scrollDirection() -> CardScrollDiretion {
        switch scrollDirectionControl.selectedSegmentIndex {
        case 0:
            return .horizontal
        default:
            return .vertical
        }
    }
    
    func updateLayout(closure:() -> Void) {
        layout.invalidateLayout()
        closure()
        collectionView.reloadData()
    }
    
    @IBAction func scrollDirectionChanged(_ sender: UISegmentedControl) {
        updateLayout {
            configuration.scrollDirection = scrollDirection()
        }
    }
    
    @IBAction func rotateDirectionChanged(_ sender: UISegmentedControl) {
        updateLayout {
            configuration.rotateDirection = rotateDirection()
        }
    }
    
    @IBAction func stopAtBoundaryChanged(_ sender: UISwitch) {
        updateLayout {
            configuration.stopAtItemBoundary = sender.isOn
        }
    }
    
    @IBAction func fadeFactorChanged(_ sender: UISlider) {
        updateLayout {
            configuration.fadeFactor = CGFloat(sender.value)
        }
    }
    
    @IBAction func rotateFactorChanged(_ sender: UISlider) {
        updateLayout {
            configuration.rotateFactor = CGFloat(sender.value)
        }
    }
    
    @IBAction func scaleFactorXChanged(_ sender: UISlider) {
        updateLayout {
            configuration.scaleFactorX = CGFloat(sender.value)
        }
    }
    
    @IBAction func scaleFactorYChanged(_ sender: UISlider) {
        updateLayout {
            configuration.scaleFactorY = CGFloat(sender.value)
        }
    }
    
    @IBAction func cellSizeChanged(_ sender: UISlider) {
        updateLayout {
            configuration.cellSize =
                CGSize(width: collectionView.bounds.size.width*CGFloat(sender.value),
                       height: collectionView.bounds.size.height*CGFloat(sender.value))
        }
    }
    
    @IBAction func spacingChanged(_ sender: UISlider) {
        updateLayout {
            configuration.spacing = CGFloat(sender.value)
        }
    }
    
    @IBAction func offsetXChanged(_ sender: UISlider) {
        updateLayout {
            configuration.offsetX = CGFloat(sender.value)
        }
    }
    
    @IBAction func offsetYChanged(_ sender: UISlider) {
        updateLayout {
            configuration.offsetY = CGFloat(sender.value)
        }
    }
    
    @IBAction func settingTapped(_ sender: UIButton) {
        settingView.isHidden = false
        UIView.animate(withDuration: 0.3,
                       animations: { 
                        self.settingView.transform = CGAffineTransform.identity
        }) { (_) in
        }
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.settingView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (_) in
            self.settingView.isHidden = true
        }
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        let index = layout.currentIndex
        guard index<colorsArray.count else { return }
        colorsArray.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
//        print("currentIndex:\(layout.currentIndex)")
    }
    
    @IBAction func insertTapped(_ sender: UIButton) {
        let index = layout.currentIndex
        guard index<colorsArray.count else { return }
        colorsArray.insert(randomColor(), at: index)
        collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CPCardCollectionViewCell", for: indexPath) as! CPCardCollectionViewCell
        cell.label.text = ""
        cell.backgroundColor = colorsArray[indexPath.item]
        print(indexPath)
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectItem:\(indexPath.item)")
    }
}

