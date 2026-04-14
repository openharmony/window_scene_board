/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { DropDownEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { EventEmitter } from '../../utils/EventEmitter';

export interface PanelVmEvent {
  isLandscapeLayout: boolean;
  isGroupExpanding: boolean;
}

export interface INotificationPanelVm {
  /**
   * 通知面板是否在显示
   */
  isVisible: boolean;

  /**
   * 卡片宽度
   */
  cardWidth: number;

  /**
   * 通知中心面板透明度
   */
  opacity: number;

  /**
   * 通知中心面板缩放
   */
  scale: number;

  /**
   * 横竖屏布局参数
   */
  layoutOptions: FlexOptions;

  /**
   * 是否横屏布局
   */
  isLandscapeLayout: boolean

  /**
   * 是否可响应
   */
  isResponsive: boolean;

  /**
   * 双中心横滑时，通知中心面板位移值
   */
  horizontalDropPanelPosition?: number;
  /**
   * 是否需要展示模糊层
   */
  isBlurAreaVisible?: boolean;
  /**
   * 模糊区域高度
   */
  blurAreaHeight?: number;
  /**
   * 模糊层TransY
   */
  blurAreaTransY?: number;
  /**
   * 面板广播事件
   */
  emitter?: EventEmitter<PanelVmEvent>;

  /**
   * 通知中心面板显示隐藏事件
   * @param isVisible 是否显示
   */
  onPanelVisibleChange: (isVisible: boolean, currentRatio: number) => void;

  /**
   * 通知中心面板触摸Y轴点，-1无触摸
   */
  panelDownWindowY?: number;

  /**
   * 通知中心面板触摸事件
   * @param event
   */
  onTouchEvent?: (event: TouchEvent) => void;

  /**
   * 监听状态栏触摸事件
   */
  listenEvent?: () => void;

  /**
   * 下拉事件
   */
  onDropdownChange?: (dropDownEvent: DropDownEvent) => void;

  /**
   * 横滑开始事件
   * @param event 手势
   */
  onPanHorizontalStart: (event: GestureEvent) => void;

  /**
   * 横滑事件
   * @param event 手势
   */
  onPanHorizontalMove: (event: GestureEvent) => void;

  /**
   * 横滑结束事件
   * @param event 手势
   */
  onPanHorizontalEnd: (event: GestureEvent) => void;

  /**
   * 横滑取消事件
   */
  onPanHorizontalCancel: () => void;
  /**
   * 设置渐变模糊合成滤镜效果
   *
   * @returns filter | undefined 挂载了模糊效果的Filter实例，异常时返回undefined
   */
  getBlurCompositingFilter?(): Filter | undefined;
}