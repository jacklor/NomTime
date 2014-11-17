//
//  ViewController.swift
//  nomtime
//
//  Created by JACK LOR on 7/23/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import UIKit
import QuartzCore

let kFoodLoaded = "kFoodLoaded"

class NTViewController: UIViewController, UIAlertViewDelegate {
    @IBOutlet var backgroundImage: UIImageView?
    @IBOutlet var imgView: UIImageView?
    var imgBack = UIImageView(frame: CGRectZero)
    
    @IBOutlet var bubbleBG: UIView?
    @IBOutlet var tapGesture: UITapGestureRecognizer?
    
    @IBOutlet var declineButton: BumpButton?
    @IBOutlet var acceptButton: BumpButton?
    
    @IBOutlet var questionLabel: UILabel?
    @IBOutlet var foodLabel: UILabel?
    @IBOutlet var interactionView: UIView?
    @IBOutlet var welcomeView: UIView?
    
    @IBOutlet var emoteLabel: UILabel?
    @IBOutlet var counterLabel: UILabel?
    
    @IBOutlet var refreshBG: UIView?
    @IBOutlet var refreshButton: UIButton?
    
    @IBOutlet var configBG: UIView?
    @IBOutlet var configButton: UIButton?
    
    @IBOutlet var bizView: UIView?
    @IBOutlet var bizController: NTBizController?
    @IBOutlet var settingView: UIView?
    @IBOutlet var settingController: NTSettingController?
    
