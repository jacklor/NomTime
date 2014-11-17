//
//  NTBizController.swift
//  nomtime
//
//  Created by JACK LOR on 8/26/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import Foundation
import QuartzCore

class NTBizController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var foodLabel: UILabel?
    @IBOutlet var pageControl: UIPageControl?
    @IBOutlet var yelpButton: BumpButton?
    
    var parentController: NTViewController?
    var selectedFood: NSMutableDictionary?
    var bizList: [NTYelpBiz]?
    var gradientLayer: CAGradientLayer?
    
    override func loadView() {
        super.loadView()
        /*
        var maskLayer = CAGradientLayer()
        let outerColor = UIColor(red: 68.0/255.0, green: 152.0/255.0, blue: 152.0/255.0, alpha: 0.0).CGColor
        let innerColor = UIColor(red: 68.0/255.0, green: 152.0/255.0, blue: 152.0/255.0, alpha: 1.0).CGColor
        
        maskLayer.colors = [outerColor as AnyObject, innerColor as AnyObject, innerColor as AnyObject, outerColor as AnyObject]
        maskLayer.locations = [NSNumber(double: 0.0), NSNumber(double: 0.1), NSNumber(double: 0.9), NSNumber(double: 1.0)]
        maskLayer.bounds = CGRectMake(0.0, 0.0, self.collectionView!.frame.size.width, self.collectionView!.frame.size.height)
        maskLayer.anchorPoint = CGPointZero
        self.collectionView!.layer.mask = maskLayer
        */
        self.collectionView!.layer.cornerRadius = 50
        self.collectionView!.layer.masksToBounds = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.yelpButton!.layer.borderColor = self.parentController!.view.backgroundColor?.CGColor
        self.yelpButton!.selectedColor = UIColor(red: 0, green: 200/255.0, blue: 133/255.0, alpha: 1.0)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if bizList == nil
        {
            return 0
        }
        return bizList!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell : NTBizCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("bizCell", forIndexPath: indexPath) as NTBizCollectionCell
        let biz = bizList![indexPath.row]
        
        cell.bizNameLabel!.text = biz.name
        cell.bizRateLabel!.text = NSString(format: "%d", biz.reviewCount.integerValue)
        if biz.imgURL != nil
        {
            cell.foodImgView!.setImageFromURL(NSURL(string: biz.imgURL), success: nil, failure: nil)
        }
        else
        {
            cell.foodImgView!.image = self.parentController!.emptyImage
        }
        cell.bizRateImgView!.setImageFromURL(NSURL(string: biz.ratingURL), success: nil, failure: nil)
        if biz.distanceString != nil
        {
            cell.bizDistanceLabel!.text = biz.distanceString!
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        var currentPage: CGFloat = scrollView.contentOffset.x
        currentPage /= self.collectionView!.frame.width
        self.pageControl!.currentPage = Int(currentPage)
    }
    
    func reloadView()
    {
        self.pageControl!.currentPage = 0
        if bizList != nil
        {
            self.pageControl!.numberOfPages = bizList!.count
        }
        else
        {
            self.pageControl!.numberOfPages = 0
        }
        self.foodLabel!.text = self.selectedFood!["name"] as NSString
        self.collectionView!.reloadData()
        self.collectionView!.setContentOffset(CGPointZero, animated: false)
    }
    
    @IBAction func backAction(sender: AnyObject)
    {
        self.parentController!.resetPanel()
    }
    
    @IBAction func openYelpAction(sender: AnyObject)
    {
        let index = self.pageControl!.currentPage
        if bizList!.count > index
        {
            let biz = bizList![index]
            var url = ""
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "yelp:")!)
            {
                url = NSString(format: "yelp:///biz/%@", biz.uid)
            }
            else
            {
                url = NSString(format: "http://yelp.com/biz/%@", biz.uid)
            }
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
    }
}