//
//  ViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-15.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let buttons = ["About Me", "Awards", "Education", "Projects", "Skills", "Work"]
    
    @IBOutlet weak var backgroundView: SKView?
    @IBOutlet weak var separatorView: UIView?
    @IBOutlet weak var collectionView: UICollectionView?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.TopToBottom, withFrame: view.frame, andColors: [UIColor.flatBlueColorDark(), UIColor.flatSkyBlueColor()])
        
        backgroundView?.allowsTransparency = true
        
        let backgroundScene = BackgroundScene(size: backgroundView!.bounds.size)
        backgroundScene.scaleMode = .AspectFill
        backgroundView?.presentScene(backgroundScene)
        
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 20
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        backgroundView!.addMotionEffect(group)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        separatorView?.backgroundColor = UIColor(gradientStyle: UIGradientStyle.LeftToRight, withFrame: separatorView!.bounds, andColors: [UIColor.flatSkyBlueColorDark(), UIColor.whiteColor(), UIColor.flatSkyBlueColorDark()])
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        cell.label?.text = buttons[indexPath.row]
        cell.imageView?.image = UIImage(named: buttons[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "_", options: .LiteralSearch, range: nil))
        return cell;
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CustomCollectionViewCell
        let segueIdentifier = "Show" + cell.label!.text!.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let margin = (view.frame.size.width - 280) / 3
        return UIEdgeInsets(top: 20, left: margin, bottom: 20, right: margin)
    }
    
    // MARK: Navigation
    
    @IBAction func unwindFromVC(segue: UIStoryboardSegue) {
        
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        return CustomUnwindSegue(identifier: identifier, source: toViewController, destination: fromViewController, performHandler: { () -> Void in
            
        })
    }

}

