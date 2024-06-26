//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

#import "DGActivityIndicatorDoubleBounceAnimation.h"

@implementation DGActivityIndicatorDoubleBounceAnimation

#pragma mark -
#pragma mark DGActivityIndicatorAnimation Protocol

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - size.height) / 2.0f;
    for (int i = 0; i < 2; i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(oX, oY, size.width, size.height);
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 0.5f;
        circle.cornerRadius = size.height / 2.0f;
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        circle.backgroundColor = tintColor.CGColor;
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 2.0f;
        transformAnimation.beginTime = beginTime - (1.0f * i);
        transformAnimation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
        
        transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)]];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }

}

@end
