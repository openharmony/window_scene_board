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

import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import commonEventManager from '@ohos.commonEventManager';
import { BusinessError, power } from '@kit.BasicServicesKit';
import { LogDomain, Logger, OutdoorConfig } from '@ohos/basicutils';
import { Singleton } from '../utils/Singleton';
import { EventEmitter } from '../utils/EventEmitter';
import { NotificationSysEventReporter } from '../utils/NotificationSysEventReporter';
import { NotificationCreatorType } from '../model/NotificationContent';
import { NotificationBase } from '../model/NotificationBase';
import { ThreadSync } from '../messageChannel/ThreadSync';


const TAG = 'OutdoorVm';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const MODE_CUSTOM_POWER_SAVE = 650;
// 进入云端模式二的事件
const COMMON_EVENT_ENTER_CLOUD2 = 'com.ohos.sceneboard.entercloud2';
// 退出云端模式二的事件
const COMMON_EVENT_EXIT_CLOUD2 = 'com.ohos.sceneboard.exitcloud2';
// 云端模式二下 添加|移除应用的事件
const COMMON_EVENT_SELECT_APP = 'com.ohos.sceneboard.selectapp';
// 云端模式白名单变化事件
const COMMON_EVENT_ALLOW_NOTIFIED_APP = 'com.ohos.sceneboard.allownotifiedapp';
// 云端模式一仅监听白名单变化事件
const CLOUD_SUBSCRIBE_INFO_1: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    COMMON_EVENT_ALLOW_NOTIFIED_APP,
  ]
};
// 云端模式二监听白名单变化事件和电源模式变化事件
const CLOUD_SUBSCRIBE_INFO_2: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    COMMON_EVENT_ALLOW_NOTIFIED_APP,
    commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED,
  ]
};

interface OutdoorModeEvent {
  outdoorModeChange: boolean;
  outdoorRemoveApp: string[];
}

@ThreadSync.VmDecorator
@ObservedV2
export class OutdoorVm {
  @Singleton.decorate()
  public static get instance(): OutdoorVm {
    return new OutdoorVm();
  }

  /**
   * 是否开启云端模式一
   */
  @Trace private isEnabledOutdoorMode1: boolean = false;
  /**
   * 是否开启云端模式二
   */
  @Trace private isEnabledOutdoorMode2: boolean = false;
  /**
   * 云端模式下预置白名单应用列表
   * 云端模式一：只有预置应用：电话、短信、指南针、地图、天气、时钟、云端助手、设置
   * 云端模式二：电话、短信、指南针、地图、天气、时钟、云端助手、设置 + 相机、图库、运动健康、音乐、畅连 + betaclub + 样机打卡
   *            + 最多添加 8 个自定义应用
   */
  @Trace private outdoorAppList: Set<string> = new Set();

  private mSubscriber?: CommonEventSubscriber;

  public emitter = new EventEmitter<OutdoorModeEvent>();

  /**
   * 是否在云端模式下
   */
  @Computed
  public get isInOutdoorMode(): boolean {
    return this.isEnabledOutdoorMode1 || this.isEnabledOutdoorMode2;
  }

  @Monitor('isInOutdoorMode', 'outdoorAppList')
  onOutdoorModeChange(): void {
    log.showInfo(TAG, `onOutdoorModeChange: ${this.isInOutdoorMode} ${this.outdoorAppList.size}`);
    this.emitter.emit('outdoorModeChange', this.isInOutdoorMode);
  }

  public init(): void {
    this.isEnabledOutdoorMode1 = OutdoorConfig.getInstance().isInOutdoorMode();
    log.showInfo(TAG, `isEnabledOutdoorMode1: ${this.isEnabledOutdoorMode1}`);
    if (this.isEnabledOutdoorMode1) {
      this.registerCloudModeChange(CLOUD_SUBSCRIBE_INFO_1);
    } else {
      // 判断是否在云端模式二下
      this.isEnabledOutdoorMode2 = this.getDevicePowerMode() === MODE_CUSTOM_POWER_SAVE;
      this.registerCloudModeChange(CLOUD_SUBSCRIBE_INFO_2);
    }
    NotificationSysEventReporter.cloudModeConfig({
      IS_OPNE_PENLAI_MODE: this.isEnabledOutdoorMode1 ? 1 : 0,
    });
  }

  public unInit(): void {
    if (this.mSubscriber) {
      commonEventManager.unsubscribe(this.mSubscriber);
      this.mSubscriber = undefined;
    }
  }

  /**
   * 是否在云端模式白名单应用列表内
   * @param ntf
   */
  public isInOutdoorAppList(ntf: NotificationBase): boolean {
    if (!this.isInOutdoorMode) {
      return true;
    }
    if (ntf?.creatorType === NotificationCreatorType.SA) { // SA发送的不用过滤
      return true;
    }
    return this.outdoorAppList.has(ntf?.creatorBundleName);
  }

