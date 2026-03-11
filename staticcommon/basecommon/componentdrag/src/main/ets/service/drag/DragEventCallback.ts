/*
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

/**
 * 拖拽事件回调基类(暂只在桌面元素上使用，待拖拽整体统一后应用于其他布局)
 * 已有以下功能：
 * 1.挤位相关回调
 * 2.落位开始结束回调
 * 3.开始起拖回调
 *
 * @since 2024-01-10
 */
export interface DragEventCallback {
  /**
   * 拖拽过程中拖拽元素与其他元素发生挤位回调
   *
   * @param translatePosition 挤位位移，包含相对原位的xy偏移量
   */
  onStartSqueezedEvent?: (translatePosition: number[][], squeezeExtraParam?: SqueezeExtraParam) => void;

  /**
   * 拖拽过程中拖拽元素与其他元素挤位还原回调
   */
  onCancelSqueezedEvent?: (hasAnimation: boolean) => void;

  /**
   * 拖拽过程中拖拽元素开始落位回调
   */
  onItemDropStartEvent?: () => void;

  /**
   * 拖拽元素落位结束，拖拽过程终止回调
   */
  onItemDropEndEvent?: () => void;

  /**
   * 开始拖拽时回调
   */
  onItemDragStartEvent?: () => void;
}

/**
 * 挤位动画参数
 */
export interface SqueezeExtraParam {
  /**
   * 挤位动画延迟时间
   */
  delayTime?: number;

  /**
   * 挤位动画执行中的透明度
   */
  opacity?: number;

  /**
   * 可扩展参数
   */
  options?: any;
}