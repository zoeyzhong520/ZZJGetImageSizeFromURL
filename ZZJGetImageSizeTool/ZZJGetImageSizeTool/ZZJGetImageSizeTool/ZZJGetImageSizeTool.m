//
//  ZZJGetImageSizeTool.m
//  ZZJGetImageSizeTool
//
//  Created by JOE on 2017/5/25.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

#import "ZZJGetImageSizeTool.h"

@interface ZZJGetImageSizeTool ()

@property (nonatomic,strong) NSData *data;

@end

@implementation ZZJGetImageSizeTool

// 根据图片url获取图片尺寸
+ (CGSize)getImageSizeWithURL:(id)imageURL {
    NSURL *URL = nil;
    
    if ([imageURL isKindOfClass:[NSURL class]]) {
        URL = imageURL;
    }
    
    if ([imageURL isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:imageURL];
    }
    
    if (URL == nil) {
        return CGSizeZero;// url不正确返回CGSizeZero
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString *pathExtension = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if ([pathExtension isEqualToString:@"png"]) {
        size = [self getPNGImageSizeWithRequest:request];
    }else if ([pathExtension isEqualToString:@"gif"]) {
        size = [self getGIFImageSizeWithRequest:request];
    }else{
        [self getJPGImageSizeWithRequest:request];
    }
    
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSData *dataM = [self getDataWithRequest:request];
        UIImage *image = [UIImage imageWithData:dataM];
        if (image) {
            size = image.size;
        }
    }
    return size;
}

//  获取PNG图片的大小
+ (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData *dataM = [self getDataWithRequest:request];
    if(dataM.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [dataM getBytes:&w1 range:NSMakeRange(0, 1)];
        [dataM getBytes:&w2 range:NSMakeRange(1, 1)];
        [dataM getBytes:&w3 range:NSMakeRange(2, 1)];
        [dataM getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [dataM getBytes:&h1 range:NSMakeRange(4, 1)];
        [dataM getBytes:&h2 range:NSMakeRange(5, 1)];
        [dataM getBytes:&h3 range:NSMakeRange(6, 1)];
        [dataM getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

//  获取gif图片的大小
+ (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData *dataM = [self getDataWithRequest:request];
    if(dataM.length == 4)
    {
        short w1 = 0, w2 = 0;
        [dataM getBytes:&w1 range:NSMakeRange(0, 1)];
        [dataM getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [dataM getBytes:&h1 range:NSMakeRange(2, 1)];
        [dataM getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

//  获取jpg图片的大小
+ (CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData *dataM = [self getDataWithRequest:request];
    
    if ([dataM length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([dataM length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [dataM getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [dataM getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [dataM getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [dataM getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [dataM getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [dataM getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [dataM getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [dataM getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [dataM getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [dataM getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [dataM getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [dataM getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [dataM getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [dataM getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

//使用NSURLSession发起同步请求
+ (NSData *)getDataWithRequest:(NSURLRequest *)request {
    __block NSData *dataM;
    // 设置信号开始
    dispatch_semaphore_t disp = dispatch_semaphore_create(0);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error=%ld %@",error.code,error.description);
        }else{
            dataM = data;
        }
        //设置信号结束
        dispatch_semaphore_signal(disp);
    }];
    [task resume];
    dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
    return dataM;
}

@end
