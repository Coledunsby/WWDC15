//
//  RatingView.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-18.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit

@IBDesignable
class RatingView: UIView {

    var stepViews: Array<UIView> = Array()
    
    @IBInspectable var totalSteps: Int = 10
    
    @IBInspectable var currentStep: Int = 5 {
        didSet {
            for var i = 0; i < currentStep; i++ {
                stepViews[i].backgroundColor = fillColor
            }
        }
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.whiteColor()
    @IBInspectable var emptyColor: UIColor = UIColor(white: 1.0, alpha: 0.1)
    @IBInspectable var stepGap: Float = 10.0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    func createSubviews() {
        for var i = 0; i < totalSteps; i++ {
            let stepView = UIView()
            stepView.backgroundColor = self.emptyColor
            addSubview(stepView)
            
            stepViews.append(stepView)
        }
    }
    
    func animate() {
        for var i = 0; i < totalSteps; i++ {
            stepViews[i].backgroundColor = emptyColor
        }
        
        for var i = 0; i < currentStep; i++ {
            let stepView = stepViews[i]
            
            UIView.animateWithDuration(0.25, delay: Double(i) * 0.1, options: nil,
                animations: { () -> Void in
                    stepView.backgroundColor = self.fillColor
                    stepView.transform = CGAffineTransformMakeScale(1.5, 1.5)
                },
                completion: { (finished) -> Void in
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        stepView.transform = CGAffineTransformIdentity
                    })
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = CGSize(width: frame.size.height, height: frame.size.height)
        let width = (CGFloat(totalSteps) * size.width) + ((CGFloat(totalSteps) - 1) * CGFloat(stepGap))
        var x = frame.size.width - width
        
        for var i = 0; i < totalSteps; i++ {
            let stepView = stepViews[i]
            stepView.frame = CGRect(origin: CGPoint(x: x, y: 0), size: size)
            stepView.layer.cornerRadius = size.width / 2
            
            x += CGFloat(size.width) + CGFloat(stepGap)
        }
    }
    
}
