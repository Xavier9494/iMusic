
#import "MXScrollView+Animotion.h"

@implementation MXScrollView (Animotion)

- (NSString *)getAnimotionType:(kCMTransitionType)type {
    switch (type) {
        case kCMTransitionMoveIn:
            return kCATransitionMoveIn;
        case kCMTransitionFade:
            return kCATransitionFade;
        case kCMTransitionPush:
            return kCATransitionPush;
        case kCMTransitionReveal:
            return kCATransitionReveal;
        case kCMTransitionPageCurl:
            return @"pageCurl";
        case kCMTransitionPageUnCurl:
            return @"pageUnCurl";
        case kCMTransitionCube:
            return @"cube";
        case kCMTransitionOglFlip:
            return @"oglFlip";
        case kCMTransitionRippleEffect:
            return @"rippleEffect";
        case kCMTransitionSuckEffect:
            return @"suckEffect";
        case kCMTransitionRandom:
            return [self getAnimotionType:arc4random_uniform(10)];
        default:
            break;
    }
}

- (NSString *)getAnimotionDirection:(kCMTransitionDirection)direction {
    switch (direction) {
        case kCMTransitionDirectionFromBottom:
            return kCATransitionFromBottom;
        case kCMTransitionDirectionFromLeft:
            return kCATransitionFromLeft;
        case kCMTransitionDirectionFromRight:
            return kCATransitionFromRight;
        case kCMTransitionDirectionFromTop:
            return kCATransitionFromTop;
        case kCMTransitionDirectionRandom:
            return [self getAnimotionDirection:arc4random_uniform(4)];
        default:
            break;
    }
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com