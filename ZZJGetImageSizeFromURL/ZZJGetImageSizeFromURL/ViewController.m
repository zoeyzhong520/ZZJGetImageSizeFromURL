//
//  ViewController.m
//  ZZJGetImageSizeFromURL
//
//  Created by JOE on 2017/5/22.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Util.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *url = @"http://54.223.77.112/read_admin/Public/student_img/591a7e9a9b8a7.jpg";
    NSString *url1 = @"http://54.223.77.112/read_admin/Public/student_img/58dcc6108ccf0.png";
    
    
    CGSize imageSize = [UIImage getImageSizeWithURL:url];
    NSLog(@"iamgeSize=%@",NSStringFromCGSize(imageSize));
    
    CGSize imageSize1 = [UIImage getImageSizeWithURL:url1];
    NSLog(@"iamgeSize1=%@",NSStringFromCGSize(imageSize1));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
