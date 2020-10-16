//
//  UIView+Scale.h
//  TestPerfectScale
//
//  Created by apple on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenRatio getScreenScale()
#define Fit(num) kScreenRatio * (num)

/// 设计图的尺寸标准
static CGFloat const kDesignStandard = 375.00;

@interface UILabel (AdaptivePerfect)
///  字体大小（会自动适配屏幕）
@property (nonatomic, assign) IBInspectable CGFloat rm_font;

@end

@interface UIButton (AdaptivePerfect)
///  字体大小（会自动适配屏幕）
@property (nonatomic, assign) IBInspectable CGFloat rm_font;

@end

@interface UITextField (AdaptivePerfect)
///  字体大小（会自动适配屏幕）
@property (nonatomic, assign) IBInspectable CGFloat rm_font;

@end

@interface UITextView (AdaptivePerfect)
///  字体大小（会自动适配屏幕）
@property (nonatomic, assign) IBInspectable CGFloat rm_font;

@end


@interface UIView (AdaptivePerfect)

@property (nonatomic, assign) IBInspectable CGFloat rm_cornerRadius;
/// 遍历所有子控件，让所有的约束 * 比例
- (void)rm_fitAllConstraint;

extern CGFloat getScreenScale();

@end

@interface UIImageView (AdaptivePerfect)
@property (nonatomic,   copy) IBInspectable NSString * rm_image;
@property (nonatomic,   copy) IBInspectable NSString * rm_highLightImage;
@end
