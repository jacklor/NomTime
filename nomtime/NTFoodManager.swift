//
//  NTFoodManager.swift
//  nomtime
//
//  Created by JACK LOR on 8/5/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import Foundation
private let _NTFoodManagerSharedInstance = NTFoodManager()

class NTFoodManager
{
    class var sharedInstance : NTFoodManager {
        return _NTFoodManagerSharedInstance
    }
    
    let foodList: [NSMutableDictionary] = [
        ["name": "Afghan"],
        ["name": "African"],
        ["name": "American (New)"],
        ["name": "American (Traditional)"],
        ["name": "Arabian"],
        ["name": "Argentine"],
        ["name": "Armenian"],
        ["name": "Asian Fusion"],
        ["name": "Australian"],
        ["name": "Austrian"],
        ["name": "Bangladeshi"],
        ["name": "BBQ"],
        ["name": "Belgian"],
        ["name": "Brazilian"],
        ["name": "Breakfast & Brunch"],
        ["name": "British"],
        ["name": "Buffets"],
        ["name": "Burgers"],
        ["name": "Burmese"],
        ["name": "Cafes"],
        ["name": "Cafeteria"],
        ["name": "Cajun/Creole"],
        ["name": "Cambodian"],
        ["name": "Cantonese"],
        ["name": "Caribbean"],
        ["name": "Cheesesteaks"],
        ["name": "Chicken Wings"],
        ["name": "Chinese"],
        ["name": "Colombian"],
        ["name": "Comfort Food"],
        ["name": "Crepes"],
        ["name": "Cuban"],
        ["name": "Czech"],
        ["name": "Dim Sum"],
        ["name": "Diners"],
        ["name": "Egyptian"],
        ["name": "Ethiopian"],
        ["name": "Falafel"],
        ["name": "Filipino"],
        ["name": "Fish & Chips"],
        ["name": "Fondue"],
        ["name": "French"],
        ["name": "German"],
        ["name": "Gluten-Free"],
        ["name": "Greek"],
        ["name": "Haitian"],
        ["name": "Hawaiian"],
        ["name": "Himalayan"],
        ["name": "Hot Dogs"],
        ["name": "Hot Pot"],
        ["name": "Hungarian"],
        ["name": "Iberian"],
        ["name": "Indian"],
        ["name": "Irish"],
        ["name": "Italian"],
        ["name": "Japanese"],
        ["name": "Korean"],
        ["name": "Laotian"],
        ["name": "Latin American"],
        ["name": "Lebanese"],
        ["name": "Raw Food"],
        ["name": "Malaysian"],
        ["name": "Mediterranean"],
        ["name": "Mexican"],
        ["name": "Middle Eastern"],
        ["name": "European"],
        ["name": "Meat Love"],
        ["name": "Mongolian"],
        ["name": "Moroccan"],
        ["name": "Pakistani"],
        ["name": "Persian"],
        ["name": "Peruvian"],
        ["name": "Pizza"],
        ["name": "Polish"],
        ["name": "Portuguese"],
        ["name": "Puerto Rican"],
        ["name": "Ramen"],
        ["name": "Russian"],
        ["name": "Salad"],
        ["name": "Salvadoran"],
        ["name": "Sandwich"],
        ["name": "Scottish"],
        ["name": "Seafood"],
        ["name": "Shanghai"],
        ["name": "Singaporean"],
        ["name": "Soul Food"],
        ["name": "Soup"],
        ["name": "Southern"],
        ["name": "Spanish"],
        ["name": "Steak"],
        ["name": "Sushi"],
        ["name": "Taiwanese"],
        ["name": "Tapas"],
        ["name": "Tex-Mex"],
        ["name": "Thai"],
        ["name": "Trinidadian"],
        ["name": "Turkish"],
        ["name": "Vegan"],
        ["name": "Vegetarian"],
        ["name": "Vietnamese"]]
    var saveList: [Int] = [Int]()
    var availableIndexList: [Int] = [Int]()
    var randomBuffer: [Int] = [Int]()
    var lastTime = NSDate()
    var currentFood: NSMutableDictionary?
    
    init()
    {
        for index in 0...self.foodList.count - 1
        {
            self.saveList.append(index)
        }
    }
    
    func load()
    {
        self.randomBuffer.removeAll(keepCapacity: false)
        self.availableIndexList = [Int](self.saveList)
        for index in 0...3
        {
            self.addPreloadedFood()
        }
    }
    
    func addPreloadedFood()
    {
        //var r: Int = Int(rand()) % self.availableIndexList.count
        var r: Int = Int(arc4random_uniform(UInt32(self.availableIndexList.count)))
        while contains(self.randomBuffer, self.availableIndexList[r])
        {
            r = Int(arc4random_uniform(UInt32(self.availableIndexList.count)))
        }
        self.randomBuffer.append(self.availableIndexList[r])
        
        var food = self.foodList[self.availableIndexList[r]] as NSMutableDictionary
        let foodName = NSString(format: "%@", food["name"] as NSString)
        NTClient.sharedInstance.getYelpFood(foodName, completion: {
            (bizArray: [NTYelpBiz]!) -> Void in
            food["bizList"] = bizArray
            NSNotificationCenter.defaultCenter().postNotificationName(kFoodLoaded, object: food["name"])
        }, failure: nil)
    }
    
    func getNextRandomFood(remove: Bool) -> NSMutableDictionary
    {
        // prevent spamming the button
        if (self.lastTime.timeIntervalSinceNow < -0.25 && self.randomBuffer.count > 0)
        {
            if remove == true
            {
                //println("removed \(self.foodList[self.randomBuffer[0]])")
                self.availableIndexList = self.availableIndexList.filter( {$0 != self.randomBuffer[0] })
            }
            self.randomBuffer.removeAtIndex(0)
            if self.availableIndexList.count > 3
            {
                self.addPreloadedFood()
            }
        }
        self.lastTime = NSDate()
        self.currentFood = self.foodList[self.randomBuffer[0]]
        return self.currentFood!
    }
}
