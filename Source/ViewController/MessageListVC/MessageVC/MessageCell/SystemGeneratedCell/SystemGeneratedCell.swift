//
//  SystemGeneratedCell.swift
//  BilliyoCommunication
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
//

import UIKit

class SystemGeneratedCell: UITableViewCell {
    @IBOutlet weak var viewMessageBG: UIView!
    @IBOutlet weak var lblMessage: BMLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMessageBG.layer.cornerRadius = 10.0
//        self.viewMessageBG.layer.borderWidth = 0.0
//        self.viewMessageBG.layer.borderColor = Theme.color.Clear.cgColor
        self.viewMessageBG.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
