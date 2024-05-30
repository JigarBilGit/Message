//
//  SelectedClientCell.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit

class SelectedClientCell: UICollectionViewCell {
    @IBOutlet weak var viewCellBG: UIView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var lblUserName: BHLabel!
    @IBOutlet weak var btnDeleteClient: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.btnDeleteClient.layer.cornerRadius = self.btnDeleteClient.height / 2.0
        self.btnDeleteClient.layer.masksToBounds = true
    }
}
