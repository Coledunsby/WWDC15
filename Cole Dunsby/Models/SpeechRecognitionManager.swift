//
//  SpeechRecognitionManager.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-22.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit

protocol SpeechRecognitionManagerDelegate : NSObjectProtocol {
    func speechRecognitionManager(didRecognizeSpeech category: Int)
}

class SpeechRecognitionManager: NSObject, OEEventsObserverDelegate {
    
    static let aboutWords = ["ABOUT", "INFO", "ME"]
    static let awardsWords = ["AWARD", "AWARDS"]
    static let educationWords = ["EDUCATION", "SCHOOL", "UNIVERSITY"]
    static let projectWords = ["PROJECT", "PROJECTS"]
    static let skillsWords = ["SKILL", "SKILLS", "LANGUAGES"]
    static let workWords = ["WORK", "JOB", "JOBS", "EMPLOYMENT"]
    static let backWords = ["BACK", "HOME", "MENU", "RETURN", "EXIT"]
    
    static let wordCategories = [aboutWords, awardsWords, educationWords, projectWords, skillsWords, workWords, backWords]
    
    let openEarsEventsObserver = OEEventsObserver()
    let acousticModelPath = OEAcousticModel.pathToModel("AcousticModelEnglish")
    
    var lmPath: String?
    var dicPath: String?
    
    weak var delegate: SpeechRecognitionManagerDelegate!
    
    class var sharedInstance: SpeechRecognitionManager {
        struct Singleton {
            static let instance = SpeechRecognitionManager()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        
        setupLanguageModel()
        setupEventObserver()
        
        OEPocketsphinxController.sharedInstance().requestMicPermission()
    }
    
    func setupLanguageModel() {
        let filename = "LanguageModelFiles"
        let lmGenerator = OELanguageModelGenerator()
        
        var allWords = SpeechRecognitionManager.wordCategories[0]
        for var i = 1; i < SpeechRecognitionManager.wordCategories.count; i++ {
            allWords += SpeechRecognitionManager.wordCategories[i]
        }
        
        if let error = lmGenerator.generateLanguageModelFromArray(allWords, withFilesNamed: filename, forAcousticModelAtPath: acousticModelPath) {
            println("ERROR: \(error.localizedDescription)")
        } else {
            lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(filename)
            dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(filename)
        }
    }
    
    func setupEventObserver() {
        openEarsEventsObserver.delegate = self
    }
    
    func startSpeechRecognition() {
        if OEPocketsphinxController.sharedInstance().micPermissionIsGranted {
            OEPocketsphinxController.sharedInstance().setActive(true, error: nil)
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: acousticModelPath, languageModelIsJSGF: false)
        } else {
            println("ERROR: mic access not granted")
        }
    }
    
    func categoryForWord(word: String!) -> Int {
        var index = -1
        for var i = 1; i < SpeechRecognitionManager.wordCategories.count && index == -1; i++ {
            if contains(SpeechRecognitionManager.wordCategories[i], word) {
                index = i
            }
        }
        return index
    }
    
    // MARK: OEEventsObserverDelegate
    
    func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String!) {
        println("pocketSphinxContinuousSetupDidFailWithReason \(reasonForFailure)")
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String!) {
        println("pocketSphinxContinuousTeardownDidFailWithReason \(reasonForFailure)")
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String!, andDictionary newDictionaryPathAsString: String!) {
        println("pocketsphinxDidChangeLanguageModelToFile \(newLanguageModelPathAsString) \(newDictionaryPathAsString)")
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        println("pocketsphinxDidDetectFinishedSpeech")
    }
    
    func pocketsphinxDidDetectSpeech() {
        println("pocketsphinxDidDetectSpeech")
    }
    
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        let threshold = 100
        let category = categoryForWord(hypothesis)
        let accepted = delegate != nil && recognitionScore.toInt() > -threshold
        
        println("pocketsphinxDidReceiveHypothesis")
        println("   hypothesis:         \(hypothesis)")
        println("   recognitionScore:   \(recognitionScore)")
        println("   utteranceID:        \(utteranceID)")
        println("   category:           \(category)")
        println("   delegate:           \(delegate)")
        println("   accepted:           \(accepted)")
        
        if accepted {
            delegate.speechRecognitionManager(didRecognizeSpeech: category)
        }
    }
    
    func pocketsphinxDidReceiveNBestHypothesisArray(hypothesisArray: [AnyObject]!) {
        println("pocketsphinxDidReceiveNBestHypothesisArray \(hypothesisArray)")
    }
    
    func pocketsphinxDidResumeRecognition() {
        println("pocketsphinxDidResumeRecognition")
    }
    
    func pocketsphinxDidStartListening() {
        println("pocketsphinxDidStartListening")
    }
    
    func pocketsphinxDidStopListening() {
        println("pocketsphinxDidStopListening")
    }
    
    func pocketsphinxDidSuspendRecognition() {
        println("pocketsphinxDidSuspendRecognition")
    }
    
    func pocketsphinxFailedNoMicPermissions() {
        println("pocketsphinxFailedNoMicPermissions")
    }
    
    func pocketsphinxRecognitionLoopDidStart() {
        println("pocketsphinxRecognitionLoopDidStart")
    }
    
    func pocketsphinxTestRecognitionCompleted() {
        println("pocketsphinxTestRecognitionCompleted")
    }
    
}
