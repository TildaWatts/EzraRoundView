//
//  EzraRoundView.m
//  EzraRoundView
//
//  Created by Ezra on 2017/6/9.
//  Copyright © 2017年 Ezra. All rights reserved.
//

#import "EzraRoundView.h"

#import "UIColor+Hex.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式


static CGFloat  lineWidth = 4;   // 线宽

static CGFloat  progressLineWidth = 1;  // 外圆进度的线宽


@interface EzraRoundView ()

@property (nonatomic,strong) CAShapeLayer *bottomShapeLayer; // 外圆的底层layer
@property (nonatomic,strong)CAGradientLayer *progressBottomGradieLayer;//底部渐变色

@property (nonatomic,strong) CAGradientLayer *progressingGradietntLayer;//外圆进度左下角渐变

@property (nonatomic,assign)CGFloat startAngle;  // 开始的弧度
@property (nonatomic,assign)CGFloat endAngle;  // 结束的弧度
@property (nonatomic,assign)CGFloat radius; // 内圆半径
@property (nonatomic,assign)CGFloat progressRadius; // 外圆半径

@property (nonatomic,assign)CGFloat centerX;  // 中心点 x
@property (nonatomic,assign)CGFloat centerY;  // 中心点 y

@property (nonatomic,strong)UILabel *progressView;  //  进度文字

@property (nonatomic,strong)CAShapeLayer *progressBottomLayer; // 底部进度条的layer


@property (nonatomic,assign) int ratio;  // 记录百分比 用于数字跳动

//指示器
@property (nonatomic, strong) UIImageView *markerImageView;
@property (nonatomic, strong) CAKeyframeAnimation *pathAnimation;

@end

@implementation EzraRoundView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self  drawLayers];
        
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [self drawLayers];
        
    }
    return self;
}

- (void)drawLayers
{
    self.backgroundColor = [UIColor whiteColor];
    
    
    _startAngle = - 232;  // 启始角度
    _endAngle = 51;  // 结束角度
    
    _centerX = self.frame.size.width / 2;  // 控制圆盘的X轴坐标
    _centerY = self.frame.size.height / 2  + 20; // 控制圆盘的Y轴坐标
    
    _radius = (self.bounds.size.width - 187 - lineWidth) / 2;  // 内圆的角度
    _progressRadius = (self.bounds.size.width - 187 - progressLineWidth + 30) / 2; // 外圆的角度
    
    //外圆
    [self drawProgressBottomLayer];  // 绘制外圆的底层layer
    [self draProgressBottomGradieLayer];//渐变底色
    [self drawProgressingLayer];//进度条颜色
    [self drawProgressingGradientLayer];//进度渐变；
    
    
    [self.layer addSublayer:_progressBottomLayer];
    [_progressBottomGradieLayer setMask:_progressBottomLayer];
    [self.layer addSublayer:_progressBottomGradieLayer];
    
    //    [self.layer addSublayer:_progressingLayer];  // 把更新的layer 添加到 底部的layer 上
    [_progressingGradietntLayer setMask:_progressingLayer];
    [self.layer addSublayer:_progressingGradietntLayer];
    
    //内圆
    [self drawBottomLayer];
    [self drawUpperLayer];
    [self.layer addSublayer:_bottomShapeLayer];
    [self.layer addSublayer:_upperShapeLayer];
    
    
}

- (UILabel *)progressView
{
    if (!_progressView) {
        
        _progressView = [[UILabel alloc]init];
        
        CGFloat width = 160;
        CGFloat height = 60;
        _progressView.frame = CGRectMake((self.frame.size.width - width) / 2, _centerY - height / 2, width, height);
        _progressView.font = [UIFont systemFontOfSize:60];
        _progressView.backgroundColor = [UIColor greenColor];
        _progressView.textAlignment = NSTextAlignmentCenter;
        _progressView.textColor = [UIColor redColor];
        _progressView.text = @"0%";
    }
    
    return _progressView;
}

//外圆底部
- (CAShapeLayer *)drawProgressBottomLayer
{
    
    
    _progressBottomLayer                 = [[CAShapeLayer alloc] init];
    _progressBottomLayer.frame           = self.bounds;
    UIBezierPath *path                   = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY)
                                                                          radius:_progressRadius
                                                                      startAngle:degreesToRadians(_startAngle)
                                                                        endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    _progressBottomLayer.path   = path.CGPath;
    
#pragma mark - 线段的开头为圆角
    _progressBottomLayer.lineCap = kCALineCapRound;
    _progressBottomLayer.lineWidth = progressLineWidth;
    _progressBottomLayer.strokeColor     = [UIColor grayColor].CGColor;
    _progressBottomLayer.fillColor       = [UIColor clearColor].CGColor;
    
    return _progressBottomLayer;
}

