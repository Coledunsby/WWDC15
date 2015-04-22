
//
//  EducationViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-19.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MapKit

class EducationViewController: UIViewController, TTTAttributedLabelDelegate, MapPopupViewControllerDelegate, SpeechRecognitionManagerDelegate {

    @IBOutlet weak var aboutLabel: TTTAttributedLabel?
    @IBOutlet weak var separatorView: UIView?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        let stringToFind = "University of Ottawa"
        let stringLength = stringToFind.length
        let startIndex = aboutLabel?.text?.indexOf(stringToFind)
        let range = NSMakeRange(startIndex!, stringLength)
        
        aboutLabel?.linkAttributes = [kCTForegroundColorAttributeName: UIColor.flatYellowColor()]
        aboutLabel?.activeLinkAttributes = [kCTForegroundColorAttributeName: UIColor.flatYellowColorDark()]
        aboutLabel?.addLinkToURL(nil, withRange: range)
        
        SpeechRecognitionManager.sharedInstance.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        separatorView?.backgroundColor = UIColor(gradientStyle: UIGradientStyle.LeftToRight, withFrame: separatorView!.bounds, andColors: [UIColor.flatSkyBlueColorDark(), UIColor.whiteColor(), UIColor.flatSkyBlueColorDark()])
    }
    
    // MARK: TTTAttributedLabelDelegate
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let tmpView = UIView(frame: view.frame)
        tmpView.backgroundColor = UIColor.clearColor()
        tmpView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("mapPopupViewControllerDidDismiss:")))
        tmpView.tag = 44
        view.addSubview(tmpView)
        
        let popupVC = MapPopupViewController(nibName: "MapPopupViewController", bundle: nil)
        popupVC.name = "University of Ottawa"
        popupVC.location = CLLocationCoordinate2DMake(45.4222, -75.6824)
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
            performSegueWithIdentifier("UnwindFromEducationVC", sender: self)
        }
    }

}
