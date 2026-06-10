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
import { AnimateToScheduleUtils } from '@ohos/basicutils';
import { LogDomain, Logger } from '@ohos/basicutils';
import { Trace } from '@ohos/basicutils';
import { MemoryManager } from './MemoryManager';
import { IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
import { IS_IN_END } from '../TsIndex';

const TAG = 'GcController';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);
const STATIC_GC_INTERVAL = 3000;
export const DELAY_GC_TIMEOUT: number = 1000;
/** reclaim释放时间间隔 ms */
const STATIC_SCENE_RECLAIM_INTERVAL: number = 30 * 1000;

/**
 * 需要错峰GC的动画场景定义
 */
export enum AnimatorScene {
  // 空场景
  FREE = 0,

  // 解锁动画场景
  UNLOCK = 1 << 0,

  // 应用打开场景
  OPEN_APP = 1 << 1,
}

declare class ArkTools {
  static forceFullGC(): void;
  static hintGC(): void;
}

/**
 * 进程Gc控制器
 * 处理实际的Gc请求,提供动画场景的Gc错峰机制
 *
 * @since 2023-11-04
 */
export class GcController {
  private static mInstance: GcController;

  private currentScene: AnimatorScene = AnimatorScene.FREE;

  private gcTaskId: number | null = null;

  private restoreTaskId: number | null = null;

  private intervalId: number = 0;

  private closeTimerInfo: Array<string> = [];

  /**
   * 获取GC控制器单例
   *
   * @return 单例实例
   */
  static getInstance(): GcController {
    if (globalThis.GcController == null) {
      globalThis.GcController = new GcController();
    }
    return globalThis.GcController;
  }

  /**
   * 请求触发一次GC
   *
   * @param reason 触发GC的原因
   * @return 是否已立即触发
   */
  public requestGcTask(reason: string): boolean {
    log.showInfo(TAG, `requestGcTask -> reason:${reason}, currentScene:${this.currentScene}`);
    // 如果空闲,直接执行,否则延迟触发
    if (this.currentScene === AnimatorScene.FREE) {
      this.triGc(reason);
      return true;
    }
    if (this.gcTaskId !== null) {
      clearTimeout(this.gcTaskId);
    }
    this.gcTaskId = setTimeout(() => {
      this.requestGcTask(reason);
      this.gcTaskId = null;
    }, DELAY_GC_TIMEOUT);
    return false;
  }

  /**
   * 请求在1秒内进行GC错峰
   *
   * @param scene 请求GC错峰的场景
   */
  public delayGcTask(scene: AnimatorScene): void {
    this.currentScene |= scene;
    if (this.restoreTaskId !== null) {
      clearTimeout(this.restoreTaskId);
    }
    this.restoreTaskId = setTimeout(() => {
      this.currentScene = AnimatorScene.FREE;
      this.restoreTaskId = null;
    }, DELAY_GC_TIMEOUT);
  }

  /**
   * 结束GC错峰
   *
   * @param scene 结束GC错峰的场景
   */
  public restoreGcTask(scene: AnimatorScene): void {
    this.currentScene &= ~scene;
  }

  /**
   * 获取当前的场景值
   *
   * @returns 当前场景值
   */
  public getCurrentScene(): AnimatorScene {
    return this.currentScene;
  }

  /**
   * 触发GC
   *
   * @param 触发原因
   */
  triGc(reason: string): void {
    log.showInfo(TAG, `triGc -> start forceFullGC, reason:${reason}`);
    const startTime: number = Date.now();
    const isFullGcScene: boolean = MemoryManager.getInstance().isFullMemoryScene();
    // const isMemoryScene: boolean = MemoryUtils.isMemoryScene() || isFullGcScene;
    const isMemoryScene: boolean = isFullGcScene;
    Trace.start(`${TAG}_triGc`);
    try {
      // testMode下额外触发reclaim
      if (isMemoryScene) {
        ArkTools.hintGC();
        this.reportDelayReclaimIfNeed(isFullGcScene);
      } else {
        ArkTools.hintGC();
      }
    } catch (error) {
      log.showError(TAG, `triGc -> gc error, isMemoryScene:${isMemoryScene}`);
    }
    Trace.end(`${TAG}_triGc`);
    let funcCostTime: number = Date.now() - startTime;
    log.showInfo(TAG, `forceFullGC -> end forceFullGC, costTime:${funcCostTime}, isMemoryScene:${isMemoryScene}`);
  }

  /**
   * 检查是否需要reclaim
   */
  private reportDelayReclaimIfNeed(isFullGcScene: boolean): void {
    if (!isFullGcScene && !MemoryManager.getInstance().checkIsStaticMemoryScene()) {
      log.showInfo(TAG, `not in static memory scene, return`);
      return;
    }
    setTimeout(() => {
      AnimateToScheduleUtils.reportReclaimMem();
      this.closeTimerInfo.length = 0;
      this.closeTimerInfo.push(new Date().toString());

      let needClearInEnd = MemoryManager.getInstance().isDeviceSupported();
      this.intervalId = setInterval(() => {
        if (needClearInEnd && !AppStorage.get(IS_IN_END)) {
          clearInterval(this.intervalId);
          log.showWarn(TAG, `clearInterval -> reportReclaimMem ${this.intervalId}, reason: isInEnd changed!`);
          this.intervalId = 0;
          return;
        }
        log.showInfo(TAG, `setInterval -> reportReclaimMem ${this.intervalId}`);
        AnimateToScheduleUtils.reportReclaimMem();
        try {
          ArkTools.forceFullGC();
        } catch (error) {
          log.error(TAG,`forceFullGC failed: ${error}`);
        }
        this.closeTimerInfo.push(new Date().toString());
      }, STATIC_SCENE_RECLAIM_INTERVAL);
    }, 3000);
  }

  public clearInterval(info: string): void {
    // if (MemoryUtils.isMemoryScene() && MemoryManager.getInstance().checkIsStaticMemoryScene()) {
    //   log.showInfo(TAG, 'cancel clear interval in memory static testing scene');
    //   return;
    // }
    if (this.intervalId) {
      if (info === 'NOTIFICATION_BANNER') {
        return;
      }
      log.showInfo(TAG, `closeInterval -> close by action : ${info}`);
      let date = new Date().toString();
      this.closeTimerInfo.push(`${date} ||| ${info}`);
      clearInterval(this.intervalId);
      this.intervalId = 0;
    }
  }
}
