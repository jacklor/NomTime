//
//  NTBizCollectionCell.swift
//  nomtime
//
//  Created by JACK LOR on 8/26/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import Foundation
import QuartzCore

class NTBizCollectionCell : UICollectionViewCell
{
    @IBOutlet var bizNameLabel: UILabel?
    @IBOutlet var bizRateLabel: UILabel?
    @IBOutlet var bizDistanceLabel: UILabel?
    @IBOutlet var foodImgView: UIImageView?
    @IBOutlet var bizRateImgView: UIImageView?
    @IBOutlet var openButton: UIButton?
    
    override func awakeFromNib()
    {
        self.foodImgView!.layer.cornerRadius = 30
        self.foodImgView!.layer.masksToBounds = true
        self.foodImgView!.layer.borderWidth = 3
        self.foodImgView!.layer.borderColor = UIColor(red: 94.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0).CGColor
    }
}