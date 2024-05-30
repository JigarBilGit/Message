//
//  ConversationListCell.swift
//  BilliyoCommunication
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell {
    @IBOutlet weak var viewCellBg: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var viewIsActive: UIView!
    @IBOutlet weak var lblUserName: BMLabel!
    @IBOutlet weak var lblLastMessage: BMLabel!
    @IBOutlet weak var lblMessageTime: BMLabel!
    @IBOutlet weak var lblUnreadMessageCount: BMLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
