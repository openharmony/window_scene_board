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
import { performanceMonitor } from '@kit.ArkUI';
import { ApsUtils } from '@ohos/frameworkwrapper';
import { StyleConstants } from '@ohos/launchercommon';
import { SCBSceneMode, SCBSceneSessionManager } from '@ohos/windowscene';
import { systemAniSceneCtrl } from './SystemAnimatedSceneController';
import { SystemAnimatedScene } from '../constants/SystemAnimatedScene';

/**
 * PC窗口DFX工具类，单例类，包含如下相关
 * performanceMonitor: 动效性能雷达打点
 * ApsUtils: 高帧率场景投票，特性场景像底层投票提升整机帧率限制, 当前pc和自由多窗的字段有区分, 待后续归一
 * systemAniSceneCtrl: 场景识别, 向图形下发当前场景，图形会针对场景做性能优化
 */
export class SCBFreeWindowsDfx {
  private static INSTANCE: SCBFreeWindowsDfx;

  private constructor() {}

  /**
   * 单例对象
   *
   * @returns 单例对象
   */
  public static getInstance(): SCBFreeWindowsDfx {
    if (!SCBFreeWindowsDfx.INSTANCE) {
      SCBFreeWindowsDfx.INSTANCE = new SCBFreeWindowsDfx();
    }
    return SCBFreeWindowsDfx.INSTANCE;
  }

  /**
   * 最小化DFX开始
   *
   * @param bundleName 应用名称
   */
  public minimizeStart(bundleName: string | undefined): void {
    performanceMonitor.begin('WINDOW_TITLE_BAR_MINIMIZED', performanceMonitor.ActionType.LAST_UP, bundleName);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MIN, StyleConstants.DEFAULT_1);
  }

  /**
   * 最大化DFX开始
   *
   * @param bundleName 应用名称
   */
  public maximizeStart(bundleName: string | undefined): void {
    performanceMonitor.begin('WINDOW_TITLE_BAR_MAXIMIZED', performanceMonitor.ActionType.LAST_UP, bundleName);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MAX, StyleConstants.DEFAULT_1);
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_WINDOW_FULL_SCREEN, true);
  }

  /**
   * 最大化DFX结束
   */
  public maximizeEnd(): void {
    performanceMonitor.end('WINDOW_TITLE_BAR_MAXIMIZED');
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MAX, StyleConstants.DEFAULT_0);
    systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_WINDOW_FULL_SCREEN);
  }

  /**
   * 还原DFX开始
   *
   * @param bundleName 应用名称
   * @param lastWindowMode 还原之前的窗口模式
   */
  public recoverStart(bundleName: string | undefined, lastWindowMode: SCBSceneMode): void {
    if (lastWindowMode === SCBSceneMode.PRIMARY || lastWindowMode === SCBSceneMode.SECONDARY) {
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_SPLIT_WINDOW, true);
    }
    performanceMonitor.begin('WINDOW_TITLE_BAR_RECOVER', performanceMonitor.ActionType.LAST_UP, bundleName);
    // ApsUtils.setApsScene(this.getRecoverApsScene(lastWindowMode), StyleConstants.DEFAULT_1);
  }

  /**
   * 还原DFX结束
   *
   * @param lastWindowMode 还原之前的窗口模式
   */
  public recoverEnd(lastWindowMode: SCBSceneMode): void {
    performanceMonitor.end('WINDOW_TITLE_BAR_RECOVER');
    // ApsUtils.setApsScene(this.getRecoverApsScene(lastWindowMode), StyleConstants.DEFAULT_0);
    systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_SPLIT_WINDOW);
  }

  /**
   * 分屏DFX开始
   *
   * @param bundleName 应用名称
   * @param isPairSplitScene 是否预分屏进二分屏
   */
  public splitStart(bundleName: string | undefined, isPairSplitScene: boolean) : void {
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_SPLIT_WINDOW);
    performanceMonitor.begin('PC_SPLIT_START_ANIMATE', performanceMonitor.ActionType.LAST_UP, bundleName);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_SPLIT, StyleConstants.DEFAULT_1);
  }

  /**
   * 分屏DFX结束
   *
   * @param isPairSplitScene 是否预分屏进二分屏
   */
  public splitEnd(isPairSplitScene: boolean) : void {
    performanceMonitor.end('PC_SPLIT_START_ANIMATE');
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_SPLIT, StyleConstants.DEFAULT_0);
    systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_SPLIT_WINDOW);
  }

  private getRecoverApsScene(lastWindowMode: SCBSceneMode): number {
    if (lastWindowMode === SCBSceneMode.SECONDARY || lastWindowMode === SCBSceneMode.PRIMARY) {
      return 0
      // apsManager.SceneAnimation.PC_MODE_WINDOW_SPLIT_RECOVER;
    }
    return 1
    // apsManager.SceneAnimation.PC_MODE_WINDOW_MAX_RECOVER;
  }

  // private getSplitApsScene(isPairSplitScene: boolean): apsManager.SceneAnimation {
  //   return isPairSplitScene ? apsManager.SceneAnimation.PC_MODE_WINDOW_SPLIT :
  //   apsManager.SceneAnimation.PC_MODE_WINDOW_PRE_SPLIT;
  // }
}