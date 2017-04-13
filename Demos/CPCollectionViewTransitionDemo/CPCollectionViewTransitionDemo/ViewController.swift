//
//  ViewController.swift
//  CPCollectionViewTransitionDemo
//
//  Created by Parsifal on 2017/2/28.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "UITableViewCell"
    var fromLayout: UICollectionViewLayout!
    var toLayout: UICollectionViewLayout!
    var transitionViewController: UIViewController!
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    lazy var pickerView: UIPickerView = {
        var pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: 200))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    lazy var containerView: UIView = {
        var containerView = UIView(frame: CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: 200))
        containerView.addSubview(self.pickerView)
        let doneBtn = self.createBtn("Done")
        doneBtn.addTarget(self, action: #selector(ViewController.done), for: .touchUpInside)
        containerView.addSubview(doneBtn)
        
        let cancelBtn = self.createBtn("cancel")
        cancelBtn.frame.origin.x = self.screenWidth-80
        cancelBtn.addTarget(self, action: #selector(ViewController.cancel), for: .touchUpInside)
        containerView.addSubview(cancelBtn)
        return containerView
    }()
    
    var pickerViewDataSource = [String]()
    var selectedCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        fromLayout = createFlowLayout()
        toLayout = createStageLayout()
        pickerViewDataSource = ["UICollectionViewFlowLayout", "CollectionViewStageLayout", "CollectionViewTimeMachineLayout", "CollectionViewCircleLayout"]
    }

    func done() {
        showPickerView(false)
        
        if selectedCellIndex == 0 {
            fromLayout = layoutSelected()
        } else if selectedCellIndex == 1 {
            toLayout = layoutSelected()
        }
        
        tableView.reloadData()
    }
    
    func cancel() {
        showPickerView(false)
        tableView.reloadData()
    }
    
    func createBtn(_ title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        return btn
    }
    
    func showPickerView(_ show:Bool) {
        view.addSubview(containerView)
        if show {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -200)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.containerView.transform = CGAffineTransform.identity
            })
        }
    }
    
    func layoutSelected() -> UICollectionViewLayout {
        var layout: UICollectionViewLayout!
        
        switch pickerView.selectedRow(inComponent: 0) {
        case 0:
            layout = createFlowLayout()
        case 1:
            layout = createStageLayout()
        case 2:
            layout = createTimeMachineLayout()
        case 3:
            layout = createCircleLayout()
        default:
            layout = createFlowLayout()
        }
        
        return layout
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: view.bounds.width/3,
                                     height: view.bounds.width/3)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }
    
    func createStageLayout() -> CollectionViewStageLayout {
        let stageConfiguration = StageLayoutConfiguration(withCellSize: CGSize(width: 50, height: 50))
        let stageLayout = CollectionViewStageLayout(withConfiguration: stageConfiguration)
        return stageLayout
    }
    
    func createTimeMachineLayout() -> CollectionViewTimeMachineLayout {
        let configuration = TimeMachineLayoutConfiguration(withCellSize: CGSize(width: 200, height: 200))
        configuration.spacingX = 30
        configuration.spacingY = 30
        configuration.visibleCount = 20
        let timeMachineLayout = CollectionViewTimeMachineLayout(withConfiguration: configuration)
        return timeMachineLayout
    }
    
    func createCircleLayout() -> CollectionViewCircleLayout {
        let configuration = CircleLayoutConfiguration(withCellSize: CGSize(width: 50, height: 50), spacing: screenWidth/2-50, offsetX: 0, offsetY: screenHeight/2)
        let circleLayout = CollectionViewCircleLayout(withConfiguration: configuration)
        return circleLayout
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.text = "From:\(String(describing: fromLayout.classForCoder))"
        case 1:
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.text = "To:\(String(describing: toLayout.classForCoder))"
        default:
            cell.textLabel?.text = "GO!!"
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 2:
            transitionViewController = CPViewController.createViewController(fromLayout: fromLayout, toLayout: toLayout)
            present(transitionViewController, animated: true, completion: nil)
        default:
            pickerView.reloadAllComponents()
            showPickerView(true)
        }
        
        selectedCellIndex = indexPath.row
    }
    
}

extension ViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewDataSource.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewDataSource[row]
    }
    
}

