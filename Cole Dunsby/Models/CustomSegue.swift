//
//  CustomSegue.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-19.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import SpriteKit

class CustomSegue: UIStoryboardSegue {
   
    override func perform() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            for view in self.sourceViewController.view!!.subviews as! [UIView] {
                if view is SKView {
                    // Keep
                } else {
                    view.alpha = 0.0
                }
            }
        }, completion: { (finished) -> Void in
            
            for view in self.destinationViewController.view!!.subviews as! [UIView] {
                view.alpha = 0.0
            }
            
            self.sourceViewController.presentViewController(self.destinationViewController as! UIViewController, animated: false, completion: { () -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    for view in self.destinationViewController.view!!.subviews as! [UIView] {
                        view.alpha = 1.0
                    }
                })
            })
            
        })
    }
    
}
