/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import curves from '@ohos.curves';

/**
 * 拖拽相关的常量类
 */
export class DragConstants {
  /**
   * 落位动效插值器
   */
  static readonly DROP_CURVES = curves.springMotion(0.416, 0.99, 0);

  /**
   * 落位动效插值器
   */
  static readonly DROP_CURVES_LONG = curves.springMotion(0.832, 0.99, 0);

  /**
   * 落位动效默认起始缩放倍数
   */
  static readonly DROP_START_SCALE: number = 1.05;

  /**
   * 落位动效默认最终缩放倍数
   */
  static readonly DROP_END_SCALE: number = 1;

  /**
   * 挤位动效插值器
   */
  static readonly SQUEEZED_CURVES = curves.interpolatingSpring(0.5, 1, 228, 30);

  /**
   * PC挤位动效插值器
   */
  static readonly SQUEEZED_CURVES_FOR_PC = curves.interpolatingSpring(0, 1, 150, 20);

  /**
   * PC相邻元素挤位动效延迟
   */
  static readonly SQUEEZED_DELAY_TIME_FOR_PC = 32;

  /**
   * PC挤位动效延迟元素数量
   */
  static readonly SQUEEZED_DELAY_COUNT_FOR_PC = 2;

  /**
   * PC挤位动效超出边界的元素透明度
   */
  static readonly SQUEEZED_EXTRA_OPACITY_FOR_PC = 0.45;

  /**
   * 挤位动效时长
   */
  static readonly SQUEEZED_ANIMATION_DURATION: number = 200;

  /**
   * 落位截图标识
   */
  static readonly DROP_SNAPSHOT_KEY: string = 'drop_Snapshot_';

  /**
   * 拖拽起拖事件头
   */
  static readonly DRAG_START_EVENT: string = 'drag_start_';

  /**
   * 拖拽落位事件头
   */
  static readonly DROP_START_EVENT: string = 'drop_start_';

  /**
   * 落位动效结束事件头
   */
  static readonly DROP_ANIMATION_END_EVENT: string = 'drop_animation_end_';

  /**
   * 拖拽元素被移出当前布局事件头
   */
  static readonly DRAG_LEAVE_EVENT: string = 'drag_leave_';

  /**
   * 用于将smartDock上的落位事件分发给resident处理
   */
  static readonly SMART_DOCK_DROP_EVENT: string = 'smartDock_drop';

  /**
   * 重置文件夹元素挤位偏移
   */
  static readonly EVENT_FOLDER_ITEM_SQUEEZE_RESET = 'folderItemSqueezeReset';

  /**
   * 开始挤位事件头
   */
  static readonly ITEM_SQUEEZED_START_EVENT: string = 'item_squeezed_start_';

  /**
   * 挤位取消事件头
   */
  static readonly ITEM_SQUEEZED_CANCEL_EVENT: string = 'item_squeezed_cancel_';

  /**
   * 落位白框控件上下树变更事件
   */
  static readonly WHITE_BOX_CHANGE_EVENT: string = 'white_box_change';

  /**
   * 拖拽准备状态变更事件
   */
  static readonly DRAG_PREPARE_STATUS_CHANGE_EVENT: string = 'drag_prepare_status_change';
  /**
   * onDragStart拖拽准备状态变更事件
   */
  static readonly DRAG_START_PREPARE_STATUS_CHANGE_EVENT: string = 'drag_start_prepare_status_change';
}

/**
 * drag type enum
 */
export enum DragBehaviorType {
  // 单屏内移动
  DRAG_IN_DESKTOP_PAGE = 1,
  // 跨屏移动
  DRAG_CROSS_DESKTOP_PAGE = 2,
  // 桌面移动到dock栏
  DRAG_FROM_DESKTOP_TO_DOCK = 3,
  // dock栏移动到桌面
  DRAG_FROM_DOCK_TO_DESKTOP = 4,
  // dock栏内部移动
  DRAG_IN_DOCK_AREA = 5
}

/**
 * drag mode enum
 */
export enum DragBehaviorMode {
  // 单指长按拖动(含折叠双屏跨屏移动)
  DRAG_BY_LONG_PRESS = 1,
  // 一指长按一指滑动屏幕
  DRAG_BY_SWIPER = 2,
  // 拖动图标到边缘跨页
  DRAG_BY_ITEM_MOVE_PAGE = 3
}