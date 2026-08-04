/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
export enum EventType {
  // 无互斥
  NO_EXCLUSIVE = 0,

  //桌面拖拽
  DESKTOP_DRAG = 1 << 0,
  //桌面点击
  DESKTOP_CLICK = 1 << 1,
  //桌面横滑
  DESKTOP_SWIPER = 1 << 2,
  //全搜滑动
  GLOBALSEARCH = 1 << 3,
  //负一屏滑动
  NEGATIVE_SCROLL = 1 << 4,
  //桌面除Swiper横滑外所有事件
  DESKTOP_ALL_NOTGRIDSWIPER = 1 << 5,
  //back手势
  GESTURE_BACK = 1 << 6,
  //底部导航
  GESTURE_NAVBAR = 1 << 7,
  //状态栏下拉
  GESTURE_STATUS_BAR = 1 << 8,
  //悬浮窗拖拽
  FLOATING_DRAG = 1 << 9,
  //触摸悬浮窗拖拽热区
  TOUCH_FLOATINGDRAG_HOTAREA = 1 << 10,
  //分屏滑动
  SPLIT_GESTURE = 1 << 11,
  //多任务卡片上滑
  RECENT_CARD_UPSLIDE = 1 << 12,
  //多任务卡片点击
  RECENT_CARD_CLICK = 1 << 13,
  //全搜定位动效
  GLOBALSEARCH_LOCATIONAPPSHOW = 1 << 14,
  // 横屏应用退出动效
  APPEXIT_LANDSCAPE = 1 << 15,
  // 堆叠卡片滑动
  FORMSTACK_GESTURE = 1 << 16,
  // 导航条拖拽
  NAVIBAR_DRAG = 1 << 17,
  // 锁屏拉起相机
  GESTURE_SCREENLOCK_CAMERA = 1 << 18,
  // TOPBAR下拉
  GESTURE_TOPBAR_MOVE = 1 << 19,
  // 旋转动效
  ANIMATION_SCREENROTATE = 1 << 20,
  // 桌面所有事件
  DESKTOP_ALLEVENT = 1 << 21,
  // 画中画还原
  PIP_RESTORE = 1 << 22,
  // 侧边Dock应用拖拽
  GESTUREDOCK_ITEM_DRAG = 1 << 23,
  // 侧边Dock编辑模式下所有元素的点击
  GESTUREDOCK_EDITMODE_ALLITEM_CLICK = 1 << 24,
  // 触摸板三指滑动
  THREE_FINGER_GESTURE = 1 << 25,
  // 导航条点击返回
  NAVI_BAR_CLICK_BACK = 1 << 26,
  // 分屏关闭
  CLOSE_SPLIT_WINDOW = 1 << 27,
    // pc应用在手机运行非G态蒙版
  EXPAND_GUIDE_BOX = 1 << 28,
}

export enum EventExclusiveBitMap {

  // 无互斥
  NO_EXCLUSIVE = 0,

