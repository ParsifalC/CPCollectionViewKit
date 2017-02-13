//
//  CPTableViewController.swift
//  CPCollectionViewWheelLayout-Swift
//
//  Created by Parsifal on 2017/1/7.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class CPTableViewController:UITableViewController {
    let wheelTypes = ["leftBottom", "rightBottom",
                      "leftTop", "rightTop",
                      "leftCenter", "rightCenter",
                      "topCenter", "bottomCenter"]
    var selectType = CPWheelLayoutType.leftBottom
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",
                                             for: indexPath)
        cell.textLabel?.text = wheelTypes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wheelTypes.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        let vc = segue.destination as! CPViewController
        vc.wheelType = CPWheelLayoutType(rawValue: (indexPath?.row)!)!
    }
}
