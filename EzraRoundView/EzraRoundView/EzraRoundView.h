//
//  EzraRoundView.h
//  EzraRoundView
//
//  Created by Ezra on 2017/6/9.
//  Copyright © 2017年 Ezra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EzraRoundView : UIView

@property (nonatomic,assign) CGFloat percent;

@property (nonatomic, assign) CGFloat maximum;
@property (nonatomic,strong)CAShapeLayer *upperShapeLayer;  // 内圆的更新的layer
@property (nonatomic,strong) CAShapeLayer *progressingLayer;//外圆进度条

@end