  //桌面拖拽
  DESKTOP_DRAG = EventType.DESKTOP_ALL_NOTGRIDSWIPER | EventType.GESTURE_BACK | EventType.GESTURE_NAVBAR |
  EventType.GESTURE_STATUS_BAR | EventType.GLOBALSEARCH | EventType.FORMSTACK_GESTURE | EventType.DESKTOP_CLICK |
  EventType.NAVI_BAR_CLICK_BACK,
  //桌面点击
  DESKTOP_CLICK = EventType.NO_EXCLUSIVE,
  //桌面横滑
  DESKTOP_SWIPER = EventType.DESKTOP_ALLEVENT | EventType.GESTURE_BACK | EventType.GESTURE_NAVBAR |
  EventType.GESTURE_STATUS_BAR | EventType.GLOBALSEARCH | EventType.FORMSTACK_GESTURE,
  //全搜滑动
  GLOBALSEARCH = EventType.DESKTOP_SWIPER | EventType.DESKTOP_ALL_NOTGRIDSWIPER | EventType.GESTURE_BACK |
  EventType.GESTURE_NAVBAR | EventType.GESTURE_STATUS_BAR | EventType.FORMSTACK_GESTURE,
  //back手势
  GESTURE_BACK = EventType.DESKTOP_ALL_NOTGRIDSWIPER | EventType.DESKTOP_SWIPER | EventType.GESTURE_NAVBAR |
  EventType.GESTURE_STATUS_BAR | EventType.GLOBALSEARCH | EventType.FORMSTACK_GESTURE | EventType.NAVIBAR_DRAG,
  //底部导航
  GESTURE_NAVBAR = EventType.DESKTOP_ALL_NOTGRIDSWIPER | EventType.DESKTOP_SWIPER | EventType.GESTURE_BACK |
  EventType.GESTURE_STATUS_BAR | EventType.GLOBALSEARCH | EventType.RECENT_CARD_CLICK | EventType.FORMSTACK_GESTURE |
  EventType.NAVIBAR_DRAG | EventType.THREE_FINGER_GESTURE,
  //状态栏下拉
  GESTURE_STATUS_BAR = EventType.DESKTOP_ALL_NOTGRIDSWIPER | EventType.DESKTOP_SWIPER | EventType.GLOBALSEARCH |
  EventType.GESTURE_BACK | EventType.GESTURE_NAVBAR | EventType.RECENT_CARD_CLICK | EventType.FORMSTACK_GESTURE |
  EventType.NAVIBAR_DRAG,
  //负一屏滑动
  NEGATIVE_SCROLL = EventType.DESKTOP_ALL_NOTGRIDSWIPER | EventType.GESTURE_BACK | EventType.GESTURE_NAVBAR,
  //悬浮窗拖拽
  FLOATING_DRAG = EventType.GESTURE_NAVBAR | EventType.GESTURE_STATUS_BAR | EventType.GESTURE_TOPBAR_MOVE |
  EventType.GESTURE_BACK,
  //触摸悬浮窗拖拽热区
  TOUCH_FLOATINGDRAG_HOTAREA = EventType.GESTURE_BACK,
  //分屏滑动
  SPLIT_GESTURE = EventType.GESTURE_NAVBAR | EventType.GESTURE_STATUS_BAR | EventType.GESTURE_TOPBAR_MOVE |
  EventType.GESTURE_BACK,
  //多任务卡片上滑
  RECENT_CARD_UPSLIDE = EventType.GESTURE_BACK | EventType.GESTURE_NAVBAR | EventType.GESTURE_STATUS_BAR |
  EventType.RECENT_CARD_CLICK,
  //多任务卡片点击
  RECENT_CARD_CLICK = EventType.NO_EXCLUSIVE,

  //全搜定位动效
  GLOBALSEARCH_LOCATIONAPPSHOW = EventType.DESKTOP_ALL_NOTGRIDSWIPER | EventType.DESKTOP_SWIPER |
  EventType.GLOBALSEARCH | EventType.GESTURE_BACK | EventType.GESTURE_STATUS_BAR | EventType.GESTURE_NAVBAR,
  // 横屏应用退出
  APPEXIT_LANDSCAPE = EventType.GLOBALSEARCH | EventType.GESTURE_BACK | EventType.GESTURE_STATUS_BAR |
  EventType.GESTURE_NAVBAR | EventType.DESKTOP_ALL_NOTGRIDSWIPER | EventType.DESKTOP_SWIPER,
  // 锁屏拉起相机
  GESTURE_SCREENLOCK_CAMERA = EventType.GESTURE_BACK | EventType.GESTURE_NAVBAR,
  // 旋转动效
  ANIMATION_SCREENROTATE = EventType.GESTURE_NAVBAR,
  // 画中画还原
  PIP_RESTORE = EventType.GESTURE_BACK | EventType.GESTURE_NAVBAR,
  // 侧边Dock内点击
  GESTUREDOCK_ITEM_DRAG = EventType.GESTURE_BACK | EventType.GESTURE_NAVBAR |
  EventType.GESTUREDOCK_EDITMODE_ALLITEM_CLICK,
  // 触摸板三指滑动
  THREE_FINGER_GESTURE = EventType.GESTURE_NAVBAR,
  // NaviBar点击返回
  NAVI_BAR_CLICK_BACK = EventType.NO_EXCLUSIVE,
  // pc应用在手机上提示蒙版
  EXPAND_GUIDE_BOX = EventType.GESTURE_BACK | EventType.GESTURE_STATUS_BAR,
  // 分屏关闭
  CLOSE_SPLIT_WINDOW = EventType.GESTURE_NAVBAR,
}

