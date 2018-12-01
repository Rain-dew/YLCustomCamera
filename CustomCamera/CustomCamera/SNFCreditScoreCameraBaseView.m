//
//  SNFCreditScoreCameraBaseView.m
//  SNCustomCamera
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import "SNFCreditScoreCameraBaseView.h"
#import "UIView+YLView.h"
@interface SNFCreditScoreCameraBaseView ()
@property (nonatomic, strong)UIView *mView;//遮罩
@property (nonatomic, strong)UILabel *tipLabel;//提示语
@end

@implementation SNFCreditScoreCameraBaseView

#define kMarginX 20
#define kMarginY 10
#define kLineWidth 5
#define kLineLong 35
#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
#define kScaleX  [UIScreen mainScreen].bounds.size.width / 375.f
#define kScaleY  [UIScreen mainScreen].bounds.size.height / 667.f
#define kLineColor [UIColor colorWithRed:41/255. green:130/255. blue:254/255. alpha:1.]
- (void)drawRect:(CGRect)rect {

    //绘制一个遮罩
    //贝塞尔曲线 画一个带有圆角的矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:0];
    //贝塞尔曲线 画一个矩形
    [bpath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kMarginX, kMarginY, self.frame.size.width-kMarginX*2, self.frame.size.height - kMarginY * 2) cornerRadius:0] bezierPathByReversingPath]];
    
   
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    
    //添加图层蒙板
    self.mView.layer.mask = shapeLayer;
    
    UIColor *color = kLineColor;
    [color set]; //设置线条颜色
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //左上角
    [path moveToPoint:CGPointMake(kMarginX + kLineWidth/2, kMarginY + kLineLong + kLineWidth/2)];
    [path addLineToPoint:CGPointMake(kMarginX + kLineWidth/2, kMarginY + kLineWidth/2)];
    [path addLineToPoint:CGPointMake(kMarginY + kLineLong + kLineWidth/2, kMarginY + kLineWidth/2)];
    path.lineWidth = kLineWidth;
    
    //左下角
    [path moveToPoint:CGPointMake(kMarginX + kLineWidth/2, CGRectGetHeight(self.frame) - kMarginY - kLineLong)];
    [path addLineToPoint:CGPointMake(kMarginX + kLineWidth/2, CGRectGetHeight(self.frame) - kMarginY - kLineWidth/2)];
    [path addLineToPoint:CGPointMake(kMarginX + kLineLong + kLineWidth/2, CGRectGetHeight(self.frame) - kMarginY - kLineWidth/2)];
    path.lineWidth = kLineWidth;
    
    //右上角
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame) - kMarginX - kLineLong - kLineWidth/2, kMarginY + kLineWidth/2)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - kMarginX - kLineWidth/2, kMarginY + kLineWidth/2)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - kMarginX - kLineWidth/2, kMarginY + kLineLong + kLineWidth/2)];
    path.lineWidth = kLineWidth;
    
    //右下角
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame) - kMarginX - kLineLong - kLineWidth/2, CGRectGetHeight(self.frame) - kMarginY - kLineWidth/2)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - kMarginX - kLineWidth/2, CGRectGetHeight(self.frame) - kMarginY - kLineWidth/2)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - kMarginX - kLineWidth/2, CGRectGetHeight(self.frame) - kMarginY - kLineLong)];
    path.lineWidth = kLineWidth;
    
    [path stroke];
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //遮罩View
        self.mView = [[UIView alloc] initWithFrame:self.bounds];
        self.mView.backgroundColor = [UIColor blackColor];
        self.mView.alpha = 0.5;
        [self addSubview:self.mView];
 
        //印章
        self.sealView = [[UIView alloc] initWithFrame:CGRectMake(37 + kMarginX, 10 + kMarginY, 115*kScaleX, 117*kScaleY)];
        self.sealView.layer.borderColor = kLineColor.CGColor;
        self.sealView.layer.borderWidth = 2.;
        //照片
        self.photoView = [[UIView alloc] initWithFrame:CGRectMake(10 + kMarginX, CGRectGetHeight(self.frame) - kMarginY - 10 - 123*kScaleY, 168*kScaleX, 123*kScaleY)];
        self.photoView.layer.borderColor = kLineColor.CGColor;
        self.photoView.layer.borderWidth = 2.;
       
        //标题
        self.titileView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - kMarginX - 20 - 42*kScaleY, 0, 45*kScaleY, 300*kScaleX)];
        self.titileView.yl_midY = self.yl_midY;
        self.titileView.layer.borderColor = kLineColor.CGColor;
        self.titileView.layer.borderWidth = 2.;
        
        //提示
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300*kScaleX, 25)];
        self.tipLabel.center = self.mView.center;
        self.tipLabel.font = [UIFont systemFontOfSize:19*kScaleY];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.transform = CGAffineTransformRotate(self.tipLabel.transform, M_PI_2);
        self.tipLabel.text = @"请将证件放到框内，并调整好光线";
  
    }
    
    return self;
}

- (void)setCameraType:(SNFCreditScoreCameraType)cameraType {
    _cameraType = cameraType;
    
    switch (cameraType) {
        case SNFCreditScoreCameraDrivingFront://驾驶证正面
            [self addSubview:self.photoView];
            [self addSubview:self.titileView];
            [self addSubview:self.sealView];
            [self addSubview:self.tipLabel];
            break;
        case SNFCreditScoreCameraRunFront://行驶证正面
            [self addSubview:self.titileView];
            [self addSubview:self.sealView];
            [self addSubview:self.tipLabel];
            break;
        case SNFCreditScoreCameraDrivingBack://驾驶证背面
        case SNFCreditScoreCameraRunBack://行驶证背面
            [self addSubview:self.tipLabel];
            break;
        case SNFCreditScoreCameraRealEstateFront://房产正
        case SNFCreditScoreCameraRealEstateBack://房产背
            self.tipLabel.transform = CGAffineTransformRotate(self.tipLabel.transform, -M_PI_2);
            [self addSubview:self.tipLabel];
            break;
        default:
            break;
    }
}


@end
