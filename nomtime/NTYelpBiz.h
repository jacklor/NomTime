//
//  NTYelpBiz.h
//  nomtime
//
//  Created by JACK LOR on 8/5/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Mantle/Mantle.h"

@interface NTYelpBiz : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imgURL;
@property (nonatomic, copy) NSString *ratingURL;
@property (nonatomic, copy) NSNumber *reviewCount;
@property (nonatomic, copy) NSNumber *isClosed;
@property (nonatomic, copy) NSDictionary *locationData;
@property (nonatomic, copy) CLLocation *location;
@property (nonatomic, copy) NSString *distanceString;

@property (nonatomic, copy) NSDictionary *categories;

@end
