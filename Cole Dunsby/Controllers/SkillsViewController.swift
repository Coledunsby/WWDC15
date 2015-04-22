//
//  SkillsViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-18.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class SkillsViewController: UIViewController, UITableViewDataSource, SpeechRecognitionManagerDelegate {

    let skillNames = ["Objective-C", "Swift", "Java", "C++", "PHP", "SQL", "Javascript", "Python"]
    let skillValues = [5, 3, 4, 4, 3, 5, 4, 3]
    
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
        return skillNames.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RatingTableViewCell
        cell.label!.text = skillNames[indexPath.row]
        cell.ratingView!.currentStep = skillValues[indexPath.row]
        cell.ratingView!.animate()
        return cell
    }
    
    // MARK: SpeechRecognitionManagerDelegate
    
    func speechRecognitionManager(didRecognizeSpeech category: Int) {
        if category == 6 {
            performSegueWithIdentifier("UnwindFromSkillsVC", sender: self)
        }
    }

}
