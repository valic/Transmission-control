//
//  TorrentViewController.swift
//  Transmission control
//
//  Created by Mialin Valentin on 14.06.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit

class TorrentViewController: UITableViewController {
    
    var timer:Timer?
    let transmissionRequest = TransmissionRequest()
    var getTorrent : [torrent] = []
    var errorRequest: NSError?
    let statusCode:[Int:String] = [0: "STOPPED", 1: "CHECK_WAIT", 2: "CHECK", 3: "DOWNLOAD_WAIT", 4: "DOWNLOAD", 5: "SEED_WAIT", 6: "SEED", 7: "ISOLATED"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // запускаем автоообновление
        update()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(TorrentViewController.update), userInfo: nil, repeats: true)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getTorrent.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let torrent = getTorrent[indexPath.row]
        
        switch torrent.status {
        case 4:
            return 150.0
        case 6:
            return 45.0
        default:
            break
        }
        return 45.0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        getTorrent = getTorrent.sorted(by: { $0.queuePosition < $1.queuePosition })
        let torrent = getTorrent[indexPath.row]

        switch torrent.status {
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "downloadCell", for: indexPath) as! downloadViewCell
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: "seedCell", for: indexPath) as! TorrentViewCell
        default:
            break
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func update() {
        
        if !self.tableView.isEditing {
            
            //     var sections : [Section] = []
            
            transmissionRequest.torrentGet(completion: { (torrent : [torrent]?, error: NSError?) in
                if let torrent = torrent {
                    self.getTorrent = torrent
                }
                self.errorRequest = error
                
                
                //update your table data here
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                }
            })
        }
    }

}