//外圆底色（渐变）
- (CAGradientLayer *)draProgressBottomGradieLayer
{
    
    _progressBottomGradieLayer = [CAGradientLayer layer];
    _progressBottomGradieLayer.frame = self.bounds;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    //上
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, width, height);
    gradientLayer1.colors = @[(__bridge id)[UIColor colorWithHexString:@"FF4C4C"].CGColor,
                              (__bridge id)[UIColor colorWithHexString:@"FFB94A"].CGColor];
    gradientLayer1.startPoint = CGPointMake(0, 0);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    
    //左下
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(0, height/2.0, width/2.0,  height/2.0);
    gradientLayer2.colors = @[(__bridge id)[UIColor colorWithHexString:@"FF4C4C"].CGColor,
                              (__bridge id)[UIColor colorWithHexString:@"FFFFFF" alpha:1].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(0, 1);
    
    //右下
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.frame = CGRectMake(width/2.0, height/2.0, width/2.0,  height/2.0);
    gradientLayer3.colors = @[(__bridge id)[UIColor colorWithHexString:@"FFB94A"].CGColor,
                              (__bridge id)[UIColor colorWithHexString:@"FFFFFF" alpha:1].CGColor];
    gradientLayer3.startPoint = CGPointMake(0, 0);
    gradientLayer3.endPoint = CGPointMake(0, 1);
    
    [_progressBottomGradieLayer addSublayer:gradientLayer1];
    [_progressBottomGradieLayer addSublayer:gradientLayer2];
    [_progressBottomGradieLayer addSublayer:gradientLayer3];
    [gradientLayer1 setLocations:@[@0.35,@0.75]];
    [gradientLayer3 setLocations:@[@0.2,@0.75]];
    [gradientLayer2 setLocations:@[@0.2,@0.75]];
    
    return _progressBottomGradieLayer;
}


- (CAShapeLayer *)drawProgressingLayer//进度条红色
{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY )
                                                              radius:_progressRadius  startAngle:degreesToRadians(_startAngle)
                                                            endAngle:degreesToRadians(_endAngle )  clockwise:YES];
    
    _progressingLayer = [CAShapeLayer layer];
    _progressingLayer.frame = self.bounds;
    _progressingLayer.lineCap = kCALineCapRound;
    _progressingLayer.path = bezierPath.CGPath;
    _progressingLayer.fillColor = [UIColor clearColor].CGColor;
    _progressingLayer.strokeColor = [UIColor redColor].CGColor;
    _progressingLayer.lineWidth = progressLineWidth+0.5;
    //    _progressingLayer.strokeStart = 0;
    _progressingLayer.strokeEnd = 0;
    
    return _progressingLayer;
}

//外圆进度条左下渐变
- (CAGradientLayer *)drawProgressingGradientLayer
{
    _progressingGradietntLayer = [CAGradientLayer layer];
    _progressingGradietntLayer.frame = self.bounds;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    //上
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, width, height);
    gradientLayer1.colors = @[(__bridge id)[UIColor colorWithHexString:@"FF0000"].CGColor,
                              (__bridge id)[UIColor colorWithHexString:@"FF0000"].CGColor];
    gradientLayer1.startPoint = CGPointMake(0, 0);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    
    //左下
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(0, height/2.0, width/2.0,  height/2.0);
    gradientLayer2.colors = @[(__bridge id)[UIColor colorWithHexString:@"FF0000"].CGColor,
                              (__bridge id)[UIColor colorWithHexString:@"FFFFFF" alpha:1].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(0, 1);
    
    //右下
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.frame = CGRectMake(width/2.0, height/2.0, width/2.0,  height/2.0);
    gradientLayer3.colors = @[(__bridge id)[UIColor colorWithHexString:@"FF0000"].CGColor,
                              (__bridge id)[UIColor colorWithHexString:@"FF0000" alpha:1].CGColor];
    gradientLayer3.startPoint = CGPointMake(0, 0);
    gradientLayer3.endPoint = CGPointMake(0, 1);
    
    [_progressingGradietntLayer addSublayer:gradientLayer1];
    [_progressingGradietntLayer addSublayer:gradientLayer2];
    [_progressingGradietntLayer addSublayer:gradientLayer3];
    [gradientLayer1 setLocations:@[@0.35,@0.75]];
    [gradientLayer3 setLocations:@[@0.35,@0.75]];
    [gradientLayer2 setLocations:@[@0.2,@0.75]];
    
    return _progressingGradietntLayer;
}



