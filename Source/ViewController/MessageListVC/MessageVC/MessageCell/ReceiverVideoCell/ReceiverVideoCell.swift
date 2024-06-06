//
//  ReceiverVideoCell.swift
//  BilliyoClinicalHealth
//
//  Created by macmini on 06/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ReceiverVideoCell: UITableViewCell {
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var lblUserName: BMLabel!
    @IBOutlet weak var viewMessageBG: UIView!
    @IBOutlet weak var viewMessageInner: UIView!
    @IBOutlet weak var imgAttachment: UIImageView!
    @IBOutlet weak var lblMessageText: BMLabel!
    @IBOutlet weak var btnPlayVideo: BMCustomButton!
    @IBOutlet weak var viewMessageTime: UIView!
    @IBOutlet weak var lblMessageTime: BMLabel!
    @IBOutlet weak var btnDownload: BMCustomButton!
    @IBOutlet weak var downloadLoader : UIActivityIndicatorView!
    
    var intSection = 0
    var intRow = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMessageBG.layer.cornerRadius = 10.0
        self.viewMessageBG.layer.masksToBounds = true
        
        self.viewMessageInner.layer.cornerRadius = 10.0
        self.viewMessageInner.layer.masksToBounds = true
        
        self.btnPlayVideo.layer.cornerRadius = self.btnPlayVideo.frame.height / 2.0
        self.btnPlayVideo.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
