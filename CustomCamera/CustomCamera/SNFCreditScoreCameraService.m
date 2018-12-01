
//
//  SNFCreditScoreCameraService.m
//  SNCustomCamera
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import "SNFCreditScoreCameraService.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SNFCreditScoreCameraBaseView.h"
#import "SNFCSCImagePickerController.h"
@interface SNFCreditScoreCameraService()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,SNFCSCImagePickerControllerDelegate>
@property (nonatomic, strong)SNFCSCImagePickerController *pickControl;
@property (nonatomic, strong)SNFCreditScoreCameraBaseView *baseView;
@end
#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
#define kScaleX  [UIScreen mainScreen].bounds.size.width / 375.f
#define kScaleY  [UIScreen mainScreen].bounds.size.height / 667.f
#define kContentFrame CGRectMake(0, 0, kWidth, kHeight-165*kScaleY)
#define SNF_IMAGE_MAXSIZE 5000000
@implementation SNFCreditScoreCameraService

- (void)startCameraFromVC:(UIViewController *_Nonnull)sourceVC
               cameraType:(SNFCreditScoreCameraType)cameraType
                  success:(void (^)(void))success
                  failure:(void (^)(void))failure
                   cancel:(void (^)(void))cancel {
    
    self.pickControl = [[SNFCSCImagePickerController alloc] init];
    self.pickControl.delegate = self;
    self.pickControl.selectDelegate = self;
    self.pickControl.baseView.cameraType = cameraType;
    [sourceVC presentViewController:self.pickControl animated:YES completion:^{
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusNotDetermined) {//第一次使用
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!granted) {//第一次，用户选择拒绝
                        [self.pickControl dismissViewControllerAnimated:YES completion:nil];
                    }
                });
            }];
        }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
            //无权限
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未获得相机权限" message:@"\n开启后才能使用拍照功能" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.pickControl dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [sourceVC presentViewController:alert animated:YES completion:nil];
        }else if (authStatus == AVAuthorizationStatusAuthorized) {//用户已授权
            
        }
    }];
    
}


#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerController:(SNFCSCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image.imageOrientation == UIImageOrientationRight && self.pickControl.baseView.cameraType != SNFCreditScoreCameraRealEstateFront && self.pickControl.baseView.cameraType != SNFCreditScoreCameraRealEstateBack) {
        //需要横屏拍摄，如果屏幕没有旋转过来，仍然是正向。这里旋转图片,横向显示
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, 0, image.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.width,
                                                 CGImageGetBitsPerComponent(image.CGImage), 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
        CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.width), image.CGImage);
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        image = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
    }
    [picker hiddenBtn];//拍照按钮隐藏  必须是拍照后隐藏，如果在拍照的同时隐藏那么会出现隐藏动画影响picker绘制问题，图片成像可能是黑色的。
    picker.preView.image = image;//预览图
    picker.preView.hidden = NO;
    picker.baseView.hidden = YES;
    
    //压缩
    NSData *data = [self compressImageWith:image];
    

}


#pragma mark -- SNFCSCImagePickerControllerDelegate
- (void)creditScoreCameraActionType:(SNFCreditScoreCameraActionType)actionType {
    switch (actionType) {
        case SNFCreditScoreCameraTakePicture://拍摄
            break;
        case SNFCreditScoreCameraBack://返回
            [self.pickControl dismissViewControllerAnimated:YES completion:^{
            }];
            self.pickControl = nil;
            break;
        case SNFCreditScoreCameraReset://重新拍摄
            break;
        case SNFCreditScoreCameraConfirm://使用图片
            //图片上传
            [self.pickControl dismissViewControllerAnimated:YES completion:nil];
            self.pickControl = nil;
            break;
        default:
            break;
    }
}

//压缩图片
- (NSData *)compressImageWith:(UIImage *)norImage {
    
    float ratio = 1.0;
    NSData *tempData = UIImageJPEGRepresentation(norImage, 1);
    ratio = (float)SNF_IMAGE_MAXSIZE / tempData.length;
    if (ratio - 1 < 0.0) {
        ratio = [[NSString stringWithFormat:@"%.2f", ratio] floatValue];
        ratio = ratio - 0.01;
        ratio = [[NSString stringWithFormat:@"%.2f", ratio] floatValue];
    } else {
        ratio = 1.0;
    }
    return UIImageJPEGRepresentation(norImage, ratio);
}


@end