  /**
   * 监听云端模式事件
   */
  private registerCloudModeChange(subscribeInfo: commonEventManager.CommonEventSubscribeInfo): void {
    try {
      this.mSubscriber = commonEventManager.createSubscriberSync(subscribeInfo);
      if (!this.mSubscriber) {
        log.showError(TAG, 'create subscriber error');
        return;
      }
      commonEventManager.subscribe(this.mSubscriber, this.subscribeCallback.bind(this));
    } catch (err) {
      log.showError(TAG, `subscribe power mode failed. code: ${err?.code}, message: ${err?.message}`);
      NotificationSysEventReporter.cloudModeConfig({
        ERROR_CODE: err?.code,
      });
    }
  }

  /**
   * 云端模式事件变化回调
   */
  private subscribeCallback(err: BusinessError, data: commonEventManager.CommonEventData): void {
    if (err) {
      log.showError(TAG, `Can't handle common event. code: ${err?.code}, message: ${err?.message}`);
      NotificationSysEventReporter.cloudModeConfig({
        ERROR_CODE: err?.code,
      });
      return;
    }

    log.showWarn(TAG, `power mode changed, event: ${data?.event}, code: ${data?.code}`);
    let modeStatus = '';
    if (data?.event === commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED) {
      if (data.code === MODE_CUSTOM_POWER_SAVE) { // 进入云端模式二
        this.isEnabledOutdoorMode2 = true;
        modeStatus = COMMON_EVENT_ENTER_CLOUD2;
      } else if (this.isEnabledOutdoorMode2 && data.code !== MODE_CUSTOM_POWER_SAVE) {
        // 如果当前是云端二，但拿到的 data.code != 650, 则认为是退出云端二
        this.isEnabledOutdoorMode2 = false;
        this.outdoorAppList.clear();
        modeStatus = COMMON_EVENT_EXIT_CLOUD2;
      }
    } else if (data?.event === COMMON_EVENT_ALLOW_NOTIFIED_APP) { // 收到白名单应用列表变化事件
      this.updateOutdoorAppList(this.parseAppListData(data?.data));
      modeStatus = COMMON_EVENT_SELECT_APP;
    }

    if (modeStatus !== '') {
      NotificationSysEventReporter.cloudModeConfig({
        LISTENER_PENLAI_MODE_STATUS: modeStatus,
      });
    }
  }

  /**
   * 更新云端模式白名单列表
   */
  private updateOutdoorAppList(appList: string[]): void {
    const appListSet = new Set(appList);
    const removedAppList: string[] = [];
    for (const bundleName of this.outdoorAppList) {
      if (!appListSet.has(bundleName)) {
        removedAppList.push(bundleName);
      }
    }
    if (removedAppList.length) { // 发送移除白名单事件
      log.showWarn(TAG, `removedAppList: ${removedAppList.join(', ')}`);
      this.emitter.emit('outdoorRemoveApp', removedAppList);
    }
    this.outdoorAppList = appListSet;
  }

  /**
   * 更新云端模式白名单列表
   */
  private parseAppListData(data: string | undefined): string[] {
    let appList: string[] = [];
    if (typeof data === 'string') {
      try {
        const eventData = JSON.parse(data) as string[];
        if (Array.isArray(eventData)) {
          appList = eventData;
        }
      } catch (err) {
        log.showError(TAG, `parse data error. code: ${err?.code}, message: ${err?.message}`);
      }
    }
    log.showInfo(TAG, `parseAppListData len: ${appList.length}, appList: ${appList.join(', ')}`);
    return appList;
  }

  /**
   * 获取当前设备电源模式
   */
  private getDevicePowerMode(): power.DevicePowerMode {
    let powerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
    try {
      powerMode = power.getPowerMode();
    } catch (err) {
      log.showError(TAG, `getDevicePowerMode failed, code: ${err?.code}, message: ${err?.message}`);
    }
    log.showInfo(TAG, `getDevicePowerMode, powerMode: ${powerMode}`);
    return powerMode;
  }

  /**
   * 查询是否在云端模式下，有些场景需要直接查询，比如执行在taskpool里面的任务
   */
  public isEnabledOutdoorMode(): boolean {
    const isEnabledOutdoorMode1 = OutdoorConfig.getInstance().isInOutdoorMode();
    const isEnabledOutdoorMode2 = this.getDevicePowerMode() === MODE_CUSTOM_POWER_SAVE;
    log.showInfo(TAG, `isEnabledOutdoorMode: ${isEnabledOutdoorMode1} ${isEnabledOutdoorMode2}`);
    return isEnabledOutdoorMode1 || isEnabledOutdoorMode2;
  }
}
