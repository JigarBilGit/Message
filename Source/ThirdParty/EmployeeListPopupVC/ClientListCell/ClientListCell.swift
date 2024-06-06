//
//  ClientListCell.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 11/08/21.
//

import UIKit

class ClientListCell: UITableViewCell {
    
    @IBOutlet var viewBg        :   UIView!
    @IBOutlet var imgSelection  :   UIImageView!
    @IBOutlet var lblTitle      :   BMLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

