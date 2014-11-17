//
//  BumpButton.swift
//  nomtime
//
//  Created by JACK LOR on 7/28/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import Foundation
import UIKit

class BumpButton: UIButton {
    var selectedColor: UIColor?
    var defaultColor: UIColor?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.0
        self.addTarget(self, action: "changeToSelected", forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: "resetToDefault", forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: "resetToDefault", forControlEvents: UIControlEvents.TouchUpOutside)
    }
    
    func changeToSelected()
    {
        if (defaultColor == nil)
        {
            defaultColor = self.backgroundColor
        }
        if selectedColor == self.backgroundColor
        {
            return
        }
        
        if (selectedColor != nil)
        {
            var springColorAnim = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
            springColorAnim.toValue = selectedColor?.CGColor
            springColorAnim.springBounciness = 0
            springColorAnim.springSpeed = 20
            self.pop_addAnimation(springColorAnim, forKey: "springColor")
        }
        var scaleAnim = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        scaleAnim.toValue = NSValue(CGPoint: CGPointMake(1.15, 1.15))
        scaleAnim.springBounciness = 14
        scaleAnim.springSpeed = 20
        self.pop_addAnimation(scaleAnim, forKey: "scale")
    }
    
    func resetToDefault()
    {
        if (defaultColor == nil)
        {
            defaultColor = self.backgroundColor
        }
        
        if defaultColor == self.backgroundColor
        {
            return
        }
        var springColorAnim = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
        springColorAnim.toValue = defaultColor!.CGColor
        springColorAnim.springBounciness = 0;
        springColorAnim.springSpeed = 20
        self.pop_addAnimation(springColorAnim, forKey: "springColor")
        
        var scaleAnim = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        scaleAnim.toValue = NSValue(CGPoint: CGPointMake(1, 1))
        scaleAnim.springBounciness = 14;
        self.pop_addAnimation(scaleAnim, forKey: "scale")
    }
}
