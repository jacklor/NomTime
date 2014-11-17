//
//  UIImageView+SLImageView.m
//  shoplocal2
//
//  Created by JACK LOR on 5/15/14.
//  Copyright (c) 2014 Thorsten Lubinski. All rights reserved.
//

#import <POP/POP.h>
#import "UIImageView+SLImageView.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SLImageView)

- (void)setImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    __weak UIImageView *weakSelf = self;
    [self setAlpha:0.0];
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        POPBasicAnimation *fadeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        [fadeAnim setFromValue:@0];
        [fadeAnim setToValue:@1];
        [fadeAnim setDuration:0.4];
        fadeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [weakSelf pop_removeAnimationForKey:@"alpha"];
        [weakSelf pop_addAnimation:fadeAnim forKey:@"alpha"];
    }];
}

- (void)setImageFromURL:(NSURL *)url success:(void(^)(UIImage *image))successBlock failure:(void(^)(void))failureBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageDownloaderProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error)
        {
            NSLog(@"error image %@ %@", imageURL, error);
            if (failureBlock != nil)
                failureBlock();
        }
        else
            if (successBlock != nil)
                successBlock(image);
    }];
}

@end
