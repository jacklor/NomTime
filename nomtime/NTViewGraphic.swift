//
//  NTViewGraphic.swift
//  nomtime
//
//  Created by JACK LOR on 7/28/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import UIKit
import QuartzCore

extension NTViewController
{
    func viewLayoutConfiguration() {
        let screenSize = UIScreen.mainScreen().bounds
        var bgFile = "launchImage_640x1136"
        if screenSize.size.height <= 480.0
        {
            bgFile = "launchImage_640x960"
        }
        self.backgroundImage!.image = UIImage(named: bgFile)
        self.bubbleBG!.layoutIfNeeded()
        self.welcomeLayout()
        
        self.interactionView!.alpha = 0
        self.initialCenter.append(["center": NSValue(CGPoint: self.imgView!.center), "view": self.imgView!])
        for var index = 0; index < 3; ++index {
            self.bubbleList.append(UIView(frame: CGRectMake(screenSize.width * 0.5, screenSize.height - 160, 0, 0)))
        }
        for bubble in self.bubbleList
        {
            bubble.backgroundColor = UIColor(white: 0, alpha: 0.15)
            bubble.layer.cornerRadius = 15
            bubble.layer.masksToBounds = true
            self.view.addSubview(bubble)
        }
        if self.bubbleBG != nil
        {
            var layer = self.bubbleBG!.layer
            layer.cornerRadius = 50
            layer.masksToBounds = true
            self.bubbleBG!.alpha = 0
            self.view.bringSubviewToFront(self.bubbleBG!)
            
            self.initialCenter.append(["center": NSValue(CGPoint: self.bubbleBG!.center), "view": self.bubbleBG!])
        }
        
        self.declineButton!.layer.borderColor = self.view.backgroundColor?.CGColor
        self.declineButton!.selectedColor = UIColor(red: 1.0, green: 122/255.0, blue: 122/255.0, alpha: 1.0)
        self.acceptButton!.layer.borderColor = self.view.backgroundColor?.CGColor
        self.acceptButton!.selectedColor = UIColor(red: 0, green: 200/255.0, blue: 133/255.0, alpha: 1.0)
        
        (self.questionLabel as GSBorderLabel).borderWidth = 2
        (self.questionLabel as GSBorderLabel).borderColor = self.bubbleBG!.backgroundColor
        (self.foodLabel as GSBorderLabel).borderWidth = 2
        (self.foodLabel as GSBorderLabel).borderColor = self.bubbleBG!.backgroundColor
        
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: "dragAction:")
        self.bubbleBG!.addGestureRecognizer(self.panRecognizer!)
        self.imgBack.alpha = 0
        self.imgBack.center = self.view.center
        self.imgBack.layer.cornerRadius = 30
        self.imgBack.layer.masksToBounds = true
        self.imgBack.layer.borderWidth = 3
        self.imgBack.layer.borderColor = self.view.backgroundColor?.CGColor
        self.view.addSubview(self.imgBack)
        
        self.imgView!.layer.cornerRadius = 30
        self.imgView!.layer.masksToBounds = true
        
        self.refreshBG!.layer.cornerRadius = 18
        self.refreshBG!.layer.masksToBounds = true
        
