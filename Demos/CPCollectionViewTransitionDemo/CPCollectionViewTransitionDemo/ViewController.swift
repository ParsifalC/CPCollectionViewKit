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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowCellSize = CGSize(width: view.bounds.width/3,
                                 height: view.bounds.width/3)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = flowCellSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        fromLayout = flowLayout
        
        let stageConfiguration = CPStageLayoutConfiguration.init(withCellSize: CGSize(width: 50, height: 50))
        let stageLayout = CPCollectionViewStageLayout(withConfiguration: stageConfiguration)
        toLayout = stageLayout
        transitionViewController = CPViewController.createViewController(fromLayout: fromLayout, toLayout: toLayout)
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
            cell.textLabel?.text = "from:\(String(describing: fromLayout.classForCoder))"
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
        case 0:
            print(indexPath.row)
        case 1:
            print(indexPath.row)
        default:
            self.present(transitionViewController, animated: true, completion: {    
            })
        }
    }
    
}
