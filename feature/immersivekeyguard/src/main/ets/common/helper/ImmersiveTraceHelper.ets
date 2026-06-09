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

import { AnimateToScheduleUtils, DomainName, TraceUtil } from '@ohos/basicutils';
import { ImmersiveAnimScene, ImmersivePfmConstant } from '../anim/ImmersiveAnimConstants';
import { performanceMonitor } from '@kit.ArkUI';

/**
 * trace场景
 */
export enum TraceScene {
  /**
   * 默认
   */
  SCENE_DEFAULT = 'default'
}

/**
 * trace所有场景
 */
type TraceAllScene = TraceScene | ImmersiveAnimScene | string;

/**
 * 动效场景映射性能点位
 */
const P_MONITOR_SCENE: Map<string, ImmersivePfmConstant> = new Map([
  [ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX, ImmersivePfmConstant.SCENE_CAP_TO_LIST_ANIM],
  [ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX, ImmersivePfmConstant.SCENE_LIST_TO_CAP_ANIM],
  [ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD, ImmersivePfmConstant.SCENE_CAP_TO_CARD_ANIM],
  [ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE, ImmersivePfmConstant.SCENE_CARD_TO_CAP_ANIM],
]);

/**
 * GC避让场景
 */
const GC_SCHEDULE_SCENE: Set<string> = new Set([
  ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX,
  ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK,
  ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX,
  ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK,
  ImmersiveAnimScene.SCENE_LIST_TO_CARD,
  ImmersiveAnimScene.SCENE_CARD_TO_LIST,
  ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD,
  ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE
]);

/**
 * 沉浸锁屏trace打点工具
 */
export class ImmersiveTraceHelper {
  /**
   * GC避让场景
   */
  private static gCPriorityScene?: string;

  /**
   * 开启trace点位
   *
   * @param scene 打点场景
   */
  static startTrace(scene: TraceAllScene): void {
    TraceUtil.startTrace(DomainName.KG, scene);
  }

  /**
   * 结束trace点位
   *
   * @param scene 打点场景
   */
  static endTrace(scene: TraceAllScene): void {
    TraceUtil.endTrace(DomainName.KG, scene);
  }

  /**
   * 开启动效trace点位
   *
   * @param scene 打点场景
   */
  static startAnimTrace(scene?: TraceAllScene): void {
    if (!scene) {
      return;
    }
    TraceUtil.startAnimTrace(DomainName.KG, scene);
    let pScene = P_MONITOR_SCENE.get(scene);
    if (pScene) { // 性能打点
      performanceMonitor.begin(pScene, performanceMonitor.ActionType.LAST_UP);
      TraceUtil.startTrace(DomainName.KG, pScene, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    }
    // GC避让
    if (!ImmersiveTraceHelper.gCPriorityScene && GC_SCHEDULE_SCENE.has(scene)) {
      ImmersiveTraceHelper.gCPriorityScene = scene;
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    }
  }

  /**
   * 结束动效trace点位
   *
   * @param scene 打点场景
   */
  static endAnimTrace(scene?: TraceAllScene): void {
    if (!scene) {
      return;
    }
    TraceUtil.endAnimTrace(DomainName.KG, scene);
    let pScene = P_MONITOR_SCENE.get(scene);
    if (pScene) { // 性能打点
      performanceMonitor.end(pScene);
      TraceUtil.endTrace(DomainName.KG, pScene, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    }
    // GC避让
    if (ImmersiveTraceHelper.gCPriorityScene === scene) {
      ImmersiveTraceHelper.gCPriorityScene = undefined;
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
    }
  }

  /**
   * 性能打点，滑动开始打点
   *
   * @param pScene 场景
   */
  static startPMoveTrace(pScene: ImmersivePfmConstant): void {
    performanceMonitor.begin(pScene, performanceMonitor.ActionType.FIRST_MOVE);
  }

  /**
   * 性能打点，滑动结束打点
   *
   * @param pScene 场景
   */
  static endPMoveTrace(pScene: ImmersivePfmConstant): void {
    performanceMonitor.end(pScene);
  }
}