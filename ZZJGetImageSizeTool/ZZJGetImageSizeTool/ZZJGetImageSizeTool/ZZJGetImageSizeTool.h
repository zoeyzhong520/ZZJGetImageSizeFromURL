//
//  ZZJGetImageSizeTool.h
//  ZZJGetImageSizeTool
//
//  Created by JOE on 2017/5/25.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZJGetImageSizeTool : NSObject

+ (CGSize)getImageSizeWithURL:(id)imageURL;
+ (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request;
+ (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request;
+ (CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request;

@end
