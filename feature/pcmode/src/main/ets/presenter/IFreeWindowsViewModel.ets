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

import {
  ExecuteCallbackExtraInfo,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray, SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSession,
  SCBScreenProperty, ScenePanelState } from '@ohos/windowscene';
import { ExitSplitParam, PolicyType } from '../constants/BaseConstants';
import { IBase } from '../base/IBase';
import { PcSCBSceneContainerSessionArray } from '../instance/SCBSessionListManager';
import { SCBScenePanelProxy } from './SCBScenePanelProxy';


/**
 * 代理接口
 */
export interface IFreeWindowsViewModel extends IBase {

  getUiContext(): UIContext;

  /**
   * 获取窗口容器会话列表
   *
   * @returns 窗口容器会话列表
   */
  getContainerSessionList(): PcSCBSceneContainerSessionArray;

  /**
   * 获取不显示窗口容器会话列表
   *
   * @returns 不显示窗口容器会话列表
   */
  getContainerSessionListNotShowRecent(): SCBSceneContainerSessionArray;

  /**
   * 获取屏幕信息
   *
   * @returns 屏幕信息
   */
  getScreenProperty(): SCBScreenProperty;

  /**
   * 获取屏幕密度
   *
   * @returns 屏幕密度
   */
  getScreenDensity(): number;

  /**
   * 获取panel代理对象
   *
   * @returns panel代理对象
   */
  getPanelProxy(): SCBScenePanelProxy;

  /**
   * 根据窗口id查找对应的容器会话
   *
   * @param persistentId 窗口id
   * @returns 容器会话或者空
   */
  getSceneContainerSessionWithPersistentId(persistentId: number | undefined): SCBSceneContainerSession | null;

  /**
   * 根据容器id查找对应的容器会话

   * @param containerId 容器id
   * @returns 容器会话或者空
   */
  getSceneContainerSessionWithContainerId(containerId?: number): SCBSceneContainerSession | null;

  /**
   * 获取对应policy
   * @param policyType
   * @returns
   */
  getPolicy<T extends IBase>(policyType: PolicyType): T | null;

  /**
   * 退分屏
   *
   * @param persistentId 窗口ID
   * @param param 参数
   */
  exitSplitView(persistentId: number | undefined, param: ExitSplitParam): void;

  /**
   * 退分屏还原或最大化
   *
   * @param containerSession 窗口容器会话
   */
  recoverOrMaximizeIfLastSplit(containerSession: SCBSceneContainerSession | null): void;

  /**
   * hideAbility时，窗口的处理
   *
   * @param containerSession 容器会话
   * @param sceneSession 窗口会话
   * @param isFromClient 是否来自客户端
   */
  doSceneHideInSceneHideMode(containerSession: SCBSceneContainerSession,
    sceneSession: SCBSceneSession, isFromClient: boolean): void;

  /**
   * 关机退分屏
   *
   * @param persistentId 窗口ID
   */
  exitSplitViewWhenShutdown(persistentId: number | undefined): void;

  /**
   * 新增容器会话
   *
   * @param container 容器会话
   * @param needRefreshZOrder 是否需要刷新ZOrder
   */
  addSceneContainerSession(container: SCBSceneContainerSession, needRefreshZOrder: boolean): void;

  /**
   * 删除容器会话
   *
   * @param sceneContainerSession 容器会话
   */
  removeSceneContainerSession(sceneContainerSession: SCBSceneContainerSession): void;

  /**
   * 拆分二分屏，多任务关闭需要使用
   *
   * @param index 索引
   * @param currContainerSession 当前会话
   * @param isNeedUpdateRecentInfo 是否需要更新多任务信息
   * @param isEnterPair 是否是组成分屏
   * @param isContainerShow 是否显示
   * @param raisePersistentId 需要抬升的窗口
   */
  doExitSplitView(index: number, currContainerSession: SCBSceneContainerSession,
    isNeedUpdateRecentInfo: boolean, isEnterPair: boolean, isContainerShow: boolean, raisePersistentId?: number): void;

  /**
   * 分屏退出，多任务关闭需要使用
   *
   * @param param 参数
   * @param primarySession 主窗
   * @param secondarySession 附窗
   */
  handleExitSplit(param: ExitSplitParam, primarySession: SCBSceneSession | null,
    secondarySession: SCBSceneSession | null): void;

  /**
   * 销毁会话
   *
   * @param containerSession 待销毁的会话
   */
  destroyContainer(containerSession: SCBSceneContainerSession): void;

  /**
   * 更新屏幕属性
   *
   * @param screenProperty 更新后的屏幕属性
   */
  updateScreenProperty(screenProperty: SCBScreenProperty): void;

  /**
   * 更新屏幕密度
   *
   * @param screenDensity 屏幕密度
   */
  updateScreenDensity(screenDensity: number): void;

  /**
   * 预分屏下处理关闭二分屏窗口
   *
   * @param persistentId 窗口id
   */
  closeSceneInSplitState(persistentId: number): void;

  /**
   * 最大化单个窗口
   *
   * @param persistentId 窗口id
   * @param compatibleModeCallback 兼容模式回调
   */
  maximizeFromScene(persistentId: number, compatibleModeCallback: Callback<void>): void;

  /**
   * 还原单个窗口到悬浮窗
   *
   * @param persistentId 窗口id
   * @param recentCallback 多任务回调
   * @param compatibleModeCallback 兼容模式回调
   */
  recoverFromScene(persistentId: number, recentCallback: Callback<void>,
    compatibleModeCallback: Callback<SCBSceneMode>): void;

  /**
   * 窗口分屏, 兼容应用不支持分屏
   *
   * @param isSplitPrimary 是否左分屏
   * @param persistentId 窗口id
   */
  splitFromScene(isSplitPrimary: boolean, persistentId: number): void;

  /**
   * 计算窗口启动大小和位置
   *
   * @param scene 待计算大小和位置的窗口
   */
  initScenePosAndSize(scene: SCBSceneSession): void;

  /**
   * 刷新窗口记忆数据
   *
   * @param containerSession 待记忆的会话
   * @param isFlush 是否刷新持久化数据
   */
  saveSceneMemoryInfo(containerSession: SCBSceneContainerSession, isFlush: boolean): void;
}