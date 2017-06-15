//
//  TorrentViewCell.swift
//  Transmission control
//
//  Created by Mialin Valentin on 14.06.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit

class StopViewCell: UITableViewCell {
    
    @IBOutlet var torrentNameLabel: UILabel!
    
    @IBOutlet var torrentProgressView: UIProgressView!
    @IBOutlet var torrentProgress: UILabel!
    @IBOutlet var percentDoneLabel: UILabel!
}

class CheckViewCell: UITableViewCell {
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var torrentNameLabel: UILabel!
    
    @IBOutlet var recheckProgressView: UIProgressView!
    @IBOutlet var recheckProgress: UILabel!
}

class DownloadViewCell: UITableViewCell {
    
    @IBOutlet var downloadBackGroundView: UIView!
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var torrentNameLabel: UILabel!
    
    @IBOutlet var torrentProgressView: UIProgressView!
    @IBOutlet var torrentProgress: UILabel!
    @IBOutlet var percentDoneLabel: UILabel!
    
    @IBOutlet var etaImageView: UIImageView!
    @IBOutlet var downloadImageView: UIImageView!
    @IBOutlet var uploadImageView: UIImageView!
    
    @IBOutlet var etaSpeedLabel: UILabel!
    @IBOutlet var downSpeedLabel: UILabel!
    @IBOutlet var upSpeedLabel: UILabel!
    
    
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

class SeedViewCell: UITableViewCell {
  
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var torrentNameLabel: UILabel!
    
    @IBOutlet var torrentProgressView: UIProgressView!
    @IBOutlet var torrentProgress: UILabel!
    @IBOutlet var percentDoneLabel: UILabel!
    @IBOutlet var ratioLabel: UILabel!

    @IBOutlet var uploadImageView: UIImageView!
    @IBOutlet var upSpeedLabel: UILabel!
}

class ErrorViewCell: UITableViewCell {
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var torrentNameLabel: UILabel!
    
    @IBOutlet var torrentProgressView: UIProgressView!
    @IBOutlet var torrentProgress: UILabel!
    @IBOutlet var percentDoneLabel: UILabel!
    
    @IBOutlet var errorStringLabel: UILabel!
}

