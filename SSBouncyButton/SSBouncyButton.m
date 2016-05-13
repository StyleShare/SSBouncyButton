//
// The MIT License (MIT)
//
// Copyright (c) 2014 Suyeol Jeon (http://xoul.kr),
//                    StyleShare (https://stylesha.re)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import <BRYSerialAnimationQueue/BRYSerialAnimationQueue.h>

#if __has_include(<UIColor-Hex/UIColor+Hex.h>)
#import <UIColor-Hex/UIColor+Hex.h>
#endif

#if __has_include(<UIColor_Hex/UIColor+Hex.h>)
#import <UIColor_Hex/UIColor+Hex.h>
#endif

#if __has_include(<UIImage+BetterAdditions/UIImage+BetterAdditions.h>)
#import <UIImage+BetterAdditions/UIImage+BetterAdditions.h>
#endif

#if __has_include(<UIImage_BetterAdditions/UIImage+BetterAdditions.h>)
#import <UIImage_BetterAdditions/UIImage+BetterAdditions.h>
#endif

#import "SSBouncyButton.h"

@interface SSBouncyButton ()

@property (nonatomic, strong) NSTimer *touchDelayTimer;
@property (nonatomic, assign) BOOL isShrinking;
@property (nonatomic, assign) BOOL isShrinked;
@property (nonatomic, assign) BOOL touchEnded;

@end


@implementation SSBouncyButton

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.adjustsImageWhenHighlighted = NO;
        self.cornerRadius = SSBouncyButtonDefaultCornerRadius;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        self.tintColor = [UIColor colorWithHex:SSBouncyButtonDefaultTintColor];
        self.cornerRadius = SSBouncyButtonDefaultCornerRadius;
        self.titleLabel.font = [UIFont systemFontOfSize:SSBouncyButtonDefaultTitleLabelFontSize];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    return self;
}


#pragma mark - Properties

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self setTitleColor:tintColor forState:UIControlStateNormal];
    [self updateBackgroundImage];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateBackgroundImage];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    if (state == UIControlStateSelected) {
        [self setTitle:title forState:UIControlStateSelected | UIControlStateHighlighted];
    }
}


#pragma mark - Draw

- (void)updateBackgroundImage
{
    NSDictionary *borderAttrs = @{NSStrokeColorAttributeName: self.tintColor,
                                  NSStrokeWidthAttributeName: @(SSBouncyButtonDefaultBorderWidth)};

    UIImage *normalBackgroundImage = [UIImage resizableImageWithColor:[UIColor clearColor]
                                                     borderAttributes:borderAttrs
                                                         cornerRadius:self.cornerRadius];
    UIImage *selectedBackgroundImage = [UIImage resizableImageWithColor:self.tintColor
                                                       borderAttributes:borderAttrs
                                                           cornerRadius:self.cornerRadius];
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected | UIControlStateHighlighted];
}


#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    self.touchEnded = NO;
    self.touchDelayTimer = [NSTimer timerWithTimeInterval:0.15
                                                   target:self
                                                 selector:@selector(beginShrinkAnimation)
                                                 userInfo:nil
                                                  repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.touchDelayTimer forMode:NSRunLoopCommonModes];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    self.touchEnded = YES;
    [self.touchDelayTimer invalidate];
    [self beginEnlargeAnimation];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];

    self.touchEnded = YES;
    [self.touchDelayTimer invalidate];

    if (self.isShrinked) {
        [self beginEnlargeAnimation];
    }
}


#pragma mark - Animations

- (void)beginShrinkAnimation
{
    [self.touchDelayTimer invalidate];
    self.isShrinked = YES;

    BRYSerialAnimationQueue *queue = [[BRYSerialAnimationQueue alloc] init];
    [queue animateWithDuration:0.3 animations:^{
        self.isShrinking = YES;
        self.transform = CGAffineTransformMakeScale(0.83, 0.83);
    }];
    [queue animateWithDuration:0.2 animations:^{
        if (self.touchEnded) {
            self.isShrinking = NO;
            return;
        }
        self.transform = CGAffineTransformMakeScale(0.86, 0.86);
    }];
    [queue animateWithDuration:0.18 animations:^{
        if (self.touchEnded) {
            self.isShrinking = NO;
            return;
        }
        self.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        self.isShrinking = NO;
    }];
}

- (void)beginEnlargeAnimation
{
    self.isShrinked = NO;

    BRYSerialAnimationQueue *queue = [[BRYSerialAnimationQueue alloc] init];

    // 롱터치를 하여 shrink 상태일 경우 중간값 사용
    if (self.isShrinking) {
        self.isShrinking = NO;
        CALayer *presentationLayer = self.layer.presentationLayer;
        self.transform = CATransform3DGetAffineTransform(presentationLayer.transform);
        [queue animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(0.85, 0.85);
        }];
    } else {
        [queue animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(0.85, 0.85);
        }];
    }
    [queue animateWithDuration:0.18 animations:^{
        self.transform = CGAffineTransformMakeScale(1.05, 1.05);
    }];
    [queue animateWithDuration:0.18 animations:^{
        self.transform = CGAffineTransformMakeScale(0.98, 0.98);
    }];
    [queue animateWithDuration:0.17 animations:^{
        self.transform = CGAffineTransformMakeScale(1.01, 1.01);
    }];
    [queue animateWithDuration:0.17 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

@end
