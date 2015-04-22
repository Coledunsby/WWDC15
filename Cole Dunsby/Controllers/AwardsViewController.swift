//
//  AwardsViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-19.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class AwardsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var separatorView: UIView?
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        separatorView?.backgroundColor = UIColor(gradientStyle: UIGradientStyle.LeftToRight, withFrame: separatorView!.bounds, andColors: [UIColor.flatSkyBlueColorDark(), UIColor.whiteColor(), UIColor.flatSkyBlueColorDark()])
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        if (indexPath.row == 0) {
            cell.textLabel?.text = "WWDC 2014 Student Scholarship"
            cell.detailTextLabel?.text = "Contest winner among top 200 apps"
            cell.imageView?.image = UIImage(named: "wwdc2014")
        } else if (indexPath.row == 1) {
            cell.textLabel?.text = "WWDC 2013 Student Scholarship"
            cell.detailTextLabel?.text = "Contest winner among top 150 apps"
            cell.imageView?.image = UIImage(named: "wwdc2013")
        } else {
            cell.textLabel?.text = "Nortel Networks Scholarship"
            cell.detailTextLabel?.text = "Admission Scholarship at University of Ottawa"
            cell.imageView?.image = UIImage(named: "nortel")
        }
        
        return cell
    }

}