        self.configBG!.layer.cornerRadius = 18
        self.configBG!.layer.masksToBounds = true
    }
    
    func welcomeLayout()
    {
        let screenSize = UIScreen.mainScreen().bounds.size
        let ratioCalc = (screenSize.width * screenSize.height) / (320.0 * 568.0)
        let ratioExpo = ratioCalc * ratioCalc
        
        let fontName = "Noteworthy-bold"
        let hungryLabel = UILabel(frame: CGRectZero)
        hungryLabel.font = UIFont(name: fontName, size: 44 * ratioExpo)
        hungryLabel.textColor = UIColor.whiteColor()
        hungryLabel.text = "Hungry?"
        hungryLabel.sizeToFit()
        self.welcomeView!.addSubview(hungryLabel)
        hungryLabel.center = CGPointMake(self.welcomeView!.center.x, hungryLabel.center.y)
        
        let tapLabel = UILabel()
        tapLabel.font = UIFont(name: fontName, size: 50 * ratioExpo)
        tapLabel.textColor = UIColor.whiteColor()
        tapLabel.text = "Tap"
        tapLabel.sizeToFit()
        self.welcomeView!.addSubview(tapLabel)
        tapLabel.center = CGPointMake(self.welcomeView!.center.x, self.welcomeView!.center.y - 24.0)
        
        let circleLabel = UILabel()
        circleLabel.font = UIFont(name: fontName, size: 114 * ratioExpo)
        circleLabel.textColor = UIColor.whiteColor()
        circleLabel.text = "○"
        circleLabel.sizeToFit()
        self.welcomeView!.addSubview(circleLabel)
        circleLabel.center = CGPointMake(self.welcomeView!.center.x, tapLabel.center.y - 6)
        
        let findLabel = UILabel()
        findLabel.font = UIFont(name: fontName, size: 36 * ratioExpo)
        findLabel.textColor = UIColor.whiteColor()
        findLabel.text = "to find what to"
        findLabel.sizeToFit()
        self.welcomeView!.addSubview(findLabel)
        findLabel.center = CGPointMake(self.welcomeView!.center.x, tapLabel.center.y + 80.0 * ratioExpo)
        
        let nomLabel = UILabel()
        nomLabel.font = UIFont(name: fontName, size: 44 * ratioExpo)
        nomLabel.textColor = UIColor.whiteColor()
        nomLabel.text = "NOM!"
        nomLabel.sizeToFit()
        self.welcomeView!.addSubview(nomLabel)
        nomLabel.center = CGPointMake(self.welcomeView!.center.x, findLabel.center.y + 44.0 * ratioCalc)
    }
    
    func popBubbleAtIndex(index: Int)
    {
        let bubble = self.bubbleList[index]
        let layer = bubble.layer
        var sizeAnim = POPSpringAnimation(propertyNamed: kPOPLayerSize)
        let doubleIndex = Double(index)
        sizeAnim.toValue = NSValue(CGSize: CGSizeMake(CGFloat(40.0 + doubleIndex * 50.0), CGFloat(30.0 + doubleIndex * 5.0)))
        sizeAnim.springBounciness = 20
        sizeAnim.springSpeed = 20
        sizeAnim.completionBlock = {
            (anim: POPAnimation!, finished: Bool) in
            self.initialCenter.append(["center": NSValue(CGPoint: bubble.center), "view": bubble])
            index < 2 ? self.popBubbleAtIndex(index + 1) : self.showMainBubble()
        }
        if (index > 0)
        {
            let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height - 160
            var posAnim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            var position = screenHeight - CGFloat(20.0 - doubleIndex * 5.0)
            for var i = 0; i < index; ++i {
                position -= CGFloat(index * 7)
            }
            posAnim.toValue = position
            layer.cornerRadius = 15.0 + CGFloat(index) * 2.5
            layer.pop_addAnimation(posAnim, forKey: "position")
        }
        layer.pop_addAnimation(sizeAnim, forKey: "size")
    }
    
    func showMainBubble()
    {
        self.bubbleBG!.alpha = 1
        
        var popOutAnim = POPSpringAnimation(propertyNamed: kPOPLayerSize)
        popOutAnim.fromValue = NSValue(CGSize: CGSizeMake(0, 0))
        //popOutAnim.toValue = NSValue(CGSize: CGSizeMake(self.bubbleBG!.frame.width, self.bubbleBG!.frame.height))
        popOutAnim.springBounciness = 17
        popOutAnim.springSpeed = 5
        self.bubbleBG!.layer.pop_addAnimation(popOutAnim, forKey: "size")
        self.welcomeView!.alpha = 0
        
        self.floatAllBubble()
        self.fadeComponents(self.welcomeView!, alpha: 1, duration: 1.5)
    }
    
    func stopAllFloatingBubble()
    {
        for dict in self.initialCenter
        {
            let view = dict["view"] as UIView
            if view != self.imgView!
            {
                view.layer.pop_removeAnimationForKey("floatRotate")
                var floatRotateAnim = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
                floatRotateAnim.toValue = 0
                floatRotateAnim.duration = 0
                view.layer.pop_addAnimation(floatRotateAnim, forKey: "floatRotate")
            }
        }
    }
    
    func floatAllBubble()
    {
        var side: CGFloat = 0.015
        for dict in self.initialCenter
        {
            let view = dict["view"] as UIView
            if view != self.imgView! && view != self.bubbleBG!
            {
                self.floatingBubble(view, side: side, distance: (self.bubbleBG!.frame.size.width / view.frame.size.width) / 2)
                side = -side
            }
        }
    }
    
    func floatingBubble(let bubble: UIView, let side: CGFloat, let distance: CGFloat)
    {
        var duration: CFTimeInterval = CFTimeInterval((200 - (rand() % 100))) / 100.0
        var floatRotateAnim = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
        floatRotateAnim.toValue = side * distance
        floatRotateAnim.duration = 1.3 * duration
        
        var randomX = CGFloat((rand() % 400) - 400) / 100
        var randomY = CGFloat((rand() % 400) - 400) / 100
        var floatTranslateAnim = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
        floatTranslateAnim.toValue = NSValue(CGPoint: CGPointMake(randomX, randomY))
        floatTranslateAnim.duration = 1.0 * duration
        floatTranslateAnim.completionBlock = {
            (anim: POPAnimation!, finished: Bool) in
            self.floatingBubble(bubble, side: -side, distance: distance)
        }
        
        bubble.layer.pop_addAnimation(floatRotateAnim, forKey: "floatRotate")
        bubble.layer.pop_addAnimation(floatTranslateAnim, forKey: "floatTranslate")
    }
    
    func bounceAllBubble()
    {
        var bounceAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        bounceAnimation.toValue =  NSValue(CGPoint: CGPointMake(1, 1))
        bounceAnimation.springBounciness = Singleton.sharedInstance.animationBouciness
        bounceAnimation.springSpeed = 1
        bounceAnimation.fromValue = NSValue(CGPoint: CGPointMake(0.50, 0.50))
        
        self.bubbleBG!.pop_addAnimation(bounceAnimation, forKey: "bounce")
        for bubbleView in self.bubbleList
        {
            bubbleView.pop_removeAnimationForKey("bounce")
            bubbleView.pop_addAnimation(bounceAnimation, forKey: "bounce")
        }
    }
    
    func fadeComponents(let view: UIView, let alpha: CGFloat, let duration: CFTimeInterval)
    {
        var initialValue: CGFloat
        if alpha == 0
        {
            initialValue = 1
        }
        else
        {
            initialValue = 0
        }
        
        view.alpha = initialValue
        var fadeAnim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        fadeAnim.fromValue = initialValue
        fadeAnim.toValue = alpha
        fadeAnim.duration = duration
        fadeAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        view.pop_removeAnimationForKey("alpha")
        view.pop_addAnimation(fadeAnim, forKey: "alpha")
    }
    
    func centerAllBubble()
    {
        for dict in self.initialCenter
        {
            let view = dict["view"] as UIView
            if view != self.imgView!
            {
                view.layer.pop_removeAllAnimations()
                var bounceAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
                bounceAnimation.springBounciness = Singleton.sharedInstance.animationBouciness
                bounceAnimation.toValue = dict["center"]
                view.layer.pop_addAnimation(bounceAnimation, forKey: "center")
            }
        }
    }
    
    func transformText(view: UIView, color: UIColor)
    {
        var transformAnim = POPSpringAnimation(propertyNamed: kPOPLabelTextColor)
        transformAnim.fromValue = UIColor(red: 1.0, green: 122/255.0, blue: 122/255.0, alpha: 1.0)
        transformAnim.toValue = color
        transformAnim.springBounciness = Singleton.sharedInstance.animationBouciness
        transformAnim.springSpeed = 0.25

        view.pop_removeAnimationForKey("transformText")
        view.pop_addAnimation(transformAnim, forKey: "transformText")
    }
    
    func centerImage()
    {
        for dict in self.initialCenter
        {
            let view = dict["view"] as UIView
            if view == self.imgView!
            {
                var bounceAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
                bounceAnimation.springBounciness = Singleton.sharedInstance.animationBouciness
                bounceAnimation.toValue = dict["center"]
                view.layer.pop_addAnimation(bounceAnimation, forKey: "center")
                break
            }
        }
    }
    
    func showAdvertisement()
    {
        
    }
}


