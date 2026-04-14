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
import { Singleton } from '../utils/Singleton';
// import abilityFrameworkBroker from '@hms.virtService.abilityFrameworkBroker';
import { abilityManager, appManager } from '@kit.AbilityKit';
import { LogDomain, LogHelper, ThreadUtil } from '@ohos/basicutils';
import { EventEmitter } from '../utils/EventEmitter';
import { PipSceneManager } from './PipSceneManager';
import { LiveNotification } from '../live/model/LiveNotification';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { NotificationUtil } from '../utils/NotificationUtil';
import { AbilityStateChangedEvent } from '@ohos/frameworkwrapper';
import { RgmStatusChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { AbilityState } from '../plugin/PhoneAppManager';
import lazy { SCBSceneInfo } from '@ohos/windowscene';
import { SCBSessionTerminateAdapter } from '../adapter/SCBSessionTerminateAdapter';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';

const TAG = 'AppLifeCycleManager';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface AppForegroundEvent {
  uid: number;
  isForeground: boolean;
  switchAbilityState: number;
  bundleName: string;
};

interface AppLifeCycleEvent {
  appForegroundStateChanged: AppForegroundEvent;
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

export class AppLifeCycleManager {
  @Singleton.decorate()
  public static get instance(): AppLifeCycleManager { return new AppLifeCycleManager(); }

  public readonly emitter = new EventEmitter<AppLifeCycleEvent>();

  /**
   * 前台应用Ability集
   * 无前台应用表示桌面，小窗场景存在多个前台应用
   */
  private foregroundInfo: Map<number, Set<string>> = new Map();

  /**
   * 注册应用状态监听后的标识ID
   */
  public appSwitchObserverId?: number;

  /**
   * 应用前台状态变化事件
   */
  private onAbilityStateChanged = (abilityState: abilityManager.AbilityStateData): void => {
    if (abilityState.abilityType !== AbilityType.PAGE) {
      log.showInfo(`Ability state is not page ${abilityState.bundleName}_${abilityState.moduleName}_${abilityState.abilityName}_${abilityState.pid}`);
      return;
    }
    const isForeground = abilityState.state === appManager.ApplicationState.STATE_FOREGROUND;
    const isBackground = abilityState.state === appManager.ApplicationState.STATE_BACKGROUND ||
      abilityState.state === appManager.ApplicationState.STATE_DESTROY;

    if (!isForeground && !isBackground) {
      log.showInfo('Ability state is not foreground and background');
      return;
    }

    const key = `${abilityState.bundleName}_${abilityState.moduleName}_${abilityState.abilityName}_${abilityState.pid}`;
    log.showInfo(`Ability state changed, uid: ${abilityState.uid}, key: ${key}, isForeground: ${isForeground}, state ${abilityState.state}`);
    let foregroundAbilities = this.foregroundInfo.get(abilityState.uid);
    let oldAppForegroundFlag = (foregroundAbilities?.size ?? 0) > 0;

    if (isForeground) {
      if (!foregroundAbilities) {
        foregroundAbilities = new Set();
        this.foregroundInfo.set(abilityState.uid, foregroundAbilities);
      }
      foregroundAbilities.add(key);
    } else if (foregroundAbilities) {
      foregroundAbilities.delete(key);
      if (!foregroundAbilities.size) {
        this.foregroundInfo.delete(abilityState.uid);
      }
    }

    const newAppForegroundFlag = (foregroundAbilities?.size ?? 0) > 0;
    log.showInfo(`Ability state change: new foregroundAbilities: ${abilityState.uid}: ${Array.from(foregroundAbilities?.keys() ?? [])
      .join(',')}`);
    if (oldAppForegroundFlag !== newAppForegroundFlag) {
      log.showInfo(`App foreground state changed, uid: ${abilityState.uid}, ${newAppForegroundFlag}`);
      this.emitter.emit('appForegroundStateChanged', {
        uid: abilityState.uid,
        isForeground: newAppForegroundFlag,
        switchAbilityState: abilityState.state,
        bundleName: abilityState.bundleName
      });
    }
  };

  private abilityStateObserver: abilityManager.AbilityForegroundStateObserver = {
    onAbilityStateChanged: this.onAbilityStateChanged
  };

  private abilityStatusChangeCallback = (event: AbilityStateChangedEvent): void => {
    if (event.abilityType !== AbilityType.PAGE) {
      log.showInfo(`StateChanged, state is not page ${event.bundleName}_${event.moduleName}_${event.abilityName}_${event.pid}`);
      return;
    }
    if (event.state !== AbilityState.ABILITY_STATE_TERMINATED) {
      return;
    }

    const key = `${event.bundleName}_${event.moduleName}_${event.abilityName}_${event.pid}`;
    log.showInfo(`Ability state trtminated, uid: ${event.uid}, key: ${key}`);

    const foregroundAbilities = this.foregroundInfo.get(event.uid);
    const oldAppForegroundFlag = (foregroundAbilities?.size ?? 0) > 0;
    if (foregroundAbilities) {
      foregroundAbilities.delete(key);
      if (!foregroundAbilities.size) {
        this.foregroundInfo.delete(event.uid);
      }
    }

    const newAppForegroundFlag = (foregroundAbilities?.size ?? 0) > 0;
    if (oldAppForegroundFlag !== newAppForegroundFlag) {
      log.showInfo(`Trtminated app state changed, uid: ${event.uid}, ${newAppForegroundFlag} ${event.state}`);
      this.emitter.emit('appForegroundStateChanged', {
        uid: event.uid,
        isForeground: newAppForegroundFlag,
        switchAbilityState: event.state,
        bundleName: event.bundleName
      });
    }
  };

  private subscribeRGMStatusChanged = (event: RgmStatusChangeEvent): void => {

  }

  /**
   * 初始化
   * @returns
   */
  public async init(): Promise<void> {
    try {
      abilityManager.on('abilityForegroundState', this.abilityStateObserver);
      SCBSessionTerminateAdapter.instance.registerSessionTerminate({ callback: this.onSessionTerminateEvent },
        'onSessionTerminateEvent');
      const abilityStates = await abilityManager.getForegroundUIAbilities();
      for (const abilityState of abilityStates) {
        this.onAbilityStateChanged(abilityState);
      }
      InnerEventUtil.on(AbilityStateChangedEvent, this.abilityStatusChangeCallback);
      InnerEventUtil.on(RgmStatusChangeEvent, this.subscribeRGMStatusChanged);
    } catch (e) {
      log.error('Init error:', e);
    }
  }

  /**
   * 应用是否在前台
   * 当传入的是实况应用时，需增加校验画中画
   * @param uid 应用
   * @param live 实况
   * @returns
   */
  public isForeground(uid?: number, live?: LiveNotification): boolean {
    if (uid === undefined) {
      return false;
    }

    if (live) {
      if ((this.foregroundInfo.get(uid)?.size ?? 0) > 0) {
        return true;
      }

      if (live) {
        if (PipSceneManager.instance.isPipLive(live)) {
          log.showInfo(`live ${live.hashCode} is in pip scene`);
          return true;
        }
      }

      return false;
    }
  }

  /**
   * 是否有应用在前台
   * @returns
   */
  public hasAppInForeground(): boolean {
    return this.foregroundInfo.size !== 0;
  }

  public onSessionTerminateEvent = (uid: number, scbSceneInfo?: SCBSceneInfo): void => {
    const abilityState: abilityManager.AbilityStateData = {
      state: appManager.ApplicationState.STATE_DESTROY,
      bundleName: scbSceneInfo?.bundleName ?? '',
      moduleName: scbSceneInfo?.moduleName ?? '',
      uid: uid,
      abilityType: AbilityType.PAGE,
      abilityName: scbSceneInfo?.abilityName ?? '',
      pid: scbSceneInfo?.persistentId ?? -1,
      isAtomicService: scbSceneInfo?.isAtomicService ?? false,
    }
    this.onAbilityStateChanged(abilityState);
  }
}