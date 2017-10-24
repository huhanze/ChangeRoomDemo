## 直播间房间切换实现思路

目前大多数直播APP都有上下滑动，或者左右滑动切换直播间的功能。起初看起来没什么头绪，仔细看一下不难发现，其实所谓的滑动切换无非是添加了一个<font color = red >UIPanGestureRecognizer</font>，通过该手势使出的"障眼法"。

思路一： 
 >  1.创建一个父视图，将所有的显示控件添加到该父视图；
 
 >  2.创建一个平移手势，将此平移手势添加到父视图上；
 
 >  3.平移动画处理，每一次的动画处理完毕后，更新相关的业务逻辑即可(如切换房间后，修改相应的房间UI信息、房间服务器信息);
 
<font color = sky-blue>下面根据这个思路简单写个小Demo</font>

创建可平移的父视图<font color = red>HHBChangeView</font>(类名自己任意定，这里就用这个演示)。

在这个View中添加一个平移属性

```objc
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;  // 平移手势(用于切换直播间)

/// 平移手势
- (UIPanGestureRecognizer *)panGes {
    if (!_panGes) {
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeRoomPanGesture:)];
    }
    return _panGes;
}

```

初试化方法默认frame为屏幕的大小，当然你可以随意指定。

```objc
#define kHBDeviceWidth  [UIScreen mainScreen].bounds.size.width
#define kHBDeviceHeight  [UIScreen mainScreen].bounds.size.height

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kHBDeviceWidth, kHBDeviceHeight);
    }
    return self;
}
```

这里可以做一个开关来控制是否允许切换，添加一个切换属性，并重写该属性的setter方法进行相应的设置。

```objc
/// 是否需要切换房间
@property (nonatomic, assign, getter = isNeedChangeRoom) BOOL needChangeRoom;
```

```objc
- (void)setNeedChangeRoom:(BOOL)needChangeRoom {
    _needChangeRoom = needChangeRoom;
    if (needChangeRoom) {
        [self addGestureRecognizer:self.panGes];
    } else {
        ([_panGes superclass] == self && _panGes) ?: ({[self removeGestureRecognizer:_panGes];});
        _panGes = nil;
    }
}
```

接下来就是切换过程的实现，这里使用UIView的基本动画就能实现。

```objc
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
                
                /// 在这里进行切换房间后的业务逻辑处理......
                    ......
            }];
        }
    }
}
```

> 注意 ： 上述中的hb_height、hb_width等属性是对UIView的扩展，便于使用相对布局，我这里提前写好了该扩展(见Demo)，当然你可以用自己的。


至此切换过程已简单的实现，当然这提供的只是个思路，根据该思路从代码的角度可以继续进行优化。

这里我简单的做了一下封装，提供了简单的接口，房间的切换提供了block回调和代理两种方式(<font color = sky-blue>ps:个人比较喜欢block,毕竟block回调方便，简练，有时候懒就不想搞代理那一套，哈哈哈，当然复杂的逻辑，建议使用代理，二者没有好坏之分，看场合了，两者都是强大的利器</font>）。

```objc
/// 切换滑动偏移量（切换房间过程中，当松手时的偏移量超过当前设置的值时切换房间，否则停留在当前房间,默认值为64)
@property (nonatomic, assign) CGFloat offset;

/// 切换动画执行时间,默认为0.5秒
@property (nonatomic, assign) CGFloat duration;

/// 切换房间完毕后的回调，在此回调中处理相关业务逻辑, 设置此毁掉时，注意循环引用...
@property (nonatomic, copy) ChangeRoomCompletedBlock changeRoomCompleted;

/// 代理
@property (nonatomic, weak) id <HHBChangeViewDelegate> delegate;

```

HHBChangeViewDelegate

```objc
@class HHBChangeView;

@protocol HHBChangeViewDelegate <NSObject>

@optional
- (void)changeViewCompleted:(HHBChangeView *)changeView;

@end
```

在房间切换过程中设置相关回调和代理相应

```objc
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
                
                // 设置回调
                if (self.changeRoomCompleted) {
                    self.changeRoomCompleted();
                }
                
                // 设置代理相应
                if (self.delegate && [self.delegate respondsToSelector:@selector(changeViewCompleted:)]) {
                    [self.delegate changeViewCompleted:self];
                }
            }];
        }
    }
}
```

使用的时候，只需创建HHBChangeView对象，添加到房间控制器View，然后将房间所有需显示的空间添加到该对象视图中，并在回调或者代理方法中实现相应的业务逻辑即可。