    var bubbleList = [UIView]()
    var imageWheel: ImageWheel?
    var panRecognizer: UIPanGestureRecognizer?
    var initialCenter = [NSDictionary]()
    var selectedFood: NSMutableDictionary?
    let emptyImage = UIImage(named: "emptydish.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (self.imgView != nil)
        {
            imageWheel = ImageWheel(imageView: self.imgView!)
            self.imgBack.bounds = self.imgView!.bounds
        }
        self.imgView!.alpha = 0
        self.viewLayoutConfiguration()
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willPresentNewPopover:) name:@"FPNewPopoverPresented" object:nil];
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foodLoaded:", name: kFoodLoaded, object: nil)
        self.popBubbleAtIndex(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    @IBAction func turnWheelAction(sender: AnyObject)
    {
        self.selectedFood = NTFoodManager.sharedInstance.getNextRandomFood(self.declineButton! == sender as NSObject)

        self.counterLabel!.text = NSString(format: "%d/%d", NTFoodManager.sharedInstance.availableIndexList.count, NTFoodManager.sharedInstance.foodList.count)
        if self.declineButton! == sender as NSObject
        {
            self.transformText(self.counterLabel!, color: UIColor.whiteColor())
        }
        self.foodLabel!.text = self.selectedFood!["name"] as NSString
        self.imgView!.image = emptyImage
        if (self.imgView!.alpha != 1)
        {
            self.fadeComponents(self.imgView!, alpha: 1.0, duration: 1.0)
        }
        
        self.displayFood()
        self.bounceAllBubble()
        self.fadeComponents(self.interactionView!, alpha: 1.0, duration: 1.5)
        if (self.welcomeView? != nil)
        {
            self.welcomeView!.removeFromSuperview()
            self.welcomeView = nil
            self.imgView!.layer.borderWidth = 3
            self.imgView!.layer.borderColor = self.view.backgroundColor?.CGColor
            self.fadeComponents(self.counterLabel!, alpha: 1.0, duration: 1.5)
            self.refreshBG!.hidden = false
            self.configBG!.hidden = false
        }

    }
    
    func displayFood()
    {
        if self.selectedFood!["bizList"] != nil
        {
            let bizList = self.selectedFood!["bizList"] as [NTYelpBiz]
            if bizList.count > 0
            {
                let biz = bizList[0]
                if  biz.imgURL != nil
                {
                    self.imgView!.setImageFromURL(NSURL(string: biz.imgURL), success:
                        { (img: UIImage!) -> Void in
                            self.imageWheel!.spinImage(nil)
                    }, failure: nil)
                }
            }
        }
    }
    
    func foodLoaded(notification: NSNotification)
    {
        let loadedFood = notification.object as NSString
        if (self.imgView!.image == emptyImage && self.selectedFood != nil && loadedFood == self.selectedFood!["name"] as NSString)
        {
            self.displayFood()
        }
    }
    
    func resetPanel()
    {
        self.imgBack.layer.pop_removeAnimationForKey("position")
        self.imgView!.layer.pop_removeAnimationForKey("fade")
        self.interactionView!.layer.pop_removeAnimationForKey("fade")
        self.imgView!.alpha = 1.0
        self.interactionView!.alpha = 1.0
        self.interactionView!.hidden = false
        self.bizView!.hidden = true
        self.panRecognizer!.enabled = true
        self.tapGesture!.enabled = true
        self.refreshBG!.alpha = 1.0
        self.configBG!.alpha = 1.0
        self.turnWheelAction(self)
    }
    
    @IBAction func settingAction(sender : AnyObject)
    {
        var scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.fromValue = NSValue(CGPoint: CGPointMake(1.15, 1.15))
        scaleAnim.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        scaleAnim.springBounciness = 14
        scaleAnim.springSpeed = 1
        self.configBG!.layer.pop_addAnimation(scaleAnim, forKey: "scale")
        
        var rotateAnim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
        rotateAnim.fromValue = 0
        rotateAnim.toValue = 2 * M_PI
        rotateAnim.springBounciness = 14
        rotateAnim.springSpeed = 1
        self.configButton!.layer.pop_addAnimation(rotateAnim, forKey: "rotation")
        
        if (self.settingView!.hidden == true)
        {
            self.bounceAllBubble()
            self.settingView!.alpha = 0.0
            self.settingView!.hidden = false
            self.fadeComponents(self.settingView!, alpha: 1, duration: 0.25)
            self.fadeComponents(self.interactionView!, alpha: 0, duration: 0.25)
            self.fadeComponents(self.imgView!, alpha: 0, duration: 0.25)
            self.fadeComponents(self.refreshBG!, alpha: 0, duration: 0.25)
            self.panRecognizer!.enabled = false
            self.tapGesture!.enabled = false
        }
        else
        {
            self.fadeComponents(self.settingView!, alpha: 0, duration: 0.25)
            self.fadeComponents(self.interactionView!, alpha: 1, duration: 0.25)
            self.fadeComponents(self.imgView!, alpha: 1, duration: 0.25)
            self.fadeComponents(self.refreshBG!, alpha: 1, duration: 0.25)
            self.panRecognizer!.enabled = true
            self.tapGesture!.enabled = true
            self.settingView!.hidden = true
            self.settingController?.saveUpdate()
            self.restartAction(self)
        }
    }
    
    @IBAction func restartAction(sender: AnyObject)
    {
        var scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.fromValue = NSValue(CGPoint: CGPointMake(1.15, 1.15))
        scaleAnim.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        scaleAnim.springBounciness = 14
        scaleAnim.springSpeed = 1
        self.refreshBG!.layer.pop_addAnimation(scaleAnim, forKey: "scale")
        
        var rotateAnim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
        rotateAnim.fromValue = 0
        rotateAnim.toValue = 2 * M_PI
        rotateAnim.springBounciness = 14
        rotateAnim.springSpeed = 1
        self.refreshButton!.layer.pop_addAnimation(rotateAnim, forKey: "rotation")
        
        NTFoodManager.sharedInstance.load()
        self.resetPanel()
    }
    
    @IBAction func declineAction(sender: AnyObject)
    {
        let location = self.view.convertPoint(self.imgView!.frame.origin, fromView: self.imgView!)
        if let recognizer = sender as? UIPanGestureRecognizer
        {
            self.imgBack.center = recognizer.locationInView(self.view)
        }
        else
        {
            self.imgBack.center = location
        }
        self.imgBack.image = self.imgView!.image
        self.fadeComponents(self.imgBack, alpha: 0, duration: 0.25)
        var posAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        posAnim.toValue = NSValue(CGPoint: CGPointMake(-self.imgBack.frame.size.width * 0.5, location.y))
        posAnim.springSpeed = 1
        self.imgBack.layer.pop_addAnimation(posAnim, forKey: "position")
        if NTFoodManager.sharedInstance.randomBuffer.count > 1
        {
            self.turnWheelAction(self.declineButton!)
        }
        else
        {
            var alert = UIAlertView(title: "Out of Choice!", message: "Sorry, you reached the end of the list :(", delegate: self, cancelButtonTitle: "Restart !")
            alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if (alertView.title == "Out of Choice!")
        {
            self.restartAction(alertView)
        }
    }
    
    @IBAction func acceptAction(sender: AnyObject)
    {
        if self.selectedFood!["bizList"] != nil
        {
            self.bizController!.selectedFood = self.selectedFood!
            let bizList = self.selectedFood!["bizList"] as [NTYelpBiz]
            self.bizController!.bizList = bizList
            self.bizController!.reloadView()
        }
        else
        {
            var alert = UIAlertView(title: "Sorry!", message: "We didn't found any restaurant for that around. :(", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        self.bounceAllBubble()
        let location = self.view.convertPoint(self.imgView!.frame.origin, fromView: self.imgView!)
        self.imgBack.center = location
        self.imgBack.image = self.imgView!.image
        self.imgBack.alpha = 1.0
        self.imgView!.layer.pop_removeAnimationForKey("fade")
        self.imgView!.alpha = 0.0
        var posAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        posAnim.toValue = NSValue(CGPoint: CGPointMake(self.imgBack.frame.size.width * 0.5 + 18.0, self.bubbleBG!.center.y))
        posAnim.springSpeed = 1
        posAnim.completionBlock = {
            (anim: POPAnimation!, finished: Bool) in
            self.interactionView!.hidden = true
        }
        self.fadeComponents(self.imgBack, alpha: 0, duration: 0.25)
        self.imgBack.layer.pop_addAnimation(posAnim, forKey: "position")
        self.bizView!.alpha = 0.0
        self.bizView!.hidden = false
        self.fadeComponents(self.bizView!, alpha: 1, duration: 0.25)
        self.fadeComponents(self.interactionView!, alpha: 0, duration: 0.25)
        self.panRecognizer!.enabled = false
        self.tapGesture!.enabled = false
        self.fadeComponents(self.refreshBG!, alpha: 0, duration: 0.25)
        self.fadeComponents(self.configBG!, alpha: 0, duration: 0.25)

    }
    
    @IBAction func dragAction(recognizer: UIPanGestureRecognizer)
    {
        for dict in self.initialCenter
        {
            let view = dict["view"] as UIView
            view.layer.pop_removeAnimationForKey("center")
        }
        var translation: CGPoint = recognizer.translationInView(self.view)
        self.imgView!.center = CGPointMake(self.imgView!.center.x + translation.x * 0.80, self.imgView!.center.y + translation.y * 0.80)
        translation.x *= 0.25
        translation.y *= 0.25
        self.bubbleBG!.center = CGPointMake(self.bubbleBG!.center.x + translation.x, self.bubbleBG!.center.y + translation.y)
        for var index = self.bubbleList.count - 1; index >= 0; --index
        {
            let bubble = self.bubbleList[index]
            translation.x *= 0.75
            translation.y *= 0.75
            bubble.center = CGPointMake(bubble.center.x + translation.x, bubble.center.y + translation.y)
        }
        
        let bubbleWidth: CGFloat = self.bubbleBG!.frame.width
        if self.imgView!.center.x < bubbleWidth * 0.4
        {
            self.declineButton!.changeToSelected()
        }
        else if self.imgView!.center.x > bubbleWidth * 0.6
        {
            self.acceptButton!.changeToSelected()
        }
        else
        {
            self.declineButton!.resetToDefault()
            self.acceptButton!.resetToDefault()
        }
        
        if recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled || recognizer.state == UIGestureRecognizerState.Failed
        {
            self.centerAllBubble()
            
            if self.imgView!.center.x < bubbleWidth * 0.35
            {
                self.imgView!.alpha = 0
                self.imgView!.layer.pop_removeAnimationForKey("fade")
                self.declineAction(recognizer)
            }
            else if self.imgView!.center.x > bubbleWidth * 0.65
            {
                self.acceptAction(recognizer)
            }
            
            self.centerImage()
            self.declineButton!.resetToDefault()
            self.acceptButton!.resetToDefault()
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
}

extension NTViewController
{
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent)
    {
        if motion == UIEventSubtype.MotionShake
        {
            self.turnWheelAction(event)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "bizEmbedSegue"
        {
            self.bizController = segue.destinationViewController as? NTBizController
            self.bizController!.parentController = self
        }
        else if segue.identifier == "settingEmbedSegue"
        {
            self.settingController = segue.destinationViewController as? NTSettingController
            self.settingController!.parentController = self
        }
    }
}
