//
//  UIImageView+SLImageView.h
//  shoplocal2
//
//  Created by JACK LOR on 5/15/14.
//  Copyright (c) 2014 Thorsten Lubinski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (SLImageView)

- (void)setImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageFromURL:(NSURL *)url success:(void(^)(UIImage *image))successBlock failure:(void(^)(void))failureBlock;

@end
