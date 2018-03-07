
#import <UIKit/UIKit.h>
@class RCTBridge;

typedef void(^SignResult)(UIImage *signImage);

@interface SignView : UIView

- (instancetype)initWithBridge:(RCTBridge *)bridge NS_DESIGNATED_INITIALIZER;


/**
 签名区域的背景颜色
 */
@property (nonatomic, strong) UIColor *signViewColor;

/**
 签名笔划颜色
 */
@property (nonatomic, strong) UIColor *signLineColor;

/**
 签名笔划宽度
 */
@property (nonatomic, assign) CGFloat signLineWidth;

/**
 无签名时占位文字
 */
@property (nonatomic, copy) NSString *signPlaceHoalder;

/**
 无签名时占位文字颜色
 */
@property (nonatomic, copy) UIColor *placeHoalderColor;


/**
 签名完成后的回调Block,里面有完成的签名图片
 @param result block
 */
- (void)signDone:(SignResult)result;

// 清除签名
- (void)clearSignAction;

@end
