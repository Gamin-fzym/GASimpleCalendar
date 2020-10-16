//
//  UIView+Scale.m
//  TestPerfectScale
//
//  Created by apple on 2016/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIView+AdaptivePerfect.h"
#import "UIImage+Extension.h"
///  获取适配比例
CGFloat getScreenScale() {
    static CGFloat scale = 0;
    if (scale) return scale;
    scale = CGRectGetWidth([UIScreen mainScreen].bounds) / kDesignStandard;
    return scale;
}

@implementation UILabel (AdaptivePerfect)

- (void)setRm_font:(CGFloat)rm_font {
    self.font = [UIFont systemFontOfSize:rm_font * getScreenScale()];
}

- (CGFloat)rm_font {
    return self.font.pointSize;
}
@end

@implementation UIButton (AdaptivePerfect)

- (void)setRm_font:(CGFloat)rm_font {
    self.titleLabel.font = [UIFont systemFontOfSize:rm_font * getScreenScale()];
}
- (CGFloat)rm_font {
    return self.titleLabel.font.pointSize;
}
@end


@implementation UITextField (AdaptivePerfect)

- (void)setRm_font:(CGFloat)rm_font {
    self.font = [UIFont systemFontOfSize:rm_font * getScreenScale()];
}
- (CGFloat)rm_font {
    return self.font.pointSize;
}
@end


@implementation UITextView (AdaptivePerfect)

- (void)setRm_font:(CGFloat)rm_font {
    self.font = [UIFont systemFontOfSize:rm_font * getScreenScale()];
}
- (CGFloat)rm_font {
    return self.font.pointSize;
}
@end


@implementation UIView (AdaptivePerfect)


- (void)rm_fitAllConstraint {
    
    if ([UIScreen mainScreen].bounds.size.width == kDesignStandard) return;
    
    [self _enumerateAllSubViews:self];
    
    [self layoutIfNeeded];
}

- (void)_enumerateAllSubViews:(UIView *)superView {
    
    for (NSLayoutConstraint * constraint in superView.constraints) {
        constraint.constant *= getScreenScale();
    }
    
    NSArray * subviews = superView.subviews;
    if (!subviews.count) return;
    
    for (UIView * subview in subviews) {
        [self _enumerateAllSubViews:subview];
    }
}

- (void)setRm_cornerRadius:(CGFloat)rm_cornerRadius {
    self.rm_cornerRadius = rm_cornerRadius * getScreenScale();
}

- (CGFloat)rm_cornerRadius {
    return self.layer.cornerRadius;
}

@end


@implementation UIImageView (AdaptivePerfect)

- (void)setRm_image:(NSString *)rm_image {
    self.image = [UIImage rm_imageNamed:rm_image];
}

- (NSString *)rm_image {
    return nil;
}

- (void)setRm_highLightImage:(NSString *)rm_highLightImage {
    self.highlightedImage = [UIImage rm_imageNamed:rm_highLightImage];
}

- (NSString *)rm_highLightImage {
    return nil;
}

@end
