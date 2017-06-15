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
        

        // Along with auto layout, these are the keys for enabling variable cell height
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
        
        
        if torrent.error == 3 {
            
            return UITableViewAutomaticDimension
        }
        
        switch torrent.status {
        case 0,1,2:
            return 80.0
        case 3,4:
            return 140.0
        case 5,6:
            return 100.0
        default:
            break
        }
        return 100.0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let torrent = getTorrent[indexPath.row]
        
        switch torrent.error {
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath) as! ErrorViewCell
            
            cell.torrentNameLabel!.text = torrent.name
            cell.torrentProgressView.progress = torrent.percentDone
            cell.torrentProgress!.text = "\(formatBytes(byte: torrent.downloadedEver)) of \(formatBytes(byte: torrent.sizeWhenDone))"
            cell.percentDoneLabel!.text = "\(Int(torrent.percentDone * 100)) %"
            
            cell.errorStringLabel.text = torrent.errorString
            
            return cell
        default:
            break
        }

        switch torrent.status {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "stopCell", for: indexPath) as! StopViewCell
            cell.torrentNameLabel!.text = torrent.name
            cell.torrentProgressView.progress = torrent.percentDone
            cell.torrentProgress!.text = "\(formatBytes(byte: torrent.downloadedEver)) of \(formatBytes(byte: torrent.sizeWhenDone))"
            cell.percentDoneLabel!.text = "\(Int(torrent.percentDone * 100)) %"
            return cell
        
        case 1,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckViewCell
            
            cell.statusLabel!.text = torrent.status == 1 ? "CHECK_WAIT" : "CHECK"
                       
            cell.torrentNameLabel!.text = torrent.name
            cell.recheckProgressView.progress = torrent.recheckProgress
            cell.recheckProgress.text = "\(Int(torrent.recheckProgress * 100)) %"
            return cell
        case 3,4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "downloadCell", for: indexPath) as! DownloadViewCell
            
            cell.statusLabel!.text = torrent.status == 3 ? "DOWNLOAD_WAIT" : "DOWNLOAD"
            
            cell.torrentNameLabel!.text = torrent.name
            cell.torrentProgressView.progress = torrent.percentDone
            cell.torrentProgress!.text = "\(formatBytes(byte: torrent.downloadedEver)) of \(formatBytes(byte: torrent.sizeWhenDone))"
            cell.percentDoneLabel!.text = "\(Int(torrent.percentDone * 100)) %"
            
            if torrent.eta >= 0 {
                cell.etaImageView.image = #imageLiteral(resourceName: "ClockBlue")
                cell.etaSpeedLabel.text = secondToString(second: torrent.eta)
                cell.etaSpeedLabel.textColor = UIColor.black.withAlphaComponent(0.85)
            }
            else{
                cell.etaImageView.image = #imageLiteral(resourceName: "ClockGrey")
                cell.etaSpeedLabel.text = "∞"
                cell.etaSpeedLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            }
            
            if torrent.rateDownload > 0 {
                cell.downloadImageView.image = #imageLiteral(resourceName: "downloadBlue")
                cell.downSpeedLabel!.text = formatBytesInSecond(byte: torrent.rateDownload)
                cell.downSpeedLabel.textColor = UIColor.black.withAlphaComponent(0.85)
            }
            else{
                cell.downloadImageView.image = #imageLiteral(resourceName: "downloadGrey")
                cell.downSpeedLabel!.text = formatBytesInSecond(byte: torrent.rateDownload)
                cell.downSpeedLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            }
            
            if torrent.rateUpload > 0 {
                cell.uploadImageView.image = #imageLiteral(resourceName: "uploadBlue")
                cell.upSpeedLabel!.text = formatBytesInSecond(byte: torrent.rateUpload)
                cell.upSpeedLabel.textColor = UIColor.black.withAlphaComponent(0.85)
            }
            else{
                cell.uploadImageView.image = #imageLiteral(resourceName: "uploadGrey")
                cell.upSpeedLabel!.text = formatBytesInSecond(byte: torrent.rateUpload)
                cell.upSpeedLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            }
            
    
            return cell
        case 5,6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "seedCell", for: indexPath) as! SeedViewCell
            
            cell.statusLabel!.text = torrent.status == 5 ? "SEED_WAIT" : "SEED"
            
            cell.torrentNameLabel!.text = torrent.name
            cell.torrentProgressView.progress = torrent.percentDone
            if torrent.totalSize == torrent.sizeWhenDone {
                cell.torrentProgress.text = formatBytes(byte: torrent.totalSize)
            }
            else{
                cell.torrentProgress.text = "\(formatBytes(byte: torrent.sizeWhenDone)) of \(formatBytes(byte: torrent.totalSize))"
            }
            cell.percentDoneLabel!.text = "\(Int(torrent.percentDone * 100)) %"
            cell.ratioLabel!.text = String(torrent.uploadRatio)
            if torrent.rateUpload > 0 {
                cell.uploadImageView.image = #imageLiteral(resourceName: "uploadBlue")
                cell.upSpeedLabel!.text = formatBytesInSecond(byte: torrent.rateUpload)
                cell.upSpeedLabel.textColor = UIColor.black.withAlphaComponent(0.85)
            }
            else{
                cell.uploadImageView.image = #imageLiteral(resourceName: "uploadGrey")
                cell.upSpeedLabel!.text = formatBytesInSecond(byte: torrent.rateUpload)
                cell.upSpeedLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            }
            
            return cell
        default:
            break
        }

        return UITableViewCell()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let torrent = self.getTorrent[editActionsForRowAt.row]
        
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = .lightGray
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.deleteTorrent(torrent: torrent)
        }
        delete.backgroundColor = .red
        
        var startStopTorrent: UITableViewRowAction
        
        switch self.getTorrent[editActionsForRowAt.row].status {
        case 0:
            startStopTorrent = UITableViewRowAction(style: .normal, title: "Start") { action, index in
                self.transmissionRequest.startTorrent(id: torrent.id)
                self.tableView.isEditing=false
                self.update()
            }
            startStopTorrent.backgroundColor = .green
            
        default:
            startStopTorrent = UITableViewRowAction(style: .normal, title: "Stop") { action, index in
                self.transmissionRequest.stopTorrent(id: torrent.id)
                self.tableView.isEditing=false
                self.update()
            }
            startStopTorrent.backgroundColor = .orange
        }
        return [startStopTorrent, delete, more]
    }
    
    func deleteTorrent(torrent: torrent)  {
        
        let alertController = UIAlertController(title: "Delete torrent", message: "", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
            self.transmissionRequest.deleteTorrent(id: torrent.id)
            self.tableView.isEditing=false
            self.update()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            self.tableView.isEditing=false
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        self.performSegue(withIdentifier: "torrentSegue", sender: self)
    }
 

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
                if var torrent = torrent {
                    torrent = torrent.sorted(by: { $0.queuePosition < $1.queuePosition })
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
    
    func formatBytes(byte: Int) -> String {
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useAll
        formatter.countStyle = ByteCountFormatter.CountStyle.file
        formatter.allowsNonnumericFormatting = false
        
        return (formatter.string(fromByteCount: Int64(Int(byte))) )
    }
    
    func formatBytesInSecond(byte: Int) -> String {
        return formatBytes(byte: byte) + "/s"
    }
    
    func secondToString(second: Int) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: TimeInterval(second))!
        
    }

}
