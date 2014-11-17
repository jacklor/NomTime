//
//  NTSettingController.swift
//  nomtime
//
//  Created by JACK LOR on 11/4/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import Foundation

class NTSettingController: UIViewController {
    @IBOutlet var segmentedBar : UISegmentedControl?
    @IBOutlet var sliderBar : UISlider?
    @IBOutlet var distanceLabel : UILabel?
    
    var distanceFormatter = MKDistanceFormatter()
    
    var parentController: NTViewController?
    
    override func loadView() {
        super.loadView()
        let font = UIFont(name: "Noteworthy-Bold", size: 13.0)
        let attributes = Dictionary(dictionaryLiteral: (NSFontAttributeName, font!), (NSForegroundColorAttributeName, UIColor.whiteColor()))
        segmentedBar?.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        sliderBar!.addTarget(self, action: "sliderUpdate", forControlEvents: UIControlEvents.ValueChanged)
        //segmentedBar!.addTarget(self, action: "segmentedUpdate", forControlEvents: UIControlEvents.ValueChanged)
        distanceFormatter.unitStyle = MKDistanceFormatterUnitStyle.Abbreviated
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pref =  NSUserDefaults.standardUserDefaults()
        var distance: Double = pref.objectForKey("radiusFilter")!.doubleValue
        distanceLabel!.text = distanceFormatter.stringFromDistance(distance)
        sliderBar!.value = Float(distance)
    
        var searchFilter: Int = pref.objectForKey("searchFilter")!.integerValue
        segmentedBar!.selectedSegmentIndex = searchFilter
    }
    
    func sliderUpdate()
    {
        let distance: Double = Double(sliderBar!.value)
        distanceLabel!.text = distanceFormatter.stringFromDistance(distance)
    }
    /*
    func segmentedUpdate()
    {
        
    }
*/
    
    func saveUpdate()
    {
        var pref =  NSUserDefaults.standardUserDefaults()
        pref.setObject(NSString(format: "%.0f", sliderBar!.value), forKey: "radiusFilter")
        pref.setObject(NSString(format: "%d", segmentedBar!.selectedSegmentIndex), forKey: "searchFilter")
    }
    
}