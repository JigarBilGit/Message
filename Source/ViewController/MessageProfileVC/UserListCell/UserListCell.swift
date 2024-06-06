//
//  UserListCell.swift
//  BilliyoCommunication
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    @IBOutlet weak var viewCellBg: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblUserName: BMLabel!
    @IBOutlet weak var viewIsAdmin: UIView!
    @IBOutlet weak var lblIsAdmin: BMLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewIsAdmin.layer.cornerRadius = 4.0
        self.viewIsAdmin.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
