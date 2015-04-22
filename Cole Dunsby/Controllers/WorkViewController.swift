//
//  WorkViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-19.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SpeechRecognitionManagerDelegate {

    let jobs = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("work", ofType: "plist")!)!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorView: UIView?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        SpeechRecognitionManager.sharedInstance.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        separatorView?.backgroundColor = UIColor(gradientStyle: UIGradientStyle.LeftToRight, withFrame: separatorView!.bounds, andColors: [UIColor.flatSkyBlueColorDark(), UIColor.whiteColor(), UIColor.flatSkyBlueColorDark()])
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let jobInfo = jobs[indexPath.row] as! NSDictionary
        let companyName = jobInfo["company"] as! String
        let position = jobInfo["position"] as! String
        let imageName = jobInfo["image"] as! String
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! WorkTableViewCell
        cell.companyLabel?.text = companyName
        cell.positionLabel?.text = position
        cell.companyImageView?.image = UIImage(named: imageName)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let jobInfo = jobs[indexPath.row] as! NSDictionary
        let website = jobInfo["website"] as! String
        
        let openAction = UIAlertAction(title: "Open in Safari", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: website)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Canceled")
        })
        
        let optionMenu = UIAlertController(title: nil, message: website, preferredStyle: .ActionSheet)
        optionMenu.addAction(openAction)
        optionMenu.addAction(cancelAction)
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func linkedInButtonPressed(sender: AnyObject) {
        let openAction = UIAlertAction(title: "Open in Safari", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "https://ca.linkedin.com/in/coledunsby")!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Canceled")
        })
        
        let optionMenu = UIAlertController(title: nil, message: "https://ca.linkedin.com/in/coledunsby", preferredStyle: .ActionSheet)
        optionMenu.addAction(openAction)
        optionMenu.addAction(cancelAction)
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: SpeechRecognitionManagerDelegate
    
    func speechRecognitionManager(didRecognizeSpeech category: Int) {
        if category == 6 {
            performSegueWithIdentifier("UnwindFromWorkVC", sender: self)
        }
    }

}
