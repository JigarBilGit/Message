//
//  SenderCell.swift
//  BilliyoCommunication
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

class ReceiverTextCell: MGSwipeTableCell {
    
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var lblUserName: BMLabel!
    @IBOutlet weak var viewMessageBG: UIView!
    @IBOutlet weak var lblMessage: BMLabel!
    @IBOutlet weak var viewMessageTime: UIView!
    @IBOutlet weak var lblMessageTime: BMLabel!
    
    var intSection = 0
    var intRow = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMessageBG.layer.cornerRadius = 10.0
        self.viewMessageBG.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
