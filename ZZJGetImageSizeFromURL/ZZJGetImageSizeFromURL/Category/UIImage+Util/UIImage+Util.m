//
//  UIImage+Util.m
//  ZZJGetImageSizeFromURL
//
//  Created by JOE on 2017/5/22.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

#import "UIImage+Util.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (Util)

+ (CGSize)getImageSizeWithURL:(id)URl {
    NSURL *url = nil;
    if ([URl isKindOfClass:[NSURL class]]) {
        url = URl;
    }
    if ([URl isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URl];
    }
    if (!URl) {
        return CGSizeZero;
    }
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

@end
