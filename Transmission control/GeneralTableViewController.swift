//
//  GeneralTableViewController.swift
//  Transmission control
//
//  Created by Mialin Valentin on 15.06.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit

class GeneralTableViewController: UITableViewController {

    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var downloadedLabel: UILabel!
    @IBOutlet var downloadSpeedLabel: UILabel!
    @IBOutlet var downLimitLabel: UILabel!
    @IBOutlet var seedsLabel: UILabel!
    
    var ids = 0
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.all
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
        
        // Along with auto layout, these are the keys for enabling variable cell height
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        update()
    }

    func update() {
        
        if !self.tableView.isEditing {
                TransmissionRequest().getTorrentInfo(ids: ids, completion: { torrentInfo in
                
                    self.statusLabel.text = String(torrentInfo.status)
                    self.downloadedLabel.text = TorrentViewController().formatBytes(byte: torrentInfo.downloadedEver)
                    self.downloadSpeedLabel.text = TorrentViewController().formatBytesInSecond(byte: torrentInfo.rateDownload)
                    
                    
                //update your table data here
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                }
            })
        }
    }

}
