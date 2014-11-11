//
//  WQAdView.m
//  WQAdvertisingColumn
//
//  Created by 吴跃文 on 14/11/7.
//  Copyright (c) 2014年 com.wyw. All rights reserved.
//

#import "WQAdView.h"
#define KPCheight 20    //pageController高度


@implementation WQAdView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.adPeriodTime=2.0f;
        self.adDataArray=[NSMutableArray array];
        self.adAutoplay=YES;
        [self setAdScrollView];
        [self setPageControl];
    }
    return self;
}

-(void)setAdScrollView{
    self.adScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectW(self), CGRectH(self))];
    self.adScrollView.pagingEnabled=YES;
    self.adScrollView.delegate=self;
    self.adScrollView.showsHorizontalScrollIndicator=NO;
    [self addSubview:self.adScrollView];
}

-(void)setPageControl{
    self.adPageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectH(self.adScrollView)-KPCheight, CGRectW(self.adScrollView), KPCheight)];
    self.adPageControl.numberOfPages=1;
    [self addSubview:self.adPageControl];
    self.adPageControl.center=CGPointMake(self.center.x, self.adPageControl.center.y);
}

#pragma mark -加载并播放广告数据内容
-(void)loadAdDataThenStart{
    if (self.adDataArray.count<=0) {
        [[[UIAlertView alloc]initWithTitle:@"广告加载失败" message:@"确认是否成功往WQAdview的adDataArray中添加image" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        return;
    }
    [self.adScrollView setContentSize:CGSizeMake(CGRectW(self.adScrollView)*(self.adDataArray.count+2), CGRectH(self.adScrollView))];
    self.adPageControl.numberOfPages=self.adDataArray.count;
    
    for (int i=0; i<self.adDataArray.count; i++) {
        UIImage *adImg=self.adDataArray[i];
        UIButton *adBtn=[[UIButton alloc]initWithFrame:CGRectMake((i+1)*CGRectW(self.adScrollView), 0, CGRectW(self.adScrollView), CGRectH(self.adScrollView))];
        [adBtn setBackgroundImage:adImg forState:UIControlStateNormal];
        [adBtn setBackgroundImage:adImg forState:UIControlStateHighlighted];
        [adBtn setContentMode:UIViewContentModeScaleToFill];
        adBtn.tag=i;
        [adBtn addTarget:self action:@selector(adBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.adScrollView addSubview:adBtn];
    }
    
    UIImage *lastAdImg=self.adDataArray[self.adDataArray.count-1];
    UIButton *lastAdBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectW(self.adScrollView), CGRectH(self.adScrollView))];
    [lastAdBtn setBackgroundImage:lastAdImg forState:UIControlStateNormal];
    [lastAdBtn setBackgroundImage:lastAdImg forState:UIControlStateHighlighted];
    [lastAdBtn setContentMode:UIViewContentModeScaleToFill];
    [self.adScrollView addSubview:lastAdBtn];
    
    UIImage *firstImg=self.adDataArray[0];
    UIButton *firstAdBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.adDataArray.count+1)*CGRectW(self.adScrollView), 0, CGRectW(self.adScrollView), CGRectH(self.adScrollView))];
    [firstAdBtn setBackgroundImage:firstImg forState:UIControlStateNormal];
    [firstAdBtn setBackgroundImage:firstImg forState:UIControlStateHighlighted];
    [firstAdBtn setContentMode:UIViewContentModeScaleToFill];
    [self.adScrollView addSubview:firstAdBtn];
    
    [self.adScrollView setContentOffset:CGPointMake(CGRectW(self.adScrollView), 0)];
    
    if (self.adAutoplay) {
        if (!self.adLoopTimer) {
            self.adLoopTimer = [NSTimer scheduledTimerWithTimeInterval:self.adPeriodTime target:self selector:@selector(loopAd) userInfo:nil repeats:YES];
        }
    }

    
}

#pragma mark - 循环播放
-(void)loopAd{
    CGFloat pageWidth = self.adScrollView.frame.size.width;
    int currentPage = self.adScrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.adPageControl.currentPage = self.adPageControl.numberOfPages-1;
    }
    else if (currentPage == self.adPageControl.numberOfPages+1) {
        self.adPageControl.currentPage = 0;
    }
    else {
        self.adPageControl.currentPage = currentPage-1;
    }
    
    __block NSInteger currPageNumber = self.adPageControl.currentPage;
    CGSize viewSize = self.adScrollView.frame.size;
    CGRect rect = CGRectMake((currPageNumber+2)*pageWidth, 0, viewSize.width, viewSize.height);
    
    [UIView animateWithDuration:0.7 animations:^{
        [self.adScrollView scrollRectToVisible:rect animated:NO];
    } completion:^(BOOL finished) {
        currPageNumber++;
        if (currPageNumber == self.adPageControl.numberOfPages) {
            [self.adScrollView setContentOffset:CGPointMake(CGRectW(self.adScrollView), 0)];
            currPageNumber = 0;
        }
    }];
    
    currentPage = self.adScrollView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        self.adPageControl.currentPage = self.adPageControl.numberOfPages-1;
    }
    else if (currentPage == self.adPageControl.numberOfPages+1) {
        self.adPageControl.currentPage = 0;
    }
    else {
        self.adPageControl.currentPage = currentPage-1;
    }
}
#pragma mark---- UIScrollView delegate methods

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        NSInteger currentAdPage;
        currentAdPage=self.adScrollView.contentOffset.x/CGRectW(self.adScrollView);
        if (currentAdPage==0) {
            [scrollView scrollRectToVisible:CGRectMake(CGRectW(self.adScrollView)*self.adPageControl.numberOfPages, 0, CGRectW(self.adScrollView), CGRectH(self.adScrollView)) animated:NO];
            currentAdPage=self.adPageControl.numberOfPages-1;
        }
        else if (currentAdPage==(self.adPageControl.numberOfPages+1)) {
            [scrollView scrollRectToVisible:CGRectMake(CGRectW(self.adScrollView), 0, CGRectW(self.adScrollView), CGRectH(self.adScrollView)) animated:NO];
            currentAdPage=0;
        }
        else{
            currentAdPage=currentAdPage-1;
        }
        self.adPageControl.currentPage=currentAdPage;
    
    if (self.adAutoplay) {
        if (!self.adLoopTimer) {
            self.adLoopTimer = [NSTimer scheduledTimerWithTimeInterval:self.adPeriodTime target:self selector:@selector(loopAd) userInfo:nil repeats:YES];
        }
    }

}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动scrollview的时候 停止计时器控制的跳转
    if (self.adAutoplay) {
        if (self.adLoopTimer) {
            [self.adLoopTimer invalidate];
            self.adLoopTimer = nil;
        }
    }
}

#pragma mark - 点击
-(void)adBtnClick:(UIButton *)sender{
    [self.delegate adView:self didDeselectAdAtNum:sender.tag];
}
@end
