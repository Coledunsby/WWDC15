//
//  ProjectsViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-19.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import StoreKit

class ProjectsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SKStoreProductViewControllerDelegate, SpeechRecognitionManagerDelegate {

    let apps = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("apps", ofType: "plist")!)!
    
    @IBOutlet weak var separatorView: UIView?
    @IBOutlet weak var collectionView: UICollectionView?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        SpeechRecognitionManager.sharedInstance.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        separatorView?.backgroundColor = UIColor(gradientStyle: UIGradientStyle.LeftToRight, withFrame: separatorView!.bounds, andColors: [UIColor.flatSkyBlueColorDark(), UIColor.whiteColor(), UIColor.flatSkyBlueColorDark()])
    }
    
    // MARK: IBActions
    
    @IBAction func gitHubButtonPressed(sender: AnyObject) {
        let openAction = UIAlertAction(title: "Open in Safari", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/Coledunsby")!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Canceled")
        })
        
        let optionMenu = UIAlertController(title: nil, message: "https://github.com/Coledunsby", preferredStyle: .ActionSheet)
        optionMenu.addAction(openAction)
        optionMenu.addAction(cancelAction)
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let appInfo = apps[indexPath.row] as! NSDictionary
        let appName = appInfo["title"] as! String
        let imageName = appInfo["image"] as! String
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        cell.label?.text = appName
        cell.imageView?.image = UIImage(named: imageName)
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", forIndexPath: indexPath) as! UICollectionReusableView
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let appInfo = apps[indexPath.row] as! NSDictionary
        let appID = appInfo["id"] as! String
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CustomCollectionViewCell
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        let storeController = SKStoreProductViewController()
        storeController.delegate = self
        storeController.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier : appID], completionBlock: { (finished, error) -> Void in
            self.presentViewController(storeController, animated: true, completion: { () -> Void in
                MBProgressHUD.hideHUDForView(view, animated: true)
            })
        })
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let margin = (view.frame.size.width - 240) / 3
        return UIEdgeInsets(top: 20, left: margin, bottom: 20, right: margin)
    }
    
    // MARK: SKStoreProductViewControllerDelegate
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: SpeechRecognitionManagerDelegate
    
    func speechRecognitionManager(didRecognizeSpeech category: Int) {
        if category == 6 {
            performSegueWithIdentifier("UnwindFromProjectsVC", sender: self)
        }
    }

}
