/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
export class ScenePanelEvents {
  public static readonly EVENT_GESTURE_BACK: string = 'onGestureBack';
  public static readonly EVENT_GESTURE_START: string = 'onGestureStart';
  public static readonly EVENT_GESTURE_UPDATE: string = 'onGestureUpdate';
  public static readonly EVENT_GESTURE_CANCEL: string = 'onGestureCancel';
  public static readonly EVENT_GESTURE_END: string = 'onGestureEnd';
  public static readonly EVENT_CLICK: string = 'onClick';
  public static readonly EVENT_SCREEN_LOCK: string = 'onScreenLock';
  public static readonly EVENT_SCREEN_UNLOCK: string = 'onScreenUnLock';

  public static readonly EVENT_RECENT_GESTURE_START = 'onRecentGestureStart';
  public static readonly EVENT_RECENT_GESTURE_UPDATE = 'onRecentGestureUpdate';
  public static readonly EVENT_RECENT_GESTURE_END = 'onRecentGestureEnd';
  public static readonly EVENT_RECENT_GESTURE_CANCEL = 'onRecentGestureCancel';

  public static readonly EVENT_SCROLL_START: string = 'onScrollStart';
  public static readonly EVENT_ON_SCROLL: string = 'onScroll';
  public static readonly EVENT_SCROLL_STOP: string = 'onScrollStop';
  public static readonly EVENT_CLEAR_ALL = 'onClearAll';
  public static readonly EVENT_CLEAR_ONE = 'onClearOne';
  public static readonly EVENT_TOUCH_DOWN = 'onTouchDown';
  public static readonly EVENT_TOUCH_UP = 'onTouchUp';
}