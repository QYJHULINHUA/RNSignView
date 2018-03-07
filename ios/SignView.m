
#import "SignView.h"
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>
//#import <React/RCTUtils.h>

@interface SignView ()

@property(nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, strong) UILabel *placeHoalderLabel;
@property(nonatomic, assign) CGPoint lastPoint;
@property(nonatomic, assign) BOOL isSwiping;
@property(nonatomic, strong) NSMutableArray *pointXs;
@property(nonatomic, strong) NSMutableArray *pointYs;

@end

@implementation SignView{
  RCTEventDispatcher *_eventDispatcher;
  RCTBridge *_bridge;
}

-(NSMutableArray*)pointXs {
    if (!_pointXs) {
        _pointXs=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _pointXs;
}
-(NSMutableArray*)pointYs {
    if (!_pointYs) {
        _pointYs=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _pointYs;
}

-(UIImageView *)signImageView{
  if (!_signImageView) {
    _signImageView =  [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_signImageView];
  }
  return _signImageView;
}

-(UILabel *)placeHoalderLabel{
  if (!_placeHoalderLabel) {
    _placeHoalderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _placeHoalderLabel.text = _signPlaceHoalder;
    _placeHoalderLabel.font = [UIFont systemFontOfSize:35];
    _placeHoalderLabel.textColor = _placeHoalderColor;
    _placeHoalderLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_placeHoalderLabel];
  }
  
  return _placeHoalderLabel;
}

- (void)layoutSubviews {
  
  self.backgroundColor = _signViewColor;
  self.layer.cornerRadius = 10;
  self.signImageView.frame = self.bounds;
  
  CGRect placeFrame = self.signImageView.frame;
  placeFrame.size.height = 100;
  self.placeHoalderLabel.frame= placeFrame;
  self.placeHoalderLabel.center = self.signImageView.center;

}

RCT_NOT_IMPLEMENTED(-initWithFrame:(CGRect)frame)
RCT_NOT_IMPLEMENTED(-initWithCoder:(NSCoder *)aDecoder)

- (instancetype)initWithBridge:(RCTBridge *)bridge {
  RCTAssertParam(bridge);
  RCTAssertParam(bridge.eventDispatcher);
  
  if ((self = [super initWithFrame:CGRectZero])) {
    _eventDispatcher = bridge.eventDispatcher;
    
    _bridge = bridge;
    while ([_bridge respondsToSelector:NSSelectorFromString(@"parentBridge")]
           && [_bridge valueForKey:@"parentBridge"]) {
      _bridge = [_bridge valueForKey:@"parentBridge"];
    }
    _signViewColor=[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1];
    _signLineColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    _placeHoalderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    _signLineWidth = 3;
    _signPlaceHoalder = @"签名区域";
    
  }
  return self;
}


- (void)setSignViewColor:(UIColor *)signViewColor{
    self.backgroundColor = signViewColor;
}

- (void)setSignPlaceHoalder:(NSString *)signPlaceHoalder{
    if (signPlaceHoalder) {
        _signPlaceHoalder = signPlaceHoalder;
        self.placeHoalderLabel.text = _signPlaceHoalder;
    }
}

- (void)setPlaceHoalderColor:(UIColor *)placeHoalderColor{
  _placeHoalderColor = placeHoalderColor;
  self.placeHoalderLabel.textColor = _placeHoalderColor;
}

- (NSDictionary *)RGBDictionaryByColor:(UIColor *)color {
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *compoments = CGColorGetComponents(color.CGColor);
        red = compoments[0];
        green = compoments[1];
        blue = compoments[2];
        alpha = compoments[3];
    }
    return @{@"red":@(red), @"green":@(green), @"blue":@(blue), @"alpha":@(alpha)};
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isSwiping = NO;
    UITouch * touch = touches.anyObject;
    self.lastPoint = [touch locationInView:self.signImageView];
    if (self.lastPoint.x > 0) {
        self.placeHoalderLabel.text = nil;
    }
    [self.pointXs addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.pointYs addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping = YES;
    UITouch * touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self.signImageView];
    UIGraphicsBeginImageContext(self.signImageView.frame.size);
    [self.signImageView.image drawInRect:(CGRectMake(0, 0, self.signImageView.frame.size.width, self.signImageView.frame.size.height))];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound);
    CGFloat lineWidth = 3.3;
    if (self.signLineWidth) {
        lineWidth = self.signLineWidth;
    }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    if (self.signLineColor) {
        NSDictionary *rgbDic = [self RGBDictionaryByColor:self.signLineColor];
        red = [rgbDic[@"red"] floatValue];
        green = [rgbDic[@"green"] floatValue];
        blue = [rgbDic[@"blue"] floatValue];
    }
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, 1.0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.signImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
    [self.pointXs addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.pointYs addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.isSwiping) {
        UIGraphicsBeginImageContext(self.signImageView.frame.size);
        [self.signImageView.image drawInRect:(CGRectMake(0, 0, self.signImageView.frame.size.width, self.signImageView.frame.size.height))];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.signImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
}


// 签名完成
- (void)signDone:(SignResult)result
{
    if (result) {
        result(self.signImageView.image);
    }
}

// 清除签名
- (void)clearSignAction
{
    self.signImageView.image = nil;
    self.placeHoalderLabel.hidden = NO;
    if (self.signPlaceHoalder) {
        self.placeHoalderLabel.text = self.signPlaceHoalder;
    } else {
        self.placeHoalderLabel.text = @"签名区域";
    }
}


@end
