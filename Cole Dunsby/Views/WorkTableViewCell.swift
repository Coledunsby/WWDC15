//
//  WorkTableViewCell.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-20.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class WorkTableViewCell: UITableViewCell {

    @IBOutlet weak var companyLabel: UILabel?
    @IBOutlet weak var positionLabel: UILabel?
    @IBOutlet weak var companyImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        var bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        selectedBackgroundView = bgColorView
    }
    
}
