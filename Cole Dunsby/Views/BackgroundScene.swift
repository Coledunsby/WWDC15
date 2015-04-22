//
//  BackgroundScene.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-18.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import SpriteKit

class BackgroundScene: SKScene {
   
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = UIColor.clearColor()
        
        let filePath = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
        let particleSystem = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath!) as! SKEmitterNode
        particleSystem.position = CGPoint(x: CGRectGetMidX(frame), y: size.height / 2)
        particleSystem.particlePositionRange = CGVector(dx: size.width, dy: size.height)
        particleSystem.particleAlphaSequence = SKKeyframeSequence(keyframeValues: [0.0, 0.4, 0.0], times: [0.0, 0.5, 1.0])
        particleSystem.targetNode = scene
        addChild(particleSystem)
        
        particleSystem.advanceSimulationTime(10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