// 内圆绘制底部的layer
- (CAShapeLayer *)drawBottomLayer
{
    _bottomShapeLayer                 = [[CAShapeLayer alloc] init];
    _bottomShapeLayer.frame           = self.bounds;
    
    
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY)
                                                                       radius:_radius
                                                                   startAngle:degreesToRadians(_startAngle)
                                                                     endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    
    _bottomShapeLayer.path            = path.CGPath;
    _bottomShapeLayer.lineCap         = kCALineCapButt;
    _bottomShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2.2],[NSNumber numberWithInt:3.5], nil];
    _bottomShapeLayer.lineWidth       = lineWidth;
    _bottomShapeLayer.strokeColor     = [UIColor colorWithHexString:@"FE9999"].CGColor;
    _bottomShapeLayer.fillColor       = [UIColor clearColor].CGColor;
    return _bottomShapeLayer;
}
//内圆进度
- (CAShapeLayer *)drawUpperLayer
{
    _upperShapeLayer                 = [[CAShapeLayer alloc] init];
    _upperShapeLayer.frame           = self.bounds;
    
    
    UIBezierPath *path                = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY)
                                                                       radius:_radius
                                                                   startAngle:degreesToRadians(_startAngle)
                                                                     endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    
    
    _upperShapeLayer.path            = path.CGPath;
    _upperShapeLayer.strokeStart = 0;
    _upperShapeLayer.strokeEnd =   0;
    //    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0.3];
    _upperShapeLayer.lineWidth = lineWidth;
    _upperShapeLayer.lineCap = kCALineCapButt;
    _upperShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2.2],[NSNumber numberWithInt:3.5], nil];
    _upperShapeLayer.strokeColor     = [UIColor redColor].CGColor;
    _upperShapeLayer.fillColor       = [UIColor clearColor].CGColor;
    
    
    return _upperShapeLayer;
}

//指示器
- (UIImageView *)markerImageView {
    
    CGFloat height = self.frame.size.height;
    
    if (nil == _markerImageView) {
        _markerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100, height, 10, 10)];
        _markerImageView.image = [UIImage imageNamed:@"指示点"];
        
    }
    return _markerImageView;
}
- (void)createAnimationWithEndAngle:(CGFloat)endAngle
{
    _pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    _pathAnimation.calculationMode = kCAAnimationPaced;
    _pathAnimation.fillMode = kCAFillModeForwards;
    _pathAnimation.removedOnCompletion = NO;
    _pathAnimation.duration = 2;
    _pathAnimation.repeatCount = 1;
    
    
    // 设置动画路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL,_centerX, _centerY, _progressRadius, degreesToRadians(_startAngle), degreesToRadians(_startAngle + 283*endAngle), NO);
    _pathAnimation.path = path;
    CGPathRelease(path);
    
    //    //指示器
    [self addSubview:self.markerImageView];
    [self.markerImageView.layer addAnimation:_pathAnimation forKey:@"moveMarker"];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@synthesize percent = _percent;

- (void)setMaximum:(CGFloat)maximum
{
    if (maximum <= 0) {
        maximum = 1;
    }
    
    _maximum = maximum;
}

- (CGFloat )percent
{
    return _percent;
}
- (void)setPercent:(CGFloat)percent
{
    
    if (percent > 10000) {
        percent = 10000;
    }
    else if(percent<0){
        percent = 0;
    }
    else if (self.maximum < percent)
    {
        percent = 1;
    }
    
    _percent = percent / self.maximum ;
    
    self.ratio = percent * 100;
    
    
    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0];
    
}

- (void)shapeChange
{
    
    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
    _progressingLayer.strokeEnd = 0 ;
    _upperShapeLayer.strokeEnd = 0 ;
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:2.f];
    _progressingLayer.strokeEnd = _percent;;
    _upperShapeLayer.strokeEnd = _percent;;
    [self createAnimationWithEndAngle:_percent];
    
    [CATransaction commit];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_percent * 0.02 target:self selector:@selector(updateLabl:) userInfo:nil repeats:YES];
    
}

- (void)updateLabl:(NSTimer *)sender
{
    static int flag = 0;
    
    if (flag   == self.ratio) {
        
        
        [sender invalidate];
        sender = nil;
        
        self.progressView.text = [NSString stringWithFormat:@"%d",flag];
        
        flag = 0;
        
        
    }
    else
    {
        self.progressView.text = [NSString stringWithFormat:@"%d",flag];
        
    }
    
    flag ++;
    
    
    
}

@end
