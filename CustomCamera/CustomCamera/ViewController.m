//
//  ViewController.m
//  SNCustomCamera
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import "ViewController.h"
#import "SNFCreditScoreCameraService.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SNFCreditScoreCameraBaseView.h"
#import "SNFCSCImagePickerController.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *frontImage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (nonatomic, strong)SNFCreditScoreCameraService *service;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)house:(id)sender {

    [self startWithType:SNFCreditScoreCameraRealEstateBack];

}

- (IBAction)drvingFront:(id)sender {
    
    [self startWithType:SNFCreditScoreCameraDrivingFront];
    
}
- (IBAction)drvingRunBack:(id)sender {
    
    [self startWithType:SNFCreditScoreCameraRunBack];

}


- (IBAction)sender:(id)sender {
    [self startWithType:SNFCreditScoreCameraRunFront];
}

- (void)startWithType:(SNFCreditScoreCameraType)type {
    
    self.service = [[SNFCreditScoreCameraService alloc] init];
    [self.service startCameraFromVC:self cameraType:type success:^{
        
    } failure:^{
        
    } cancel:^{
        
    }];
}
@end
