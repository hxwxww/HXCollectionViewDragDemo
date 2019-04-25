//
//  MainTableViewController.swift
//  HXCollectionViewDragDemo
//
//  Created by HongXiangWen on 2019/4/25.
//  Copyright © 2019年 WHX. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToCollectionViewVC" {
            if let cell = sender as? UITableViewCell {
                segue.destination.title = cell.textLabel?.text
            }
        }
    }
    
}
