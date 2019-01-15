//
//  ViewController.m
//  xiangceDemo
//
//  Created by 未来社区 on 2017/9/25.
//  Copyright © 2017年 李善. All rights reserved.
//

#import "ViewController.h"
#import "xiangeceCollection.h"
#import "JKBD_Album.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 300,100);
    btn.center = self.view.center;
    [btn setTitle:@"进入相册" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
}


- (void)touch{
    
    /*网络图片*/ NSArray *imageURLs = @[@"http://img.sccnn.com/bimg/311/011.jpg",
                       @"http://pic9.nipic.com/20100826/4376639_180752159879_2.jpg",
                       @"http://pic21.nipic.com/20120425/7156172_111847620387_2.jpg",
                       @"http://pic8.nipic.com/20100722/2194093_140126005826_2.jpg",
                       @"http://img3.redocn.com/20110418/20110415_9e86967f4b28360e5afbHmybhr1LpDJ5.jpg",
                       @"http://pic10.nipic.com/20101026/4690416_135348005709_2.jpg",
                       ];
    
//    /*本地图片*/ NSArray *imageURLs = @[@"",@"",@"",@"",@""]; //图片名字
    
    
    NSMutableArray *urls = [NSMutableArray new];
    
    for (int a= 0; a<imageURLs.count; a++) {
        
        JKBD_Album *album = [[JKBD_Album alloc]init];
        album.picture_year = @"2017-03-06"; //时间
        album.picture_path = imageURLs[a];
        [urls addObject:album];
    }
    
    
    
    xiangeceCollection *photo = [[xiangeceCollection alloc]init];
    photo.urls = urls;
    [self.navigationController pushViewController:photo animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
