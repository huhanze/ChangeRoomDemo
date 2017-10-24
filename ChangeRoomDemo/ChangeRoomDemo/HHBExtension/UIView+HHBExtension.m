//
//  UIView+HHBExtension.m
//  HHBKit
//
//  Created by DylanHu on 2017/10/20.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import "UIView+HHBExtension.h"
#import <objc/runtime.h>


#pragma mark 获取Rect的中心点
CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint point;
    point.x = CGRectGetMidX(rect);
    point.y = CGRectGetMidY(rect);
    return point;
}

#pragma mark 将Rect按center整体移动到指定的位置
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newRect = CGRectZero;
    newRect.origin.x = center.x - CGRectGetMidX(rect);
    newRect.origin.y = center.y - CGRectGetMidY(rect);
    newRect.size = rect.size;
    return newRect;
}

// 关联对象的key
static char kHBActionHandlerTapBlockKey;
static char kHBActionHandlerTapGestureKey;
static char kHBActionHandlerLongPressBlockKey;
static char kHBActionHandlerLongPressGestureKey;

@implementation UIView (HHBExtension)

#pragma mark - Properties
#pragma mark 设置origin
- (CGPoint)hb_origin {
    return self.frame.origin;
}

- (void)setHb_origin:(CGPoint)hb_origin {
    CGRect newframe = self.frame;
    newframe.origin = hb_origin;
    self.frame = newframe;
}

#pragma mark 设置size
- (CGSize) hb_size {
    return self.frame.size;
}

- (void)setHb_size:(CGSize)aSize {
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

#pragma mark 获取其他位置
- (CGPoint)hb_bottomRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)hb_bottomLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)hb_topRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


#pragma mark 设置height
- (CGFloat)hb_height {
    return self.frame.size.height;
}

- (void)setHb_height:(CGFloat)newheight {
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

#pragma mark 设置width
- (CGFloat)hb_width {
    return self.frame.size.width;
}

- (void)setHb_width:(CGFloat)newwidth {
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

#pragma mark 设置top
- (CGFloat)hb_top {
    return self.frame.origin.y;
}

- (void)setHb_top:(CGFloat)newtop {
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

#pragma mark 设置left
- (CGFloat)hb_left {
    return self.frame.origin.x;
}

- (void)setHb_left:(CGFloat)newleft {
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

#pragma mark 设置bottom
- (CGFloat)hb_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setHb_bottom:(CGFloat)newbottom {
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

#pragma mark 设置right
- (CGFloat)hb_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setHb_right:(CGFloat)newright {
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

#pragma mark 设置centerX
- (CGFloat)hb_centerX {
    return self.center.x;
}

- (void)setHb_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

#pragma mark 设置centerY
- (CGFloat)hb_centerY {
    return self.center.y;
}

- (void)setHb_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark 设置偏移量
- (void)hb_moveBy:(CGPoint)delta {
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

- (void)hb_scaleBy:(CGFloat)scaleFactor {
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

- (void)hb_fitInSize:(CGSize)aSize {
    CGFloat scale;
    CGRect newframe = self.frame;
    if (newframe.size.height && (newframe.size.height > aSize.height)) {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    if (newframe.size.width && (newframe.size.width >= aSize.width)) {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    self.frame = newframe;
}

- (void)hb_setTapActionWithBlock:(void (^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kHBActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_hb_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kHBActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kHBActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)_hb_handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kHBActionHandlerTapBlockKey);
        if (action) {
            action();
        }
    }
}

- (void)hb_setLongPressActionWithBlock:(void (^)(void))block {
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kHBActionHandlerLongPressGestureKey);
    if (!gesture) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_hb_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kHBActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kHBActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)_hb_handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^action)(void) = objc_getAssociatedObject(self, &kHBActionHandlerLongPressBlockKey);
        if (action) {
            action();
        }
    }
}

@end
