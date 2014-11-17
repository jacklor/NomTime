//
//  NTYelpBiz.m
//  nomtime
//
//  Created by JACK LOR on 8/5/14.
//  Copyright (c) 2014 sixdoors. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "NTYelpBiz.h"
#import "nomtime-Swift.h"
#import "UIImageView+SLImageView.h"
@implementation NTYelpBiz

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid": @"id",
             @"phoneNumber": @"display_phone",
             @"name": @"name",
             @"imgURL": @"image_url",
             @"ratingURL": @"rating_img_url_large",
             @"reviewCount": @"review_count",
             @"isClosed": @"is_closed",
             @"locationData": @"location",
             @"categories": @"categories"
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self)
    {
        if (self.imgURL)
            self.imgURL = [self.imgURL stringByReplacingOccurrencesOfString:@"ms.jpg" withString:@"ls.jpg"];
        if (self.locationData && [self.locationData objectForKey:@"coordinate"])
        {
            double latitude = [[[self.locationData objectForKey:@"coordinate"] objectForKey:@"latitude"] doubleValue];
            double longitude = [[[self.locationData objectForKey:@"coordinate"] objectForKey:@"longitude"] doubleValue];
            self.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            double distance = [[[NTClient sharedInstance] currentLocation] distanceFromLocation:self.location];
            MKDistanceFormatter *df = [[MKDistanceFormatter alloc] init];
            df.unitStyle = MKDistanceFormatterUnitStyleAbbreviated;
            self.distanceString = [df stringFromDistance:distance];
        }
    }
    return self;
}
@end
