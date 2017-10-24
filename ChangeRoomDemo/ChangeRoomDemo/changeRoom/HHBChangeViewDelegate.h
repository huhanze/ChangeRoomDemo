//
//  HHBChangeViewDelegate.h
//  ChangeRoomDemo
//
//  Created by DylanHu on 2017/10/24.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HHBChangeView;

@protocol HHBChangeViewDelegate <NSObject>

@optional
- (void)changeViewCompleted:(HHBChangeView *)changeView;

@end
