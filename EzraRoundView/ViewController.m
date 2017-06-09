//
//  ViewController.m
//  EzraRoundView
//
//  Created by Ezra on 2017/6/9.
//  Copyright © 2017年 Ezra. All rights reserved.
//

#import "ViewController.h"
#import "EzraRoundView.h"


@interface ViewController ()
@property (nonatomic,strong) EzraRoundView *roundView;
@end

@implementation ViewController

- (EzraRoundView *)roundView
{
    if (!_roundView) {
        
        _roundView = [[EzraRoundView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
    }
    
    return _roundView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.roundView];
    //满值
    self.roundView.maximum = 3000;
    //期望值
    self.roundView.percent = 3000;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 传入百分比的时候，传入 小数，  0.1 - 1 范围内  <==>  1 - 100
    //    self.roundView.percent = arc4random_uniform(100 + 1);
    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
    self.roundView.progressingLayer.strokeEnd = 0 ;
    self.roundView.upperShapeLayer.strokeEnd = 0 ;
    [CATransaction commit];
    self.roundView.maximum = 0;
    self.roundView.percent = 3000;
}

@end
