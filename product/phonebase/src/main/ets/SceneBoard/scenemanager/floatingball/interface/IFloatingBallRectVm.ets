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

import { FloatingBallPosition } from '../model/FloatingBallModel';

export interface IFloatingBallRectVm {
  /**
   * 坐标
   */
  position: FloatingBallPosition;

  /**
   * 悬浮球面板宽度
   */
  containerWidth: number;

  /**
   * 悬浮球面板高度
   */
  containerHeight: number;

  /**
   * 屏幕宽度
   */
  screenWidth: number;

  /**
   * 屏幕高度
   */
  screenHeight: number;

  /**
   * 输入法高度
   */
  inputHeight: number;

  /**
   * 缩放比例
   */
  scale: number;

  /**
   * 缩放X
   */
  scaleCenterX: number | string;

  /**
   * 缩放Y
   */
  scaleCenterY: number | string;

  /**
   * x轴位移
   */
  translateX?: number;

  /**
   * y轴位移
   */
  translateY?: number;

  /**
   * 模糊半径
   */
  blurRadius: number;

  /**
   * 是否在屏幕右侧
   */
  isRight: boolean;

  /**
   * 是否正在删除
   */
  isRemoving: boolean;

  /**
   * 是否正在出现
   */
  isShowing: boolean;

  /**
   * 是否在垃圾桶删除区域
   */
  isInDelArea: boolean;

  /**
   * 外底板与windowScene边距
   */
  outerPadding: number;

  /**
   * 初始化
   */
  init(): void;

  /**
   * 更新悬浮球位置
   */
  updatePosition(x: number, y: number, needAvoidTopBottom?: boolean): void;

  /**
   * 更新屏幕属性(px)
   * @param screenWidth 屏幕宽度
   * @param screenHeight 屏幕高度
   */
  updateScreenProperty(screenWidth: number, screenHeight: number): void;

  /**
   * 更新输入法高度(px)
   * @param height
   */
  updateInputMethodHeight(height: number): void;

  /**
   * 组件左下角Y坐标距离底部的高度(vp)
   */
  getDistanceFromLeftBottom(): number;

  /**
   * 悬浮球位置是否覆盖输入法
   */
  isOverlayInputMethod(): boolean;

  /**
   * 组件尺寸变化回调
   */
  onPanelSizeChange(size: SizeOptions): void;

  /**
   * 吸附两侧
   * @param xSpeed x轴速度
   */
  toSides(xSpeed?: number): void;

  /**
   * 恢复默认位置
   * @param posX
   * @param updatePreviousPosition
   */
  defaultPosition(posX: number, updatePreviousPosition?: boolean): void;

  /**
   * 更新缩放中心
   * @param centerX
   * @param centerY
   */
  updateScaleCenter(centerX: number | string, centerY: number | string): void;

  /**
   * 避让输入法
   */
  avoidInputMethod(): void;

  /**
   * 更新挖孔区域信息
   */
  updateCutoutArea(): Promise<void>;

  /**
   * 拖动开始
   */
  onPanStart(event: GestureEvent): void;

  /**
   * 拖动中
   */
  onPanMove(event: GestureEvent): void;

  /**
   * 拖动结束
   */
  onPanEnd(event: GestureEvent): void;
}