export class EventExclusiveConfig {
  private static eventExclusiveInfoMap: Map<EventType, [string, EventExclusiveBitMap]> = new Map([
    [EventType.NO_EXCLUSIVE, ['NO_EXCLUSIVE', EventExclusiveBitMap.NO_EXCLUSIVE]],
    [EventType.DESKTOP_DRAG, ['DESKTOP_DRAG', EventExclusiveBitMap.DESKTOP_DRAG]],
    [EventType.DESKTOP_CLICK, ['DESKTOP_CLICK', EventExclusiveBitMap.DESKTOP_CLICK]],
    [EventType.DESKTOP_SWIPER, ['DESKTOP_SWIPER', EventExclusiveBitMap.DESKTOP_SWIPER]],
    [EventType.GLOBALSEARCH, ['GLOBALSEARCH', EventExclusiveBitMap.GLOBALSEARCH]],
    [EventType.NEGATIVE_SCROLL, ['NEGATIVE_SCROLL', EventExclusiveBitMap.NEGATIVE_SCROLL]],
    [EventType.DESKTOP_ALL_NOTGRIDSWIPER, ['DESKTOP_ALL_NOTGRIDSWIPER', EventExclusiveBitMap.NO_EXCLUSIVE]],
    [EventType.GESTURE_BACK, ['GESTURE_BACK', EventExclusiveBitMap.GESTURE_BACK]],
    [EventType.GESTURE_NAVBAR, ['GESTURE_NAVBAR', EventExclusiveBitMap.GESTURE_NAVBAR]],
    [EventType.GESTURE_STATUS_BAR, ['GESTURE_STATUS_BAR', EventExclusiveBitMap.GESTURE_STATUS_BAR]],
    [EventType.FLOATING_DRAG, ['FLOATING_DRAG', EventExclusiveBitMap.FLOATING_DRAG]],
    [EventType.TOUCH_FLOATINGDRAG_HOTAREA, ['TOUCH_FLOATINGDRAGHOTAREA',
      EventExclusiveBitMap.TOUCH_FLOATINGDRAG_HOTAREA]],
    [EventType.SPLIT_GESTURE, ['SPLIT_GESTURE', EventExclusiveBitMap.SPLIT_GESTURE]],
    [EventType.RECENT_CARD_UPSLIDE, ['RECENT_CARD_UPSLIDE', EventExclusiveBitMap.RECENT_CARD_UPSLIDE]],
    [EventType.RECENT_CARD_CLICK, ['RECENT_CARD_CLICK', EventExclusiveBitMap.RECENT_CARD_CLICK]],
    [EventType.GLOBALSEARCH_LOCATIONAPPSHOW, ['GLOBALSEARCH_LOCATIONAPPSHOW',
      EventExclusiveBitMap.GLOBALSEARCH_LOCATIONAPPSHOW]],
    [EventType.APPEXIT_LANDSCAPE, ['APPEXIT_LANDSCAPE', EventExclusiveBitMap.APPEXIT_LANDSCAPE]],
    [EventType.FORMSTACK_GESTURE, ['FORMSTACK_GESTURE', EventExclusiveBitMap.NO_EXCLUSIVE]],
    [EventType.NAVIBAR_DRAG, ['NAVIBAR_DRAG', EventExclusiveBitMap.NO_EXCLUSIVE]],
    [EventType.GESTURE_TOPBAR_MOVE, ['GESTURE_TOPBAR_MOVE', EventExclusiveBitMap.NO_EXCLUSIVE]],
    [EventType.GESTURE_SCREENLOCK_CAMERA, ['GESTURE_SCREENLOCK_CAMERA',
      EventExclusiveBitMap.GESTURE_SCREENLOCK_CAMERA]],
    [EventType.ANIMATION_SCREENROTATE, ['ANIMATION_SCREENROTATE', EventExclusiveBitMap.ANIMATION_SCREENROTATE]],
    [EventType.DESKTOP_ALLEVENT, ['DESKTOP_ALLEVENT', EventExclusiveBitMap.NO_EXCLUSIVE]],
    [EventType.PIP_RESTORE, ['PIP_RESTORE', EventExclusiveBitMap.PIP_RESTORE]],
    [EventType.GESTUREDOCK_ITEM_DRAG, ['GESTUREDOCK_ITEM_DRAG', EventExclusiveBitMap.GESTUREDOCK_ITEM_DRAG]],
    [EventType.GESTUREDOCK_EDITMODE_ALLITEM_CLICK, ['GESTUREDOCK_EDITMODE_ALLITEM_CLICK',
      EventExclusiveBitMap.NO_EXCLUSIVE]],
    [EventType.THREE_FINGER_GESTURE, ['THREE_FINGER_GESTURE', EventExclusiveBitMap.THREE_FINGER_GESTURE]],
    [EventType.NAVI_BAR_CLICK_BACK, ['NAVI_BAR_CLICK_BACK', EventExclusiveBitMap.NAVI_BAR_CLICK_BACK]],
    [EventType.EXPAND_GUIDE_BOX, ['EXPAND_GUIDE_BOX', EventExclusiveBitMap.EXPAND_GUIDE_BOX]],
    [EventType.CLOSE_SPLIT_WINDOW, ['CLOSE_SPLIT_WINDOW', EventExclusiveBitMap.CLOSE_SPLIT_WINDOW]],
  ]);

