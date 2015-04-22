//
//  CustomCollectionViewCell.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-17.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var label: UILabel?
    
    @IBInspectable var bordered: Bool = true
    
    override var highlighted: Bool {
        didSet {
            alpha = highlighted ? 0.5 : 1.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if bordered {
            imageView?.layer.cornerRadius = imageView!.frame.size.height / 2;
            imageView?.layer.borderWidth = 2.0
            imageView?.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
}
