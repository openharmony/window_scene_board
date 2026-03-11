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
import { AnimateToScheduleUtils, CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager, EventConstants, ViewController,
  ViewManagerPolicy,
  ViewType } from '@ohos/frameworkwrapper';
import { TrimLevel } from '@ohos/frameworkwrapper';
import { viewMgrPolicy } from '@ohos/frameworkwrapper';
import type { StrategyFactory } from './StrategyFactory';
import { MemoryMonitor } from './MemoryMonitor';
import type { SCBUnlockTransitionController } from '@ohos/windowscene';
import { SCBTransitionManager } from '@ohos/windowscene';
import type { GcDecider } from './GcDecider';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { ResUtils } from '@ohos/windowscene';
import { notificationSubscribe } from '@kit.NotificationKit';
import { commonEventManager, systemParameter } from '@kit.BasicServicesKit';
import deviceInfo from '@ohos.deviceInfo';
import lazy { GridLayoutMemoryOptimizer } from './MemoryOptimizer';
import lazy { AbilityConstant } from '@kit.AbilityKit';

const TAG = 'MemoryManager';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);
const DEFAULT_TRIM_INTERVAL: number = 15 * 1000;
const MIN_APP_COUNT: number = 30;
const TEST_END_TIMEOUT: number = 4 * 3600 * 1000;
export const IS_IN_TEST_END_PHRASE = 'isInTestEndPhrase';
const RECLAIM_RETRY_TIMES: number = 5;
const RECLAIM_RETRY_INTERVAL: number = 2000;

const DEVICES_NOT_SUPPORTED: Set<string> = new Set();

/**
 * 触发内存回收的场景
 */
export enum TrimScene {
  CLEAR_MISSION_FULL = 0,
  CLEAR_MISSION = 1,
  LOCK_SCREEN = 2,
  GESTURE_HOME = 3,
  OPEN_APP = 4,
  LOCK_SCREEN_SLEEP = 5,
  MEMORY_LEVEL = 6,
}

/**
 * 内存管理器,管理内存回收、gc水线监控策略,分发内存回收事件回调
 *
 * @since 2023-11-03
 */
export class MemoryManager {
  private static sInstance: MemoryManager | null = null;

  private initFinished: boolean = false;

  private isStaticMemoryScene: boolean = false;

  private isFullGcMemoryScene: boolean = false;

  private isDebugScene: boolean = false;

  private trimStrategyMap: Map<TrimScene, Map<ViewType | string, TrimLevel>> =
    new Map<TrimScene, Map<ViewType | string, TrimLevel>>();

  private gcStrategyMap: Map<TrimScene, GcDecider> = new Map<TrimScene, GcDecider>();

  private lastTrimTimeMap: Map<TrimScene, number> = new Map<TrimScene, number>();

  private bundleNameList: Array<string> = [];

  private endTimeout: number = NaN;

  private lastReclaimTime: number = -1;

  private eventSubscriber: commonEventManager.CommonEventSubscriber | undefined = undefined;

  private unLockController: SCBUnlockTransitionController = {
    name: 'MemoryManagerUnLockController',
    onLock: (): void => {
      log.showDebug(TAG, 'on Locked');
      this.dispatchTrimMemory(TrimScene.LOCK_SCREEN);
    },
    onUnlock: (): void => {
      log.showDebug(TAG, 'on unLocked');
    }
  };

  private notificationSubscribe: notificationSubscribe.NotificationSubscriber = {
    onEnabledNotificationChanged: (enableData: notificationSubscribe.EnabledNotificationCallbackData) => this.onEnabledNotificationChanged(enableData)
  };

  private constructor() {
    notificationSubscribe.subscribe(this.notificationSubscribe);
    this.registerDebug();
    this.changeIsInEnd(false);
  }

  /**
   * 获取桌面应用信息管理对象
   *
   * @return 桌面应用信息管理对象单一实例
   */
  public static getInstance(): MemoryManager {
    if (MemoryManager.sInstance === null) {
      MemoryManager.sInstance = new MemoryManager();
    }
    return MemoryManager.sInstance;
  }

  /**
   * 清理多任务场景触发内存回收接口回调
   */
  public notifyClearRecentMissions(): void {
    this.dispatchTrimMemory(TrimScene.CLEAR_MISSION);
  }

  /**
   * 启动应用触发内存回收接口回调
   */
  public notifyClearOpenApp(): void {
    this.dispatchTrimMemory(TrimScene.OPEN_APP);
  }

