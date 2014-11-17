//
//  NTClient.swift
//  nomtime
//
//  Created by JACK LOR on 7/31/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

let kYelpAPIConsumerKey = ""
let kYelpAPIConsumerSecret = ""
let kYelpAPITokenAccess = ""
let kYelpAPITokenSecret = ""

private let _NTClientSharedInstance = NTClient()

class NTClient: NSObject, CLLocationManagerDelegate
{
    class var sharedInstance : NTClient {
    return _NTClientSharedInstance
    }
        var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var cityLocation: NSString?
    var requestYelp: NSURLRequest?
    var operationYelp: AFHTTPRequestOperation?
    /*
    var yummlyClient = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://api.yummly.com/v1/api/"))
    var googleClient = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://ajax.googleapis.com/ajax/services/search/"))

*/
    override init()
    {
        super.init()
        
        println("init")
        var pref =  NSUserDefaults.standardUserDefaults()
        if (pref.objectForKey("radiusFilter") == nil)
        {
            pref.setObject("500", forKey: "radiusFilter")
        }
        if (pref.objectForKey("searchFilter") == nil)
        {
            pref.setObject("0", forKey: "searchFilter")
        }
        
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if locationManager.respondsToSelector("requestWhenInUseAuthorization")
        {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("authorization : \(status)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("location error \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        currentLocation = locations[0] as? CLLocation
        var geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil)
            {
                let placemark = placemarks[0] as CLPlacemark
                self.cityLocation = placemark.postalCode
            }
        })
    }
    
    /*
    func getGoogleFood(food: NSString, completion: ((imgURL: NSString) -> Void)?)
    {
        let urlPath = "images?v=1.0"
        
        let foodQuery = NSString(format: "food eat %@", food)
        googleClient.GET(urlPath, parameters: ["q":foodQuery, "safe":"active", "imgsz": "large", "as_filetype": "jpg", "imgtype": "photo", "rsz":"1"], success: {
            (operation: AFHTTPRequestOperation!, result: AnyObject!) -> Void in
            let json = result as NSDictionary
            var imgURL: NSString?
            
            if json["responseData"] as? NSDictionary != nil
            {
                let response = json["responseData"] as NSDictionary
                let arrayMatches: [AnyObject] = response["results"] as [AnyObject]
                if arrayMatches.count > 0
                {
                    let match = arrayMatches[0] as NSDictionary
                    if match["url"]? != nil
                    {
                        imgURL = match["url"] as? NSString
                        completion?(imgURL: imgURL!)
                    }
                }
            }
            if imgURL == nil
            {
                println("no food \(foodQuery)")
            }
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("result \(error)")
            })
    }
    
    func getYummlyFood(food: NSString, completion: ((imgURL: NSString) -> Void)?)
    {
        let urlPath = "recipes"
        
        let foodQuery = NSString(format: "%@", food)
        yummlyClient.GET(urlPath, parameters: ["q":foodQuery], success: {
            (operation: AFHTTPRequestOperation!, result: AnyObject!) -> Void in
            let json = result as NSDictionary
            var imgURL: NSString?
            
            let arrayMatches: [AnyObject] = json["matches"] as [AnyObject]
            if arrayMatches.count > 0
            {
                let match = arrayMatches[0] as NSDictionary
                if match["smallImageUrls"] != nil
                {
                    let arrayImages: [AnyObject] = match["smallImageUrls"] as [AnyObject]
                    if arrayImages.count > 0
                    {
                        imgURL = (arrayImages[0] as? NSString)?.stringByReplacingOccurrencesOfString("=s90", withString: "=s280-c")
                        //println("img url \(imgURL)")
                        completion?(imgURL: imgURL!)
                    }
                }
            }
            if imgURL == nil
            {
                self.getGoogleFood(food, completion: completion)
            }
            
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("result \(error)")
        })
    }
*/

    func getYelpFood(food: NSString, completion: ((bizArray: [NTYelpBiz]) -> Void)?, failure: (() -> Void)?)
    {
        var pref =  NSUserDefaults.standardUserDefaults()
        let radiusFilter: String = pref.objectForKey("radiusFilter") as String
        let searchFilter: String = pref.objectForKey("searchFilter") as String
        var parameters = ["term": food, "category_filter": "restaurants", "location": "San Francisco", "limit": "3", "offset": "0", "sort": searchFilter, "radius_filter": radiusFilter]
        if cityLocation != nil
        {
            parameters["location"] = cityLocation!
        }
        if currentLocation != nil
        {
            parameters["cll"] = NSString(format: "\"%f,%f\"", self.currentLocation!.coordinate.latitude, self.currentLocation!.coordinate.longitude)
        }
        
        self.requestYelp = GCOAuth.URLRequestForPath("search", GETParameters: parameters, host: "api.yelp.com/v2/", consumerKey: kYelpAPIConsumerKey, consumerSecret: kYelpAPIConsumerSecret, accessToken: kYelpAPITokenAccess, tokenSecret: kYelpAPITokenSecret)
        self.operationYelp = AFHTTPRequestOperation(request: requestYelp!)
        self.operationYelp!.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, result: AnyObject!) -> Void in
            let json =
            NSJSONSerialization.JSONObjectWithData(result as NSData, options: nil, error: nil) as NSDictionary
            //println("json \(json)")
            var arrayBiz = json["businesses"] as [AnyObject]
            var yelpBiz: [NTYelpBiz]! = MTLJSONAdapter.modelsOfClass(NTYelpBiz.classForCoder(), fromJSONArray: arrayBiz, error: nil) as [NTYelpBiz]
            if completion != nil && yelpBiz.count > 0
            {
                //println("got yelp food \(yelpBiz.count)")
                completion!(bizArray: yelpBiz)
            }
            else if yelpBiz.count == 0 && failure != nil
            {
                failure!()
            }
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            if failure != nil
            {
                failure!()
            }
            println(" yelp  error \(error)")
        })
        self.operationYelp!.start()
        
    }
}