//
//  UIView+HHBExtension.h
//  HHBKit
//
//  Created by DylanHu on 2017/10/20.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 获取center位置

 @param rect 视图的frame
 @return 视图的center
 */
CGPoint CGRectGetCenter(CGRect rect);


/**
 将视图移动到指定的center位置

 @param rect 视图frame
 @param center center位置
 @return 新的frame
 */
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (HHBExtension)

@property (nonatomic, assign) CGPoint hb_origin;
@property (nonatomic, assign) CGSize hb_size;

@property (nonatomic, assign, readonly) CGPoint hb_bottomLeft;
@property (nonatomic, assign, readonly) CGPoint hb_bottomRight;
@property (nonatomic, assign, readonly) CGPoint hb_topRight;

@property (nonatomic, assign) CGFloat hb_height;
@property (nonatomic, assign) CGFloat hb_width;

@property (nonatomic, assign) CGFloat hb_top;
@property (nonatomic, assign) CGFloat hb_bottom;

@property (nonatomic, assign) CGFloat hb_left;
@property (nonatomic, assign) CGFloat hb_right;

@property (nonatomic, assign) CGFloat hb_centerX;
@property (nonatomic, assign) CGFloat hb_centerY;

- (void)hb_moveBy:(CGPoint) delta;
- (void)hb_scaleBy:(CGFloat) scaleFactor;
- (void)hb_fitInSize:(CGSize) aSize;

/**
 点击手势
 @param block 点击后的回调.
 */
- (void)hb_setTapActionWithBlock:(void (^)(void))block;

/**
 长按手势
 @param block 长按手势后的回调.
 */
- (void)hb_setLongPressActionWithBlock:(void (^)(void))block;

@end