  /**
   * 灭屏触发内存回收接口回调
   */
  public notifyClearScreenOff(): void {
    this.isFullGcMemoryScene = true;
    this.dispatchTrimMemory(TrimScene.LOCK_SCREEN_SLEEP);
  }

  /**
   * 指定特定的策略工厂实例初始化策略集合
   *
   * @param factory 策略工厂实例
   */
  private initStrategyMaps(factory: StrategyFactory): void {
    if (!factory) {
      log.showInfo(TAG, 'initStrategyMaps -> factory is invalid.');
      return;
    }
    factory.intTrimStrategyMap(this.trimStrategyMap);
    factory.intGcStrategyMap(this.gcStrategyMap);
    this.initFinished = true;
  }

  /**
   * 指定特定的策略工厂实例完成内存管理器的初始化
   *
   * @param factory 策略工厂实例
   */
  public initManager(factory: StrategyFactory): void {
    this.initStrategyMaps(factory);
    this.initCallback();
  }

  /**
   * 确认是否完成初始化
   *
   * @returns true or false
   */
  public isInitFinished(): boolean {
    return this.initFinished;
  }

  /**
   * 检查当前状态
   *
   * @returns true or false
   */
  public checkIsStaticMemoryScene(): boolean {
    return this.isStaticMemoryScene;
  }

  /**
   * 检查当前状态
   *
   * @returns true or false
   */
  public isFullMemoryScene(): boolean {
    return this.isFullGcMemoryScene;
  }

  /**
   * 销毁MemoryMonitor
   */
  public unInitManager(): void {
    if (!this.initFinished) {
      return;
    }
    this.lastTrimTimeMap.clear();
    this.trimStrategyMap.clear();
    this.gcStrategyMap.clear();
    this.unInitCallback();
  }

