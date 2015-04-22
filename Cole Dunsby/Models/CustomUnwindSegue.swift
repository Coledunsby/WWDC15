//
//  CustomUnwindSegue.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-19.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import SpriteKit

class CustomUnwindSegue: UIStoryboardSegue {
   
    override func perform() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            for view in self.destinationViewController.view!!.subviews as! [UIView] {
                view.alpha = 0.0
            }
        }, completion: { (finished) -> Void in
            self.sourceViewController.dismissViewControllerAnimated(false, completion: { () -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    for view in self.sourceViewController.view!!.subviews as! [UIView] {
                        view.alpha = 1.0
                    }
                })
            })
        })
    }
    
}
