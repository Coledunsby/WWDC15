//
//  ViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-15.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import SpriteKit

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
    
    func containsOneOf(phrases: [String]) -> Bool {
        var found = false
        for phrase in phrases {
            if self.indexOf(phrase) != -1 {
                found = true
                break
            }
        }
        return found
    }
    
    func containsAllOf(phrases: [String]) -> Bool {
        var foundCount = 0
        for phrase in phrases {
            if self.indexOf(phrase) != -1 {
                foundCount++
            }
        }
        return foundCount == phrases.count
    }
    
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SKRecognizerDelegate, SKVocalizerDelegate {

    var recognizer: SKRecognizer?
    var vocalizer: SKVocalizer?
    var isSpeaking = false
    let buttons = ["About Me", "Awards", "Education", "Projects", "Skills", "Work"]
    let reachability = Reachability(hostname: "www.google.com")
    
    @IBOutlet weak var backgroundView: SKView?
    @IBOutlet weak var separatorView: UIView?
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var microphoneButton: UIButton?
    
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
    
        UIAlertView(
            title: "Welcome!",
            message: "Simply tap the icons OR tap the microphone and speak the commands to navigate the menu. \n\n Sample Phrases: \n - Tell me about yourself. \n - Show me your awards. \n - Tell me about your education. \n - What projects have you worked on? \n - What programming languages do you know? \n - Where have you worked? \n ...",
            delegate: nil,
            cancelButtonTitle: "OK").show()
        
        setupReachability()
        setupSpeechKitConnection()
        
        NSNotificationCenter.defaultCenter().addObserverForName("applicationWillResignActive", object: nil, queue: nil) { (notification
            ) -> Void in
            self.stopRecognizer()
            self.stopVocalizer()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        separatorView?.backgroundColor = UIColor(gradientStyle: UIGradientStyle.LeftToRight, withFrame: separatorView!.bounds, andColors: [UIColor.flatSkyBlueColorDark(), UIColor.whiteColor(), UIColor.flatSkyBlueColorDark()])
    }
    
    // MARK: Helper Methods
    
    func setupReachability() {
        reachability.reachableBlock = { reachability in
            println("REACHABLE")
        }
        reachability.unreachableBlock = { reachability in
            println("UNREACHABLE")
        }
        reachability.startNotifier()
    }
    
    func setupSpeechKitConnection() {
        SpeechKit.setupWithID("NMDPTRIAL_coledunsby_gmail_com20150422030540",
            host: "sandbox.nmdp.nuancemobility.net",
            port: 443,
            useSSL: false,
            delegate: nil)
        
        let earconStart = SKEarcon.earconWithName("earcon_listening.wav") as! SKEarcon
        let earconStop = SKEarcon.earconWithName("earcon_done_listening.wav") as! SKEarcon
        let earconCancel = SKEarcon.earconWithName("earcon_cancel.wav") as! SKEarcon
        
        SpeechKit.setEarcon(earconStart, forType: UInt(SKStartRecordingEarconType))
        SpeechKit.setEarcon(earconStop, forType: UInt(SKStopRecordingEarconType))
        SpeechKit.setEarcon(earconCancel, forType: UInt(SKCancelRecordingEarconType))
        
        isSpeaking = true;
        
        vocalizer = SKVocalizer(voice: "Tom", delegate: self)
        vocalizer?.speakString("Welcome! Simply tap the icons or tap the microphone and speak the commands to navigate the menu.")
    }
    
    func stopRecognizer() {
        if recognizer != nil {
            recognizer?.stopRecording()
            recognizer?.cancel()
        }
    }
    
    func stopVocalizer() {
        if isSpeaking {
            vocalizer?.cancel()
            isSpeaking = false
        }
    }
    
    // MARK: IBActions
    
    @IBAction func microphoneButtonPressed(sender: AnyObject) {
        if !isSpeaking {
            microphoneButton?.selected = !microphoneButton!.selected
            
            if microphoneButton!.selected {
                recognizer = SKRecognizer(
                    type: SKSearchRecognizerType,
                    detection: UInt(SKShortEndOfSpeechDetection),
                    language: "en_US",
                    delegate: self)
            } else {
                stopRecognizer()
            }
        }
    }
    
    // MARK: SKRecognizerDelegate
    
    func recognizer(recognizer: SKRecognizer!, didFinishWithError error: NSError!, suggestion: String!) {
        println("didFinishWithError \(error.localizedDescription) \(suggestion)")
        
        if error.code == SKServerConnectionError || error.code == SKPermissionError {
            UIAlertView(title: "Error!", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        }
        
        microphoneButton?.selected = false
    }
    
    func recognizer(recognizer: SKRecognizer!, didFinishWithResults results: SKRecognition!) {
        println("didFinishWithResults \(results.results)")
        
        let phrases = results.results as! [String]
        let phrase = phrases.first?.lowercaseString
        var custom = false
        var index = -1
        
        microphoneButton?.selected = false
        
        stopRecognizer()
        isSpeaking = true;
        
        if phrase != nil {
            if phrase!.containsOneOf(["award", "awards"]) {
                index = 1
            } else if phrase!.containsOneOf(["education", "school", "university", "student", "grade"]) {
                index = 2
            } else if phrase!.containsOneOf(["project", "projects", "apps", "info"]) {
                index = 3
            } else if phrase!.containsOneOf(["skill", "skills", "programming", "languages"]) || phrase!.containsAllOf(["software", "experience"]) {
                index = 4
            } else if phrase!.containsOneOf(["work", "job", "jobs", "employment", "cv", "resume"]) || phrase!.containsAllOf(["work", "experience"]) {
                index = 5
            } else if phrase!.containsOneOf(["about", "about me", "info", "contact"]) {
                index = 0
            } else if phrase!.containsAllOf(["how", "old"]) {
                custom = true
                vocalizer?.speakString("I am 19 years old.")
            } else if phrase!.containsAllOf(["where", "from"]) {
                custom = true
                vocalizer?.speakString("I am from Montreal, Quebec, Canada.")
            } else if phrase!.containsAllOf(["where", "live"]) {
                custom = true
                vocalizer?.speakString("I live in Ottawa, Ontario, Canada.")
            } else if phrase!.containsAllOf(["where", "born"]) {
                custom = true
                vocalizer?.speakString("I was born in Frederick, Maryland, USA.")
            } else if phrase!.containsOneOf(["name"]) {
                custom = true
                vocalizer?.speakString("My name is Cole Dunsby.")
            }
        }
        
        if index >= 0 {
            collectionView(collectionView!, didSelectItemAtIndexPath: NSIndexPath(forItem: index, inSection: 0))
        } else if !custom {
            if phrase == nil {
                vocalizer?.speakString("I didn't hear you. Please try again.")
            } else {
                vocalizer?.speakString("You said \(phrase!) but I don't understand what you are asking for.")
            }
        }
    }
    
    func recognizerDidBeginRecording(recognizer: SKRecognizer!) {
        println("recognizerDidBeginRecording")
        
        if (microphoneButton?.alpha != 0.0) {
            microphoneButton?.alpha = 1.0
        }
    }
    
    func recognizerDidFinishRecording(recognizer: SKRecognizer!) {
        println("recognizerDidFinishRecording")
        
        if (microphoneButton?.alpha != 0.0) {
            microphoneButton?.alpha = 0.5
        }
    }
    
    // MARK: SKVocalizerDelegate
    
    func vocalizer(vocalizer: SKVocalizer!, willBeginSpeakingString text: String!) {
        println("willBeginSpeakingString \(text)")
        
        isSpeaking = true
        
        if (microphoneButton?.alpha != 0.0) {
            microphoneButton?.alpha = 1.0
        }
    }
    
    func vocalizer(vocalizer: SKVocalizer!, didFinishSpeakingString text: String!, withError error: NSError!) {
        println("didFinishSpeakingString \(text)")
        
        isSpeaking = false
        
        if (microphoneButton?.alpha != 0.0) {
            microphoneButton?.alpha = 0.5
        }
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
        stopRecognizer()
        stopVocalizer()
        
        if reachability.isReachable() {
            if indexPath.row == 0 {
                vocalizer?.speakString("Here is some information about me.")
            } else if indexPath.row == 1 {
                vocalizer?.speakString("Here are my awards.")
            } else if indexPath.row == 2 {
                vocalizer?.speakString("Here is some information about my education.")
            } else if indexPath.row == 3 {
                vocalizer?.speakString("Here are some of my projects.")
            } else if indexPath.row == 4 {
                vocalizer?.speakString("Here are some of the languages and technologies that I know.")
            } else if indexPath.row == 5 {
                vocalizer?.speakString("Here are the companies I have worked for.")
            }
        } else {
            println("skipping tts... no internet connection")
        }
        
        let segueIdentifier = "Show" + buttons[indexPath.row].stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
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

