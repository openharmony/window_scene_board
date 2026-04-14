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

import appManager from '@ohos.app.ability.appManager';
import { SingletonHelper, LogDomain, LogHelper, CommonUtils, ArrayUtils } from '@ohos/basicutils';
import { EvtBus, RecentlyUseEvent } from '@ohos/frameworkwrapper';
import type { BusinessError } from '@ohos.base';

import type { Equality } from '@ohos/basicutils';
import { ForegroundAppEvent } from '@ohos/systemuiutils/src/main/ets/sysdialog/CommonEvent';
import {
  AbilityStateChangedEvent,
  ProcessStateChangeEvent
} from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';

const TAG = 'PhoneAppManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * Ability页面状态
 */
export enum AbilityState {
  /**
   * 正在创建
   */
  ABILITY_STATE_CREATE,

  /**
   * 创建完成
   */
  ABILITY_STATE_READY,

  /**
   * 置于前台
   */
  ABILITY_STATE_FOREGROUND,

  /**
   * 获焦
   */
  ABILITY_STATE_FOCUS,

  /**
   * 退到后台
   */
  ABILITY_STATE_BACKGROUND,

  /**
   * 销毁
   */
  ABILITY_STATE_TERMINATED,

  /**
   * 后台服务被连接
   */
  ABILITY_STATE_CONNECTED = 8,

  /**
   * 后台服务断连
   */
  ABILITY_STATE_DISCONNECTED
}

/**
 * Ability类型
 */
export enum AbilityType {
  /**
   * 未知
   */
  UNKNOWN,

  /**
   * 页面
   */
  PAGE,

  /**
   * 后台服务
   */
  SERVICE
}

/**
 * 前台页面
 */
class ForegroundPageAbility implements Equality {
  /**
   * 应用包名
   */
  bundleName: string;

  /**
   * 模块名
   */
  moduleName: string;

  /**
   * 页面名
   */
  abilityName: string;

  /**
   * 应用唯一标示
   */
  uid: number;

  /**
   * 应用index
   */
  appCloneIndex: number | undefined;

  /**
   * 复写接口Equality
   *
   * @param other 待比较对象
   * @returns true相等
   */
  equals(other: object): boolean {
    if (!(other instanceof ForegroundPageAbility)) {
      return false;
    }
    let otherAbility = other as ForegroundPageAbility;
    return this.uid === otherAbility.uid &&
      this.bundleName === otherAbility.bundleName &&
      this.moduleName === otherAbility.moduleName &&
      this.abilityName === otherAbility.abilityName &&
      this.appCloneIndex === otherAbility.appCloneIndex;
  }

  /**
   * 复制对象
   *
   * @returns 复制对象
   */
  copy(): ForegroundPageAbility {
    let copyAbility = new ForegroundPageAbility();
    copyAbility.bundleName = this.bundleName;
    copyAbility.moduleName = this.moduleName;
    copyAbility.abilityName = this.abilityName;
    copyAbility.uid = this.uid;
    copyAbility.appCloneIndex = this.appCloneIndex ?? 0;
    return copyAbility;
  }
}

/**
 * 最大重试次数
 */
const MAX_RETRY_COUNT = 3;

/**
 * 1秒重试一次
 */
const RETRY_TIME = 1000;

/**
 * 应用进程监听名单
 */
const PROCESS_OBSERVER_PACKAGE_NAME_LIST: string[] = ['com.ohos.superhub', 'cn.wps.office.hap'];

/**
 * 应用进程、页面状态管理
 */
class PhoneAppManager {
  /**
   * 注册应用状态监听后的标识ID
   */
  private observerId?: number;

  /**
   * 重试次数
   */
  private retryCount: number = 0;

  /**
   * 临时状态处理
   */
  private tempAbility: ForegroundPageAbility = new ForegroundPageAbility();

