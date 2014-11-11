//
//  ViewController.h
//  WQAdvertisingColumn
//
//  Created by 吴跃文 on 14/11/7.
//  Copyright (c) 2014年 com.wyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQAdView.h"
@interface ViewController : UIViewController<WQAdViewDelagate,UIAlertViewDelegate>
@property(nonatomic,strong)WQAdView *adView;

@end

