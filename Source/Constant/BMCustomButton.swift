//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import Foundation
import UIKit

class BMCustomButton: UIButton {
    var intSection = 0
    var intRow = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setNeedsDisplay()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - FUNC SETUPVIEW.
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
}
