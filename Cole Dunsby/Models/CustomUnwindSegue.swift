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
        let sourceVC = self.sourceViewController as! ViewController
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            for view in self.destinationViewController.view!!.subviews as! [UIView] {
                view.alpha = 0.0
            }
        }, completion: { (finished) -> Void in
            sourceVC.dismissViewControllerAnimated(false, completion: { () -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    for view in sourceVC.view!.subviews as! [UIView] {
                        view.alpha = 1.0
                    }
                })
            })
        })
        
        SpeechRecognitionManager.sharedInstance.delegate = sourceVC
    }
    
}