  /**
   * 前台应用Ability集
   * 无前台应用表示桌面，小窗场景存在多个前台应用
   */
  private foregroundApps: Set<ForegroundPageAbility> = new Set();

  /**
   * 前台应用事件
   */
  private foregroundAppEvent: ForegroundAppEvent = ForegroundAppEvent.create();

  /**
   * 监听回调器
   */
  private applicationStateObserver: appManager.ApplicationStateObserver = {
    /**
     * 前台应用进程切换
     */
    onForegroundApplicationChanged: (appStateData: appManager.AppStateData): void => {
    },

    /**
     * Ability状态切换
     */
    onAbilityStateChanged: (abilityStateData: appManager.AbilityStateData): void => {
      if (abilityStateData.abilityType === AbilityType.PAGE &&
        abilityStateData.state === AbilityState.ABILITY_STATE_FOREGROUND) {
        log.showDebug('onAbilityStateChanged');
        EvtBus.post(RecentlyUseEvent, new RecentlyUseEvent(abilityStateData));
      }
      // 发送前台应用事件
      this.checkAbilityForegroundChange(abilityStateData);
      EvtBus.post(AbilityStateChangedEvent, {
        bundleName: abilityStateData?.bundleName,
        state: abilityStateData?.state,
        abilityName: abilityStateData?.abilityName,
        uid: abilityStateData?.uid,
        moduleName: abilityStateData?.moduleName,
        pid: abilityStateData?.pid,
        abilityType: abilityStateData.abilityType,
      });
    },

    /**
     * 进程创建
     */
    onProcessCreated: (processData: appManager.ProcessData): void => {
      if (PROCESS_OBSERVER_PACKAGE_NAME_LIST.includes(processData?.bundleName)) {
        log.showInfo('onProcessCreated');
        EvtBus.post(ProcessStateChangeEvent, {
          bundleName: processData?.bundleName,
          visible: true,
          requestPid: processData?.pid,
          requestUid: processData?.uid,
        });
      }
    },

    /**
     * 进程销毁
     */
    onProcessDied: (processData: appManager.ProcessData): void => {
      if (PROCESS_OBSERVER_PACKAGE_NAME_LIST.includes(processData?.bundleName)) {
        log.showInfo('onProcessDied');
        EvtBus.post(ProcessStateChangeEvent, {
          bundleName: processData?.bundleName,
          visible: false,
          requestPid: processData?.pid,
          requestUid: processData?.uid,
       });
      }
    },

    /**
     * 进程状态切换
     */
    onProcessStateChanged: (processData: appManager.ProcessData): void => {
    },

    onAppStarted: function (appStateData: appManager.AppStateData): void {
    },

    onAppStopped: function (appStateData: appManager.AppStateData): void {
    }
  };

  /**
   * 构造
   */
  constructor() {
    // 前台应用事件生产
    EvtBus.produceOn(ForegroundAppEvent, this.onProduceForegroundAppEvent.bind(this));
  }

  /**
   * 初始化
   */
  init(): void {
    log.showInfo('init: ' + this.retryCount);
    // 注册应用状态监听
    this.onApplicationState();
  }

  /**
   * 判断应用是否在前台
   *
   * @param uid
   * @returns
   */
  public isForegroundApp(uid: number): boolean {
    return Array.from(this.foregroundApps).some(ability => ability.uid === uid);
  }

  public isExistsForegroundApp(predicate: (app: ForegroundPageAbility) => boolean): boolean {
    return Array.from(this.foregroundApps).some(predicate);
  }

  /**
   * 前台应用事件生产者
   *
   * @returns 前台应用事件
   */
  private onProduceForegroundAppEvent(): ForegroundAppEvent {
    return this.foregroundAppEvent;
  }

  /**
   * 发送事件
   */
  private postForegroundAppEvent(): void {
    EvtBus.post(ForegroundAppEvent, this.foregroundAppEvent);
  }

