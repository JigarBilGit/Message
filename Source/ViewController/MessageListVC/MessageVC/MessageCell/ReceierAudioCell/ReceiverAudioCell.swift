//
//  SenderCell.swift
//  BilliyoClinicalHealth
//
//  Created by macmini on 06/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ReceiverAudioCell: UITableViewCell {
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var lblUserName: BMLabel!
    @IBOutlet weak var viewMessageBG: UIView!
    @IBOutlet weak var viewDownloadAudio: UIView!
    @IBOutlet weak var imgAudio: UIImageView!
    @IBOutlet weak var btnDownload: BMCustomButton!
    @IBOutlet weak var downloadLoader : UIActivityIndicatorView!
    @IBOutlet weak var viewMessageTime: UIView!
    @IBOutlet weak var lblMessageTime: BMLabel!
    
    @IBOutlet weak var viewPlayAudio: UIView!
    @IBOutlet weak var btnPlayAudio: BMCustomButton!
    @IBOutlet weak var btnPauseAudio: BMCustomButton!
    @IBOutlet weak var audioSlider: UISlider!
    
    var intSection = 0
    var intRow = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMessageBG.layer.cornerRadius = 10.0
        self.viewMessageBG.layer.masksToBounds = true
        
        self.viewDownloadAudio.layer.cornerRadius = 10.0
        self.viewDownloadAudio.layer.masksToBounds = true
        
        self.viewPlayAudio.layer.cornerRadius = 10.0
        self.viewPlayAudio.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



