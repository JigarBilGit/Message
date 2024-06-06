//
//  BMOptionCell.swift
//  BilliyoClinicalPDN
//
//  Created by Billiyo Health on 10/01/23.
//

import UIKit

class BMImageOptionCell: UITableViewCell {
    
    @IBOutlet var viewBg        :   UIView!
    @IBOutlet var imgOption  :   UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
