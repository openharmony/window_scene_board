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

import { SCBSceneContainerSession, SCBSceneMode, SCBSceneSession } from '@ohos/windowscene';
import { IBase } from '../base/IBase';

/**
 * 布局策略类
 */
export interface ILayoutPolicy extends IBase {
  /**
   * 更新窗口分屏交互、退出热区
   *
   * @param sceneSession 窗口会话
   */
  updateWindowDragHotArea(sceneSession: SCBSceneSession): void;

  /**
   * 分屏交换, 需要校验分屏两个窗口的状态
   *
   * @param isSplitPrimary 是否主分屏
   * @param containerSession 窗口容器会话
   * @param persistentId 窗口ID
   */
  switchSplitSideWithCondition(isSplitPrimary: boolean, containerSession: SCBSceneContainerSession,
    persistentId: number): void;

  /**
   * 分屏交换， 仅做基础校验，直接执行分屏动画
   *
   * @param containerSession
   */
  switchSplitSideDirectly(containerSession: SCBSceneContainerSession): void;

  /**
   * 更新屏幕最大化、分屏热区
   *
   */
  addOrUpdateDisplayDragHotArea(): void;

  /**
   * 窗口最大化
   *
   * @param sceneSession 窗口会话
   * @param containerSession 容器会话
   * @param compatibleModeCallback 兼容模式动画回调
   */
  maximizeScene(sceneSession: SCBSceneSession, containerSession: SCBSceneContainerSession,
    compatibleModeCallback: Callback<void>): void;

  /**
   * 窗口还原悬浮窗
   *
   * @param sceneSession 窗口会话
   * @param containerSession 容器会话
   * @param compatibleModeCallback 兼容模式动画回调
   */
  recoverScene(sceneSession: SCBSceneSession, containerSession: SCBSceneContainerSession,
    compatibleModeCallback: Callback<SCBSceneMode>): void;

  /**
   * 分屏窗口
   *
   * @param isSplitPrimary 是否左分屏
   * @param sceneSession 窗口会话
   * @param containerSession 容器会话
   * @param compatibleModeCallback 兼容模式动画回调
   */
  splitScene(isSplitPrimary: boolean, sceneSession: SCBSceneSession, containerSession: SCBSceneContainerSession): void;
}