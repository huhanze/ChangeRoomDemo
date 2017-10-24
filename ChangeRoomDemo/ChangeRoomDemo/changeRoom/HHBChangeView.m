//
//  HHBChangeView.m
//  ChangeRoom
//
//  Created by DylanHu on 2017/10/20.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import "HHBChangeView.h"
#import "UIView+HHBExtension.h"
#import "HHBChangeViewDelegate.h"

#define kHBDeviceWidth  [UIScreen mainScreen].bounds.size.width
#define kHBDeviceHeight  [UIScreen mainScreen].bounds.size.height

@interface HHBChangeView()

@property (nonatomic, strong) UIPanGestureRecognizer *panGes;  // 平移手势(用于切换直播间)

@end

@implementation HHBChangeView
#pragma mark - properties
- (UIPanGestureRecognizer *)panGes {
    if (!_panGes) {
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeRoomPanGesture:)];
    }
    return _panGes;
}

- (void)setNeedChangeRoom:(BOOL)needChangeRoom {
    _needChangeRoom = needChangeRoom;
    if (needChangeRoom) {
        [self addGestureRecognizer:self.panGes];
    } else {
        ([_panGes superclass] == self && _panGes) ?: ({[self removeGestureRecognizer:_panGes];});
        _panGes = nil;
    }
}

#pragma mark - 初始化方法
- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kHBDeviceWidth, kHBDeviceHeight);
        _offset = 64;
        _duration = 0.5;
    }
    return self;
}

#pragma mark 切换房间实现
- (void)changeRoomPanGesture:(UIPanGestureRecognizer *)gesture {
    self.hb_height = ([self superview] ? [self superview].hb_height : kHBDeviceHeight);
    CGPoint translatePoint = [gesture translationInView:gesture.view];
    CGFloat offsetY = translatePoint.y;
    self.hb_top = offsetY;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if ((offsetY < self.offset && offsetY > 0) || (offsetY < 0 && offsetY > -self.offset) ) {
            [UIView animateWithDuration:self.duration animations:^{
                self.hb_top = 0;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                if (offsetY > 0) {
                    self.hb_top = ([self superview] ? [self superview].hb_bottom : kHBDeviceHeight);
                    self.hb_height = CGFLOAT_MIN;
                    
                } else {
                    self.hb_bottom = 0;
                    
                }
            }completion:^(BOOL finished) {
                if (offsetY > 0) {
                    self.hb_top = 0;
                    self.hb_height = kHBDeviceHeight;
                } else {
                    self.hb_height = kHBDeviceHeight;
                    self.hb_bottom = kHBDeviceHeight;
                }
                
                if (self.changeRoomCompleted) {
                    self.changeRoomCompleted();
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(changeViewCompleted:)]) {
                    [self.delegate changeViewCompleted:self];
                }
            }];
        }
    }
}

@end
