//
//  SNFCSCImagePickerController.h
//  SNCustomCamera
//
//  Created by User on 2018/8/30.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNFCreditScoreCameraBaseView.h"

typedef NS_ENUM(NSInteger, SNFCreditScoreCameraActionType) {
    SNFCreditScoreCameraTakePicture = 0,//拍摄
    SNFCreditScoreCameraBack,//返回
    SNFCreditScoreCameraReset,//重置相机
    SNFCreditScoreCameraConfirm,//使用图片
};
@protocol SNFCSCImagePickerControllerDelegate <NSObject>
//自定义图层按钮点击
- (void)creditScoreCameraActionType:(SNFCreditScoreCameraActionType)actionType;
@end

@interface SNFCSCImagePickerController : UIImagePickerController

@property (nonatomic, weak)id<SNFCSCImagePickerControllerDelegate> selectDelegate;
@property (nonatomic, strong)UIImageView *preView;
@property (nonatomic, strong)SNFCreditScoreCameraBaseView *baseView;
- (void)hiddenBtn;
@end
