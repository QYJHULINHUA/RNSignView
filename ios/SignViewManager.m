//
//  SignViewManager.m
//  signPrj
//
//  Created by jk on 2018/3/6.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SignViewManager.h"
#import "SignView.h"

#import <React/RCTBridge.h>           //进行通信的头文件
#import <React/RCTEventDispatcher.h> //事件派发，不导入会引起Xcode警告
#import <React/RCTUIManager.h>

@implementation SignViewManager


RCT_EXPORT_MODULE(SignView)

RCT_EXPORT_VIEW_PROPERTY(signLineColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(signViewColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(placeHoalderColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(signLineWidth, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(signPlaceHoalder, NSString)


- (UIView *)view
{
  return [[SignView alloc] initWithBridge:self.bridge];
}

RCT_EXPORT_METHOD(clearSignAction:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused RCTUIManager *uiManager, NSDictionary *viewRegistry){
     SignView *sign = viewRegistry[reactTag];
     
     if ([sign isKindOfClass:[SignView class]]) {
       [sign clearSignAction];
     } else {
       RCTLogError(@"Cannot stopRefreshing: %@ (tag #%@) is not RNTableView", sign, reactTag);
     }
   }];
}


RCT_EXPORT_METHOD(signDone:(nonnull NSNumber *)reactTag
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused RCTUIManager *uiManager, NSDictionary *viewRegistry){
     SignView *sign = viewRegistry[reactTag];
    
     if ([sign isKindOfClass:[SignView class]]) {
       [sign signDone:^(UIImage *signImage) {
         if (signImage) {
          
           NSString *temp = NSTemporaryDirectory();
           NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
           NSTimeInterval a=[dat timeIntervalSince1970];
           NSString*timeString = [NSString stringWithFormat:@"%0.fsignImage.png", a];
           NSString *path = [temp stringByAppendingString:timeString];
           
           if ([UIImagePNGRepresentation(signImage) writeToFile:path atomically:YES]) {
             resolve(@{@"imagePath":path});
           }else{
              reject(@"-1",@"签名失败",nil);
           }
         }else{
           reject(@"-1",@"未找到签名",nil);
         }
        
       }];
       
     } else {
       RCTLogError(@"Cannot stopRefreshing: %@ (tag #%@) is not RNTableView", sign, reactTag);
     }
   }];
}


@end
