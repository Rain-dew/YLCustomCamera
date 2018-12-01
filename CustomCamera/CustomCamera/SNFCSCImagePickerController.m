//
//  SNFCSCImagePickerController.m
//  SNCustomCamera
//
//  Created by User on 2018/8/30.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import "SNFCSCImagePickerController.h"
#import "UIView+YLView.h"
@interface SNFCSCImagePickerController ()
@property (nonatomic, strong)UIButton *startBtn;//拍摄按钮
@property (nonatomic, strong)UIButton *cancelBtn;//取消拍摄按钮
@end
#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
#define kScaleX  [UIScreen mainScreen].bounds.size.width / 375.f
#define kScaleY  [UIScreen mainScreen].bounds.size.height / 667.f
#define kContentFrame CGRectMake(0, 0, kWidth, kHeight-165*kScaleY)
@implementation SNFCSCImagePickerController

- (instancetype)init {
    
    if (self = [super init]) {
       
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.showsCameraControls = NO;
        //预览图
        [self.view addSubview:self.preView];
        //遮罩区
        self.baseView = [[SNFCreditScoreCameraBaseView alloc] initWithFrame:kContentFrame];
        [self.view addSubview:self.baseView];
        self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.startBtn.frame  = CGRectMake(0, kHeight - 90 - 30*kScaleY, 90, 90);
        self.startBtn.yl_midX = self.view.yl_midX;
        [self.startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"startBtn"] forState:UIControlStateNormal];
        [self.view addSubview:self.startBtn];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame  = CGRectMake(20, self.startBtn.yl_midY - 10, 50, 20);
        [self.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [self.view addSubview:self.cancelBtn];
        
    }
    return self;
}

//拍照
- (void)start:(UIButton *)sender {
    [self takePicture];
    if ([self.selectDelegate respondsToSelector:@selector(creditScoreCameraActionType:)]) {
        [self.selectDelegate creditScoreCameraActionType:SNFCreditScoreCameraTakePicture];
    }
}
//返回
- (void)cancel:(UIButton *)sender {
    if ([self.selectDelegate respondsToSelector:@selector(creditScoreCameraActionType:)]) {
        [self.selectDelegate creditScoreCameraActionType:SNFCreditScoreCameraBack];
    }
}
//重置相机
- (void)reset:(UIButton *)sender {
    if ([self.selectDelegate respondsToSelector:@selector(creditScoreCameraActionType:)]) {
        [self.selectDelegate creditScoreCameraActionType:SNFCreditScoreCameraReset];
    }
    self.preView.hidden = YES;
    self.baseView.hidden = NO;
    [self showBtn];
}
- (void)confirm:(UIButton *)sender {
    if ([self.selectDelegate respondsToSelector:@selector(creditScoreCameraActionType:)]) {
        [self.selectDelegate creditScoreCameraActionType:SNFCreditScoreCameraConfirm];
    }
    self.baseView.contentImage.backgroundColor = [UIColor clearColor];
    self.baseView.contentImage.image = nil;
}
- (UIImageView *)preView {
    if (!_preView) {
        _preView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _preView.backgroundColor = [UIColor blackColor];
        _preView.contentMode = UIViewContentModeScaleAspectFit;
        _preView.userInteractionEnabled = YES;
        _preView.hidden = YES;
        //重置按钮，确定按钮
        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        resetBtn.frame = CGRectMake(20, CGRectGetMaxY(_preView.frame) - 50, 50, 20);
        [resetBtn addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
        [resetBtn setTitle:@"重拍" forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        resetBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [_preView addSubview:resetBtn];
        //使用图片按钮
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(CGRectGetMaxX(_preView.frame) - 100, CGRectGetMaxY(_preView.frame) - 50, 80, 20);
        [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"使用照片" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [_preView addSubview:confirmBtn];
        
    }
    return _preView;
}

- (void)hiddenBtn {
    self.startBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
}
- (void)showBtn {
    self.startBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
}
@end
