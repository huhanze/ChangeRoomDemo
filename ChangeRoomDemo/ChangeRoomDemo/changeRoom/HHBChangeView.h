//
//  HHBChangeView.h
//  ChangeRoom
//
//  Created by DylanHu on 2017/10/20.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHBChangeViewDelegate;

/// 直播间切换完成回调类型
typedef  void(^ChangeRoomCompletedBlock)(void);

@interface HHBChangeView : UIView

/// 是否需要切换房间
@property (nonatomic, assign, getter = isNeedChangeRoom) BOOL needChangeRoom;

/// 切换滑动偏移量（切换房间过程中，当松手时的偏移量超过当前设置的值时切换房间，否则停留在当前房间,默认值为64)
@property (nonatomic, assign) CGFloat offset;

/// 切换动画执行时间,默认为0.5秒
@property (nonatomic, assign) CGFloat duration;

/// 切换房间完毕后的回调，在此回调中处理相关业务逻辑, 设置此毁掉时，注意循环引用...
@property (nonatomic, copy) ChangeRoomCompletedBlock changeRoomCompleted;

/// 代理
@property (nonatomic, weak) id <HHBChangeViewDelegate> delegate;

@end
