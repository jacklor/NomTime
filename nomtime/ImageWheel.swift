//
//  ImageWheel.swift
//  nomtime
//
//  Created by JACK LOR on 7/24/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import Foundation
import QuartzCore

class ImageWheel {
    var imgFront: UIView
    var baseSize: CGSize
    var maximizeAnim = POPSpringAnimation(propertyNamed: kPOPLayerSize)
    var rotationAnim = POPSpringAnimation(propertyNamed: kPOPLayerRotationX)
    var fadeAnim = POPSpringAnimation(propertyNamed: kPOPLayerOpacity)
    
    
    init(imageView: UIView)
    {
        self.imgFront = imageView
        self.baseSize = imageView.bounds.size
        maximizeAnim.fromValue = NSValue(CGSize: CGSizeMake(0, 0))
        maximizeAnim.toValue = NSValue(CGSize: self.baseSize)
        maximizeAnim.springSpeed = 1
        maximizeAnim.springBounciness = Singleton.sharedInstance.animationBouciness
        
        rotationAnim.fromValue = 0
        rotationAnim.toValue = 2 * M_PI
        rotationAnim.springBounciness = 0
        rotationAnim.springSpeed = 1
        
        fadeAnim.fromValue = 0
        fadeAnim.toValue = 1
        fadeAnim.springSpeed = 1
    }
    
    func spinImage(completion: (() -> Void)?)
    {
        var imgLayer = self.imgFront.layer
        imgLayer.pop_removeAnimationForKey("maximize")
        imgLayer.pop_removeAnimationForKey("fade")
        imgLayer.pop_removeAnimationForKey("rotation")
        
        if completion != nil
        {
            maximizeAnim.completionBlock = {
                (anim: POPAnimation!, finished: Bool) in
                completion!()
            }
        }
        else
        {
            maximizeAnim.completionBlock = nil
        }
        
        imgLayer.pop_addAnimation(rotationAnim, forKey: "rotation")
        imgLayer.pop_addAnimation(fadeAnim, forKey: "fade")
        imgLayer.pop_addAnimation(maximizeAnim, forKey: "maximize")
    }
}