  private static eventTypeInfoMap: Map<string, EventType> = new Map([
    ['NO_EXCLUSIVE', EventType.NO_EXCLUSIVE],
    ['DESKTOP_DRAG', EventType.DESKTOP_DRAG],
    ['DESKTOP_CLICK', EventType.DESKTOP_CLICK],
    ['DESKTOP_SWIPER', EventType.DESKTOP_SWIPER],
    ['GLOBALSEARCH', EventType.GLOBALSEARCH],
    ['NEGATIVE_SCROLL', EventType.NEGATIVE_SCROLL],
    ['DESKTOP_ALL_NOTGRIDSWIPER', EventType.DESKTOP_ALL_NOTGRIDSWIPER],
    ['GESTURE_BACK', EventType.GESTURE_BACK],
    ['GESTURE_NAVBAR', EventType.GESTURE_NAVBAR],
    ['GESTURE_STATUS_BAR', EventType.GESTURE_STATUS_BAR],
    ['FLOATING_DRAG', EventType.FLOATING_DRAG],
    ['Touch_FloatingDragHotArea', EventType.TOUCH_FLOATINGDRAG_HOTAREA],
    ['SPLIT_GESTURE', EventType.SPLIT_GESTURE],
    ['RECENT_CARD_UPSLIDE', EventType.RECENT_CARD_UPSLIDE],
    ['RECENT_CARD_CLICK', EventType.RECENT_CARD_CLICK],
    ['GLOBALSEARCH_LOCATIONAPPSHOW', EventType.GLOBALSEARCH_LOCATIONAPPSHOW],
    ['APPEXIT_LANDSCAPE', EventType.APPEXIT_LANDSCAPE],
    ['FORMSTACK_GESTURE', EventType.FORMSTACK_GESTURE],
    ['NAVIBAR_DRAG', EventType.NAVIBAR_DRAG],
    ['GESTURE_TOPBAR_MOVE', EventType.GESTURE_TOPBAR_MOVE],
    ['GESTURE_SCREENLOCK_CAMERA', EventType.GESTURE_SCREENLOCK_CAMERA],
    ['ANIMATION_SCREENROTATE', EventType.ANIMATION_SCREENROTATE],
    ['DESKTOP_ALLEVENT', EventType.DESKTOP_ALLEVENT],
    ['PIP_RESTORE', EventType.PIP_RESTORE],
    ['GESTUREDOCK_ITEM_DRAG', EventType.GESTUREDOCK_ITEM_DRAG],
    ['GESTUREDOCK_EDITMODE_ALLITEM_CLICK', EventType.GESTUREDOCK_EDITMODE_ALLITEM_CLICK],
    ['THREE_FINGER_GESTURE', EventType.THREE_FINGER_GESTURE],
    ['NAVI_BAR_CLICK_BACK', EventType.NAVI_BAR_CLICK_BACK],
    ['EXPAND_GUIDE_BOX', EventType.EXPAND_GUIDE_BOX],
    ['CLOSE_SPLIT_WINDOW', EventType.CLOSE_SPLIT_WINDOW],
  ]);

  public static getEventType(type: string): EventType {
    return this.eventTypeInfoMap.get(type);
  }

  public static getEventTypeName(eventType: EventType): string {
    return this.eventExclusiveInfoMap.get(eventType)?.[0];
  }

  public static getEventExclusiveBitmap(eventType: EventType): EventExclusiveBitMap {
    let eventExclusiveBitmap = EventExclusiveBitMap.NO_EXCLUSIVE;
    let eventExclusiveInfo = this.eventExclusiveInfoMap.get(eventType);
    if (eventExclusiveInfo) {
      eventExclusiveBitmap = eventExclusiveInfo[1];
    }
    return eventExclusiveBitmap;
  }

}

