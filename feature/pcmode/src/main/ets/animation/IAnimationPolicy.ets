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

import { SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneSession } from '@ohos/windowscene/src/main/ets/TsIndex';
import { IBase } from '../base/IBase';

/**
 * 动画策略接口
 */
export interface IAnimationPolicy extends IBase {
  /**
   * 分屏交换动画
   *
   * @param containerSession 窗口容器会话
   */
  switchSplitAnimation(containerSession: SCBSceneContainerSession): void;
  /**
   * 热启动窗口缩放过渡动画
   *
   * @param scene 窗口会话
   */
  startResizeTransitionAnim(scene: SCBSceneSession, resizeFun: (scene: SCBSceneSession) => void): void;
  /**
   * 最小化指定窗口动画
   *
   * @param containerSessionList 窗口容器会话列表
   */
  minimizeTargetWindowsAnimation(containerSessionList: SCBSceneContainerSessionArray): void;
  /**
   * 窗口布局变化动画，包含分屏、最大化、沉浸式等,当前动画主要分两类
   * 1）截取应用内容作为截图，在动画过程中截图淡出，避免应用内容一帧切
   * 2）使用应用内容隐式动画，让应用内容做Ark的隐式动画一镜到底
   *
   * @param animationParams 动画参数
   * @param finishCallback 动画结束回调
   */
  layoutAnimation(sceneSession: SCBSceneSession, animationParams: AnimationParams,
    finishCallback: Callback<void>): void;
  /**
   * 还原窗口布局变化动画
   * 1）截取应用内容作为截图，在动画过程中截图淡出，避免应用内容一帧切
   * 2）使用应用内容隐式动画，让应用内容做Ark的隐式动画一镜到底
   *
   * @param animationParams 动画参数
   * @param finishCallback 动画结束回调
   */
  recoverAnimation(sceneSession: SCBSceneSession, animationParams: AnimationParams,
    finishCallback: Callback<void>): void;
}

/**
 * 动画参数类
 */
export class AnimationParams {
  // 是否走隐式动画
  public isNeedImplicitAnimation: boolean = false;
  // 是否进沉浸式最大化
  public isMaximizeInImmersive: boolean = false;
}