  /**
   * 注册应用状态监听
   */
  private onApplicationState(): void {
    if (this.retryCount >= MAX_RETRY_COUNT) {
      log.showWarn('onApplicationState retry over max count.');
      return;
    }
    try {
      this.offApplicationState();
      this.observerId = appManager.on('applicationState', this.applicationStateObserver);
    } catch (err) {
      log.showError('onApplicationState err: ' + (err as BusinessError)?.message);
      setTimeout(() => {
        this.retryCount++;
        this.onApplicationState();
      }, RETRY_TIME);
    }
  }

  /**
   * 注销应用状态监听
   */
  private offApplicationState(): void {
    if (CommonUtils.isNumber(this.observerId)) {
      try {
        appManager.off('applicationState', this.observerId);
      } catch (err) {
        log.showError('offApplicationState err: ' + (err as BusinessError)?.message);
      }
    }
  }

  /**
   * 检测Ability页面前台应用状态切换
   *
   * @param abilityStateData Ability状态
   */
  private checkAbilityForegroundChange(abilityStateData: appManager.AbilityStateData): void {
    // 只处理page Ability
    let abilityType = abilityStateData?.abilityType;
    let abilityState = abilityStateData?.state;
    if (abilityType !== AbilityType.PAGE) {
      return;
    }

    // 只处理前后台切换
    log.showInfo(`ability[${abilityStateData?.bundleName}|${abilityStateData.appCloneIndex}|${abilityStateData?.abilityName}] state change to ${abilityState}`);
    let isStateForeground = abilityState === AbilityState.ABILITY_STATE_FOREGROUND;
    let isStateBackground = (abilityState === AbilityState.ABILITY_STATE_BACKGROUND ||
      abilityState === AbilityState.ABILITY_STATE_TERMINATED);
    if (!isStateForeground && !isStateBackground) {
      return;
    }

    // 转换临时数据
    this.castForegroundAbility(abilityStateData);

    // 对比切换前后数据
    let oldCount = ArrayUtils.getSize(this.foregroundApps);
    this.handleForegroundSet(isStateForeground);
    let newCount = ArrayUtils.getSize(this.foregroundApps);

    // 列表变化处理
    if (oldCount !== newCount) {
      log.showInfo('checkAbilityForegroundChange change: ' + abilityState + ', ' + abilityStateData.bundleName);
      ArrayUtils.clearArr(this.foregroundAppEvent.bundleNames);
      ArrayUtils.clearArr(this.foregroundAppEvent.uidList);
      this.foregroundApps.forEach((ability) => {
        this.foregroundAppEvent.bundleNames.push(ability.bundleName);
        this.foregroundAppEvent.uidList.push(ability.uid);
      });
      this.foregroundAppEvent.switchAbilityState = abilityState;
      // 发送事件
      this.postForegroundAppEvent();
    }
  }

  /**
   * 处理数据新增/移除
   *
   * @param isStateForeground 是否前台状态
   */
  private handleForegroundSet(isStateForeground: boolean): void {
    // 增加前台应用
    if (isStateForeground) {
      if (ArrayUtils.contains(this.foregroundApps, this.tempAbility)) {
        return;
      }
      this.foregroundApps.add(this.tempAbility.copy());
      return;
    }

    // 移除前台应用
    ArrayUtils.delete(this.foregroundApps, this.tempAbility);
  }

  /**
   * Ability状态转前台Ability临时数据
   *
   * @param abilityStateData Ability状态
   */
  private castForegroundAbility(abilityStateData: appManager.AbilityStateData): void {
    this.tempAbility.bundleName = abilityStateData.bundleName;
    this.tempAbility.moduleName = abilityStateData.moduleName;
    this.tempAbility.abilityName = abilityStateData.abilityName;
    this.tempAbility.uid = abilityStateData.uid;
    this.tempAbility.appCloneIndex = abilityStateData.appCloneIndex ?? 0;
  }
}

export let phoneAppMgr = SingletonHelper.getInstance(PhoneAppManager, TAG);