//
//  Singleton.swift
//  nomtime
//
//  Created by JACK LOR on 8/25/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

import Foundation
private let _SingletonSharedInstance = Singleton()

class Singleton
{
    class var sharedInstance : Singleton {
        return _SingletonSharedInstance
    }
    
    var animationBouciness : CGFloat = 10.0
}