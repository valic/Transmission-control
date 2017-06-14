//
//  TorrentViewCell.swift
//  Transmission control
//
//  Created by Mialin Valentin on 14.06.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit

class TorrentViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  

}

class downloadViewCell: UITableViewCell {
    
    @IBOutlet var downloadBackGroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        contentView.backgroundColor = UIColor.white
        downloadBackGroundView.backgroundColor = UIColor.white
        downloadBackGroundView.layer.cornerRadius = 3.0
        downloadBackGroundView.layer.masksToBounds = false
        
        downloadBackGroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        downloadBackGroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        downloadBackGroundView.layer.shadowOpacity = 0.8
 */
    }
    
}