  private initCallback(): void {
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockController, true);
  }

  private unInitCallback(): void {
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.unLockController, true);
  }

  private checkAndRefreshLastTrimTime(trimScene: TrimScene): boolean {
    let currentTime: number = Date.now();
    let lastTime: number = this.lastTrimTimeMap.get(trimScene) ?? 0;
    if (currentTime - lastTime < DEFAULT_TRIM_INTERVAL) {
      log.showDebug(TAG, `checkLastTrimTimeInterval -> trim too often, lastTrimTime:${lastTime}`);
      return false;
    }
    this.lastTrimTimeMap.set(trimScene, currentTime);
    return true;
  }

  /**
   * 判断是否为静态内存测试场景
   * @param isStaticMemoryScene 未使用到，后期整改
   */
  public updateStaticMemoryScene(isStaticMemoryScene?: boolean): void {
    // // 不在测试模式，退出
    // if (!MemoryUtils.isMemoryScene()) {
    //   log.showInfo(TAG, 'not in memory scene, return');
    //   this.isStaticMemoryScene = false;
    //   return;
    // }
    // 测试应用不够 30 个，退出
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (containerSessionList.length < MIN_APP_COUNT) {
      log.showInfo(TAG, `containerSessionList size is: ${containerSessionList.length}, return`);
      this.isStaticMemoryScene = false;
      return;
    }
    this.bundleNameList = containerSessionList.map((item) => {
      if (item.primarySession && item.primarySession.sceneInfo) {
        return item.primarySession.sceneInfo.bundleName;
      }
      return '';
    }).filter(Boolean);
    // // 拉起了特定应用且设备支持，才进行特殊优化回收
    // this.isStaticMemoryScene = MemoryUtils.isStaticApps(this.bundleNameList);
    // log.showInfo(TAG, `checkStaticMemoryScene: ${this.isStaticMemoryScene}.`);
    // if (this.isStaticMemoryScene && this.isDeviceSupported()) {
    //   this.changeIsInEnd(true);
    //   ResUtils.clearModuleContexts();
    //   this.dispatchTrimMemory(TrimScene.CLEAR_MISSION_FULL);
    //
    //   if (!isNaN(this.endTimeout)) {
    //     clearTimeout(this.endTimeout);
    //   }
    //   this.endTimeout = setTimeout(() => {
    //     log.showWarn(TAG, `set isInEnd to false by overTime`)
    //     this.changeIsInEnd(false);
    //     this.endTimeout = NaN;
    //   }, TEST_END_TIMEOUT);
    // }
  }

  /**
   * 返回设备是否支持特殊回收
   * @returns
   */
  public isDeviceSupported(): boolean {
    let displayVersion: string = '';
    displayVersion = systemParameter.getSync('const.build.ver.physical', '');
    if (!displayVersion) {
      displayVersion = deviceInfo.displayVersion;
    }
    // 设备类型关键字
    let prefix: string = displayVersion.substring(0, 3);
    let result = !DEVICES_NOT_SUPPORTED.has(prefix);
    log.showInfo(TAG, `isDeviceSupported: ${result}`);
    return result;
  }

  /**
   *
   * @param trimScene 触发内存回收的场景
   * @param level 整机内存水线等级
   */
  private dispatchTrimMemory(trimScene: TrimScene, memoryLevel?: AbilityConstant.MemoryLevel): void {
    log.showWarn(TAG, `dispatchTrimMemory -> handle trim by scene:${TrimScene[trimScene]}, memoryLevel:${memoryLevel}`);
    if (!this.initFinished) {
      log.showWarn(TAG, 'dispatchTrimMemory -> manager not init.');
      return;
    }
    let levelMap: Map<ViewType | string, TrimLevel> | undefined = this.trimStrategyMap.get(trimScene);
    if (!levelMap || levelMap.size === 0) {
      log.showWarn(TAG, 'dispatchTrimMemory -> trim strategy not found.');
      return;
    }
    if (!this.checkAndRefreshLastTrimTime(trimScene)) {
      log.showWarn(TAG, 'dispatchTrimMemory -> checkAndRefreshLastTrimTime fail');
      return;
    }

    const priorityTrimLevel: TrimLevel | undefined = this.getTrimLevelByMemoryLevel(memoryLevel);
    levelMap.forEach((level: TrimLevel, viewType: ViewType | string) => {
      let controller: ViewController = viewMgrPolicy.getViewController(viewType);
      if (!controller) {
        log.showInfo(TAG, `dispatchTrimMemory -> controller not found, viewType:${ViewType[viewType]}.`);
        return;
      }
      controller.onTrimMemory(priorityTrimLevel ?? level, `scene:${TrimScene[trimScene].toString()}`);
    })
    if (this.gcStrategyMap.has(trimScene)) {
      // 对于内存监控策略集内已注册的场景,触发一次内存监控逻辑
      let decider: GcDecider | undefined = this.gcStrategyMap.get(trimScene);
      log.showDebug(TAG, `dispatchTrimMemory -> handle trim by decider:${decider?.toString()}.`);
      MemoryMonitor.getInstance().trimMonitorOnce(`trimeScene:${TrimScene[trimScene]}`, decider);
    }
  }

  /**
   * 根据内存水线获取回收等级
   * @param level
   * @returns
   */
  private getTrimLevelByMemoryLevel(level: AbilityConstant.MemoryLevel | undefined): TrimLevel | undefined {
    switch (level) {
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_MODERATE:
        return TrimLevel.LIGHT;
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_LOW:
        return TrimLevel.COMPLETE;
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_CRITICAL:
        return TrimLevel.CRITICAL;
      default:
        return undefined;
    }
  }

  private isCompleteTriDisabled(controller: ViewController, trimScene: TrimScene): boolean {
    if (!controller.isShowing()) {
      return false;
    }
    return trimScene !== TrimScene.CLEAR_MISSION_FULL;
  }

  private onEnabledNotificationChanged(enableData: notificationSubscribe.EnabledNotificationCallbackData): void {
    // if (MemoryUtils.isMemoryScene()) {
    //   // 静置过程中感知到通知开启，才认为结束静置
    //   if (AppStorage.get<boolean>(IS_IN_TEST_END_PHRASE) && enableData.enable) {
    //     if (!isNaN(this.endTimeout)) {
    //       clearTimeout(this.endTimeout);
    //       this.endTimeout = NaN;
    //     }
    //     log.showInfo(TAG, `onEnabledNotificationChanged to ${enableData.enable}`);
    //     this.changeIsInEnd(false);
    //   }
    // }
  }

  /** gridSwiper内存优化器 */
  public readonly gridLayoutOptimizer: GridLayoutMemoryOptimizer = new GridLayoutMemoryOptimizer();

  private changeIsInEnd(targetVal: boolean): void {
    AppStorage.setOrCreate<boolean>(IS_IN_TEST_END_PHRASE, targetVal);
    if (targetVal) {
      this.gridLayoutOptimizer.start();
    } else {
      this.gridLayoutOptimizer.end();
    }
  }

  /** 注册 hidumper debugger */
  private registerDebug(): void {
    const debugCommand: DebugCommand[] = [
      {
        cmdName: 'isInEnd',
        callback: (args: Array<string>): string => {
          try {
            let bool: boolean = JSON.parse(args.join(''));
            this.changeIsInEnd(Boolean(bool));
            return `set to ${bool}`;
          } catch (error) {
            log.showWarn(TAG, `set isInEnd failed, code:${error?.code} msg:${error?.message}`);
            return 'set failed';
          }
        }
      },
      {
        cmdName: 'trimMemory',
        callback: (args: Array<string>): string => {
          try {
            let params: number[] = args.map(Number);
            this.dispatchTrimMemory(params[0] as TrimScene, params[1] as AbilityConstant.MemoryLevel);
            return `trim success`;
          } catch (error) {
            log.showWarn(TAG, `trimMemory failed, code:${error?.code} msg:${error?.message}`);
            return 'failed';
          }
        }
      },
      {
        cmdName: 'isDebug',
        callback: (args: Array<string>): string => {
          try {
            let bool: boolean = JSON.parse(args.join(''));
            this.isDebugScene = Boolean(bool);
            return `set to ${bool}`;
          } catch (error) {
            log.showWarn(TAG, `set isDebug failed, code:${error?.code} msg:${error?.message}`);
            return 'set failed';
          }
        }
      },
      {
        cmdName: 'enableOptimizer',
        callback: (args: Array<string>): string => {
          try {
            let enable: boolean = Boolean(JSON.parse(args.join('')));
            this.gridLayoutOptimizer.setEnable(enable);
            return enable ? 'enabled optimizer' : 'disabled optimizer';
          } catch (error) {
            log.showWarn(TAG, `enableOptimizer failed, code:${error?.code} msg:${error?.message}`);
            return 'enableOptimizer failed';
          }
        }
      },
      {
        cmdName: 'setStaticMemory',
        callback: (args: Array<string>): string => {
          try {
            let enable: boolean = Boolean(JSON.parse(args.join('')));
            this.isStaticMemoryScene = enable;
            return `set to ${enable} success`;
          } catch (error) {
            log.showWarn(TAG, `setStaticMemory failed, code:${error?.code} msg:${error?.message}`);
            return 'failed';
          }
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, debugCommand);
  }

  reclaimInThemeChange(): void {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['usual.event.BUNDLE_RESOURCES_CHANGED']
    };
    try {
      commonEventManager.createSubscriber(subscribeInfo, (err, commonEventSubscriber) => {
        if (err || CheckEmptyUtils.isEmpty(commonEventSubscriber)) {
          log.showWarn(TAG, 'Failed to create subscriber: EVENT_BUNDLE_RESOURCES_CHANGED');
          return;
        }
        log.showInfo(TAG, 'Success to create subscriber: EVENT_BUNDLE_RESOURCES_CHANGED');
        this.eventSubscriber = commonEventSubscriber;
        this.subScribeThemeChange();
      });
    } catch (err) {
      log.showWarn(TAG, `Failed to create subscriber: ${err}`);
    }
  }

  private subScribeThemeChange(): void {
    commonEventManager.subscribe(this.eventSubscriber, async (err, eventData): Promise<void> => {
      log.showInfo(TAG, 'receive: EVENT_BUNDLE_RESOURCES_CHANGED');
      if (err && err.code !== 0) {
        log.showWarn(TAG, `Can't handle common event, err: ${err.message}`);
        return;
      }
      let current = Date.now();
      if ((current - this.lastReclaimTime) < 5000) {
        log.showInfo(TAG, 'reclaim too frequent');
        return;
      }
      this.tryReclaim();
    });
  }

  private tryReclaim(): void {
    let retry_times = 0;
    let intervalId = setInterval(() => {
      let isInNav: boolean = AppStorage.get<boolean>('isInNavBarGesture') as boolean;
      log.showInfo(TAG, `isInGesture is ${isInNav}`);
      if (!isInNav) {
        AnimateToScheduleUtils.reportReclaimMem();
        this.lastReclaimTime = Date.now();
        clearInterval(intervalId);
      } else {
        retry_times++;
        if (retry_times >= RECLAIM_RETRY_TIMES) {
          clearInterval(intervalId);
        }
      }
    }, RECLAIM_RETRY_INTERVAL);
  }

  /**
   * ability onMemoryLevel接口处理
   * @param level
   */
  public handleMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    this.dispatchTrimMemory(TrimScene.MEMORY_LEVEL, level);
  }
}