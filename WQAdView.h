//
//  WQAdView.h
//  WQAdvertisingColumn
//
//  Created by 吴跃文 on 14/11/7.
//  Copyright (c) 2014年 com.wyw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WQAdViewDelagate;

@interface WQAdView : UIView<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *adScrollView;
@property(nonatomic,strong) UIPageControl *adPageControl;
@property(nonatomic,retain) NSTimer *adLoopTimer;
@property(nonatomic,retain) NSMutableArray *adDataArray;  //广告图片数组
@property(nonatomic,assign) CGFloat adPeriodTime; //切换广告时间,默认2秒
@property(nonatomic,assign) BOOL adAutoplay;  //是否自动播放广告,默认yes
@property(nonatomic,weak) id<WQAdViewDelagate>delegate;

-(void)loadAdDataThenStart;  //加载广告图片并开始播放
@end
@protocol WQAdViewDelagate <NSObject>

-(void)adView:(WQAdView *)adView didDeselectAdAtNum:(NSInteger)num;

@end