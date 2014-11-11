//
//  ViewController.m
//  WQAdvertisingColumn
//
//  Created by 吴跃文 on 14/11/7.
//  Copyright (c) 2014年 com.wyw. All rights reserved.
//

#import "ViewController.h"
#define kAdBtnHeight 115
@interface ViewController (){
    UIAlertView *alertView;
    NSTimer *timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    alertView=[[UIAlertView alloc]init];
    alertView.delegate=self;
    timer =[NSTimer timerWithTimeInterval:1 target:self selector:@selector(alertViewDismiss) userInfo:nil repeats:YES];
    self.adView=[[WQAdView alloc]initWithFrame:CGRectMake(0, 0,CGRectW(self.view) , kAdBtnHeight)];
    self.adView.delegate=self;
    NSArray *imgArray=@[
                        [UIImage imageNamed:@"banner1"],
                        [UIImage imageNamed:@"banner2"],
                        [UIImage imageNamed:@"banner3"]
                         ];
    //设置广告图片
    self.adView.adDataArray=[NSMutableArray arrayWithArray:imgArray];
    //self.adView.adAutoplay=NO;
    [self.adView loadAdDataThenStart];
    [self.view addSubview:self.adView];
}

#pragma mark - 广告栏点击
-(void)adView:(WQAdView *)adView didDeselectAdAtNum:(NSInteger)num{
    alertView.title=[NSString stringWithFormat:@"选中了第%ld个广告",(long)(++num)];
    [alertView show];
    [timer fire];
}

-(void)alertViewDismiss{
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
}

@end
