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
import { Singleton } from '../utils/Singleton';
// import abilityFrameworkBroker from '@ohos.virtService.abilityFrameworkBroker';
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

  public static DELIVER_SHELL_ASSISTANT: string = 'com.openharmony.shell_assistant';

  public readonly emitter = new EventEmitter<AppLifeCycleEvent>();

  /**
   * 前台应用Ability集
   * 无前台应用表示桌面，小窗场景存在多个前台应用
   */
  private foregroundInfo: Map<number, Set<string>> = new Map();

  /**
   * bundleName → UIDs 映射，用于代理通知的前台判断
   */
  private bundleNameToUids: Map<string, Set<number>> = new Map();

  public isDeliverShellForeground: boolean = false;

  /**
   * 注册备份应用状态监听后的标识ID
   */
  public appSwitchObserverId?: number;

  /**
   * 前台备份应用uid集
   * 小窗场景存在多个前台应用
   */
  private deliverForegroundInfo: Map<number, string> = new Map();

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
      // 维护 bundleName → uid 映射
      if (!this.bundleNameToUids.has(abilityState.bundleName)) {
        this.bundleNameToUids.set(abilityState.bundleName, new Set());
      }
      this.bundleNameToUids.get(abilityState.bundleName)!.add(abilityState.uid);
    } else if (foregroundAbilities) {
      foregroundAbilities.delete(key);
      if (!foregroundAbilities.size) {
        this.foregroundInfo.delete(abilityState.uid);
        // 该 uid 不再有前台 ability，从映射中移除
        const uids = this.bundleNameToUids.get(abilityState.bundleName);
        if (uids) {
          uids.delete(abilityState.uid);
          if (!uids.size) {
            this.bundleNameToUids.delete(abilityState.bundleName);
          }
        }
      }
    }

    const newAppForegroundFlag = (foregroundAbilities?.size ?? 0) > 0;
    log.showInfo(`Ability state change: new foregroundAbilities: ${abilityState.uid}: ${Array.from(foregroundAbilities?.keys() ?? [])
      .join(',')}`);
    if (oldAppForegroundFlag !== newAppForegroundFlag) {
      log.showInfo(`App foreground state changed, uid: ${abilityState.uid}, ${newAppForegroundFlag}`);
      if (abilityState.bundleName === AppLifeCycleManager.DELIVER_SHELL_ASSISTANT) {
        this.isDeliverShellForeground = newAppForegroundFlag;
      }
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
    if (event.parameters?.rgmStatus === 'rgm_user_unlocked') {
      log.showWarn('DeliverApp rgm_user_unlocked');
      this.initDeliverApp();
    }
  }

  /**
   * 备份应用前台状态变化事件
   */
  // private onAppSwitch = (appSwitchData: abilityFrameworkBroker.AppSwitchData): void => {
  //   log.warn('DeliverApp onAppSwitch: ', appSwitchData);
  //
  //   if (this.deliverForegroundInfo.has(appSwitchData.fromUid)) {
  //     this.deliverForegroundInfo.delete(appSwitchData.fromUid);
  //     this.emitter.emit('appForegroundStateChanged', {
  //       uid: appSwitchData.fromUid,
  //       isForeground: false,
  //       switchAbilityState: appManager.ApplicationState.STATE_BACKGROUND,
  //       bundleName: appSwitchData.fromBundleName
  //     });
  //   }
  //   if (!this.deliverForegroundInfo.has(appSwitchData.toUid) && appSwitchData.toUid !== -1) {
  //     this.deliverForegroundInfo.set(appSwitchData.toUid, appSwitchData.toBundleName);
  //     this.emitter.emit('appForegroundStateChanged', {
  //       uid: appSwitchData.toUid,
  //       isForeground: true,
  //       switchAbilityState: appManager.ApplicationState.STATE_FOREGROUND,
  //       bundleName: appSwitchData.toBundleName
  //     });
  //   }
  //
  //   log.showInfo(`DeliverApp onAppSwitch: new deliverForegroundInfo: ${Array.from(this.deliverForegroundInfo.values())}`);
  // };

  // private appSwitchObserver: abilityFrameworkBroker.AppSwitchObserver = {
  //   onAppSwitch: this.onAppSwitch
  // };

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
      this.initDeliverApp();
    } catch (e) {
      log.error('Init error:', e);
    }
  }

  /**
   * 注册备份应用状态监听
   */
  private async initDeliverApp(): Promise<void> {
    if (SystemUICcmConfig.instance.isEnabledWorker && ThreadUtil.isMainThread) {
      return;
    }
    if (NotificationUtil.isDeliverNotStarted()) {
      log.showWarn('DeliverApp no need init. The container has not started.');
      return;
    }
    try {
      log.showInfo('DeliverApp initDeliverApp start');
      if (this.appSwitchObserverId !== undefined) {
        // abilityFrameworkBroker.unregisterAppSwitchObserver(this.appSwitchObserverId);
      }
      // this.appSwitchObserverId = abilityFrameworkBroker.registerAppSwitchObserver(this.appSwitchObserver);
      log.showWarn('DeliverApp registerAppSwitchObserver success, appSwitchObserverId: ' + this.appSwitchObserverId);
      // const deliverAppStates = await abilityFrameworkBroker.getForegroundDeliverApps();
      // for (const deliverAppState of deliverAppStates) {
      //   if (deliverAppState.state === 1) {
      //     // this.onAppSwitch({
      //     //   fromBundleName: '',
      //     //   toBundleName: deliverAppState.bundleName,
      //     //   fromUid: -1,
      //     //   toUid: deliverAppState.uid
      //     // })
      //   }
      // }
      log.showInfo('DeliverApp initDeliverApp end');
    } catch (err) {
      log.error(`DeliverApp initDeliverApp error: ${err}`);
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

    if (live && live.isDeliverNotification) {
      if (this.deliverForegroundInfo.has(uid) && this.isDeliverShellForeground) {
        log.showInfo(`DeliverApp uid: ${live.creatorUid}, bundleName: ${live.creatorBundleName} isDeliverForeground`);
        return true;
      }
    } else if ((this.foregroundInfo.get(uid)?.size ?? 0) > 0) {
      return true;
    }

    // 代理通知：creatorUid 被系统覆盖为发布进程UID，
    // 通过 wantAgentInfo.bundleName 查找真实应用是否在前台
    if (live?.wantAgentInfo?.bundleName) {
      const targetUids = this.bundleNameToUids.get(live.wantAgentInfo.bundleName);
      if (targetUids) {
        for (const targetUid of targetUids) {
          if ((this.foregroundInfo.get(targetUid)?.size ?? 0) > 0) {
            return true;
          }
        }
      }
    }

    if (live) {
      if (PipSceneManager.instance.isPipLive(live)) {
        log.showInfo(`live ${live.hashCode} is in pip scene`);
        return true;
      }
    }

    return false;
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