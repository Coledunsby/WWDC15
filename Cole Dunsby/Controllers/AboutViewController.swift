//
//  AboutViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-19.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

extension String {
    var length: Int {
        get {
            return count(self)
        }
    }
    func indexOf(target: String) -> Int {
        var range = self.rangeOfString(target)
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
}

class AboutViewController: UIViewController, UIScrollViewDelegate, TTTAttributedLabelDelegate, MapPopupViewControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, SpeechRecognitionManagerDelegate {
    
    let images = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("photos", ofType: "plist")!)!
    
    var pageControlBeingUsed = false
    
    @IBOutlet weak var aboutLabel: TTTAttributedLabel?
    @IBOutlet weak var imagesScrollView: UIScrollView?
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var separatorView: UIView?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()

        let stringToFind = "Montreal, Canada"
        let stringLength = stringToFind.length
        let startIndex = aboutLabel?.text?.indexOf(stringToFind)
        let range = NSMakeRange(startIndex!, stringLength)
        
        aboutLabel?.linkAttributes = [kCTForegroundColorAttributeName: UIColor.flatYellowColor()]
        aboutLabel?.activeLinkAttributes = [kCTForegroundColorAttributeName: UIColor.flatYellowColorDark()]
        aboutLabel?.addLinkToURL(nil, withRange: range)
        
        setupImagesScrollView()
        
        SpeechRecognitionManager.sharedInstance.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        separatorView?.backgroundColor = UIColor(gradientStyle: UIGradientStyle.LeftToRight, withFrame: separatorView!.bounds, andColors: [UIColor.flatSkyBlueColorDark(), UIColor.whiteColor(), UIColor.flatSkyBlueColorDark()])
    }
    
    // MARK: Instance Methods
    
    func setupImagesScrollView() {
        let size = CGSize(width: view.frame.size.width - 40, height: imagesScrollView!.frame.size.height)
        let gap: CGFloat = 0.0
        var x: CGFloat = 0.0
        
        for var i = 0; i < images.count; i++ {
            let imageInfo = images[i] as! NSDictionary
            let imageName = imageInfo["image"] as! String
            let imageCaption = imageInfo["caption"] as! String
            
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: x, y: 0), size: size))
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            imagesScrollView?.addSubview(imageView)
            
            let captionView = UIView(frame: CGRect(x: x, y: size.height - 30, width: size.width, height: 30))
            captionView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
            imagesScrollView?.addSubview(captionView)
            
            let captionLabel = UILabel(frame: CGRect(x: 10, y: 5, width: size.width - 20, height: 20))
            captionLabel.text = imageCaption
            captionLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
            captionLabel.textColor = UIColor.whiteColor()
            captionView.addSubview(captionLabel)
            
            x += size.width + gap
        }
        
        let totalWidth = (size.width * CGFloat(images.count)) + (gap * CGFloat(images.count - 1))
        imagesScrollView!.contentSize = CGSize(width: totalWidth, height: imagesScrollView!.frame.size.height)
        
        pageControl?.numberOfPages = images.count
    }
    
    // MARK: IBActions
    
    @IBAction func pageControlValueChanged(pageControl: UIPageControl) {
        let frame = CGRect(origin: CGPoint(x: imagesScrollView!.frame.size.width * CGFloat(pageControl.currentPage), y: 0), size: imagesScrollView!.frame.size)
        
        imagesScrollView?.scrollRectToVisible(frame, animated: true)
        
        pageControlBeingUsed = true
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["coledunsby@gmail.com"])
        mailVC.setSubject("WWDC 2015")
        presentViewController(mailVC, animated: true, completion: nil)
    }
    
    @IBAction func phoneButtonPressed(sender: AnyObject) {
        let callAction = UIAlertAction(title: "Call", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://15148672653")!)
        })
        
        let smsAction = UIAlertAction(title: "SMS", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            let smsVC = MFMessageComposeViewController()
            smsVC.messageComposeDelegate = self
            smsVC.recipients = ["15148672653"]
            self.presentViewController(smsVC, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Canceled")
        })
        
        let optionMenu = UIAlertController(title: nil, message: "+1 (514) 867-2653", preferredStyle: .ActionSheet)
        optionMenu.addAction(callAction)
        optionMenu.addAction(smsAction)
        optionMenu.addAction(cancelAction)
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !pageControlBeingUsed {
            let pageWidth = imagesScrollView!.frame.size.width
            let page = Int(floor((imagesScrollView!.contentOffset.x - pageWidth / 2) / pageWidth)) + 1
            
            pageControl?.currentPage = page
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pageControlBeingUsed = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControlBeingUsed = false
    }
    
    // MARK: TTTAttributedLabelDelegate
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let tmpView = UIView(frame: view.frame)
        tmpView.backgroundColor = UIColor.clearColor()
        tmpView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("mapPopupViewControllerDidDismiss:")))
        tmpView.tag = 44
        view.addSubview(tmpView)
        
        let popupVC = MapPopupViewController(nibName: "MapPopupViewController", bundle: nil)
        popupVC.name = "Montreal, Canada"
        popupVC.location = CLLocationCoordinate2DMake(45.5017, -73.5673)
        popupVC.delegate = self
        
        presentPopupViewController(popupVC, animated: true, completion: nil)
    }
    
    // MARK: MapPopupViewControllerDelegate
    
    func mapPopupViewControllerDidDismiss(mapPopupViewController: MapPopupViewController) {
        if popupViewController != nil {
            dismissPopupViewControllerAnimated(true, completion: nil)
            
            if let view = view.viewWithTag(44) {
                view.removeFromSuperview()
            }
        }
    }
    
    // MARK: SpeechRecognitionManagerDelegate
    
    func speechRecognitionManager(didRecognizeSpeech category: Int) {
        if category == 6 {
            performSegueWithIdentifier("UnwindFromAboutVC", sender: self)
        }
    }

}
