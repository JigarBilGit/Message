//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DGActivityIndicatorAnimationProtocol.h"

@interface DGActivityIndicatorAnimation : NSObject <DGActivityIndicatorAnimationProtocol>

- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath;
- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath;
- (CAAnimationGroup *)createAnimationGroup;

@end
