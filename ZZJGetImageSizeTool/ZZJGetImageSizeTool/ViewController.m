//
//  ViewController.m
//  ZZJGetImageSizeTool
//
//  Created by JOE on 2017/5/25.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

#import "ViewController.h"
#import "ZZJGetImageSizeTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *url = @"http://54.223.77.112/read_admin/Public/ans_image/5923cea576b67.jpg";
    NSString *url1 = @"http://54.223.77.112/read_admin/Public/ans_image/592405107c484.png";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, 400, 300)];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url1]];
    imageView.image = [UIImage imageWithData:data];
    [self.view addSubview:imageView];
    
    CGSize size = [ZZJGetImageSizeTool getImageSizeWithURL:url1];
    NSLog(@"size=%@",NSStringFromCGSize(size));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
