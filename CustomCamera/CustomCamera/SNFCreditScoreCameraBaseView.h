//
//  SNFCreditScoreCameraBaseView.h
//  SNCustomCamera
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import <UIKit/UIKit.h>
//相机类型
typedef NS_ENUM(NSInteger, SNFCreditScoreCameraType) {
    //横屏
    SNFCreditScoreCameraDrivingFront = 0,//驾驶证正面
    SNFCreditScoreCameraDrivingBack,//驾驶证背面
    SNFCreditScoreCameraRunFront,//行驶证正面
    SNFCreditScoreCameraRunBack,//行驶证背面
    //竖屏
    SNFCreditScoreCameraRealEstateFront,//房产、不动产正面
    SNFCreditScoreCameraRealEstateBack//房产、不动产背面
};
@interface SNFCreditScoreCameraBaseView : UIView
@property (nonatomic, assign)SNFCreditScoreCameraType cameraType;
@property (nonatomic, strong)UIView *sealView;//印章
@property (nonatomic, strong)UIView *titileView;//标题
@property (nonatomic, strong)UIView *photoView;//照片
@property (nonatomic, strong)UIImageView *contentImage;//照片

@end
