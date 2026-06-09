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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  EvtBus,
  PluginSlot,
  PluginRequestEvent,
} from '@ohos/frameworkwrapper';

import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';
import commonEventManager from '@ohos.commonEventManager';
import { RemoteControlUtils } from '../common/RemoteControlUtils';
import { LogWithHa, StatusBarType, SpecialIconEvent, StatusBarTypeChangeEvent } from '@ohos/systemuicommon';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
import commonEvtMgr from '@ohos.commonEventManager';
// import { manager } from '@kit.NearLinkKit';
import { InnerEventUtil } from '@ohos/systemuicommon/src/main/ets/utils/InnerEventUtil';

// instrument ignore file
const TAG = 'Model.StarflashController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const SLE_CONNECTION_STATE_CONNECTED = 0x01;
const PERMISSION_CONNECT: string = 'ohos.permission.PERMISSION_USED_STATS';

/**
 * 星闪连接设备更新电量事件
 */
const NEARLINK_EVENT_BATTERY_VALUE_UPDATE = 'usual.event.nearlink.remotedevice.BATTERY_VALUE_UPDATE';

const SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'usual.event.nearlink.remotedevice.CONNECT_STATUS_VALUE'
  ],
  publisherPermission: PERMISSION_CONNECT
};

@Observed
export class StarflashData extends CommonData {
  // 是否有设备连接
  public isConnected: boolean = false;
  // active设备的电量，取值 -1 ~ 100，-1表示不支持显示电量
  public batteryValue: number = -1;
}

export class StarflashController extends BaseController<StarflashData> {
  private mStarflashData: StarflashData = new StarflashData();
  private mNearlinkSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private mNearlinkBatterySubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private statusBarType: StatusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
  // 星闪开关
  private isOn: boolean = false;
  private specialEvent: SpecialIconEvent = SpecialIconEvent.create(PluginSlot.SLOT_STATUS_STAR_FLASH, false);

  constructor() {
    super();
    this.onStart();
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    InnerEventUtil.on(StatusBarTypeChangeEvent, this.onStatusBarTypeChangeEvent);
    InnerEventUtil.produceOn(SpecialIconEvent, this.handleSpecialEvent);
    this.getNearlinkState();
    try {
      this.initConnectionState();
    } catch (e) {
      log.showError('RemoteControlUtils.getConnectionState error');
    }
    this.subscribeNearLinkState();
    this.subscribeNearlinkConnectedChangedEvent();
    this.subscribeNearlinkBatteryChangedEvent();
  }

  private handleSpecialEvent = () => {
    return this.specialEvent;
  }

  private onStatusBarTypeChangeEvent = (event: StatusBarTypeChangeEvent): void => {
    this.statusBarType = event.statusBarType;
    this.handleStateByTypeAndConnected(this.statusBarType, this.mStarflashData.isConnected, this.isOn);
  }

  private initConnectionState(): void {
    if (RemoteControlUtils.isNearLinkOn()) {
      log.showInfo(`near link is on.`);
      let devices: string[] = RemoteControlUtils.getPairedDevices();
      for (let device of devices) {
        // if (RemoteControlUtils.getConnectionState(device) === RemoteControlUtils.STATE_CONNECTED) {
          this.mStarflashData.isConnected = true;
          this.handleStateByTypeAndConnected(this.statusBarType, this.mStarflashData.isConnected, this.isOn);
        // }
      }
      log.showInfo(`mStarflashData isConnected: ${this.mStarflashData.isConnected}`);
    }
  }

  /**
   * 注册星闪连接状态
   * @returns
   */
  private async subscribeNearlinkConnectedChangedEvent(): Promise<void> {
    try {
      log.showInfo(`NearlinkConnectedChangedEvent`);
      this.mNearlinkSubscriber = await commonEventManager.createSubscriber(SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mNearlinkSubscriber, (err, data: commonEventManager.CommonEventData) => {
        if (err && err?.code !== 0) {
          LogWithHa.error(log, `Can't handle common event, err: ${err?.message}`,
            StatusBarExceptionCode.NEARLINK_FAIL, err, TAG);
          return;
        }
        this.handleNearlinkConnectedChangedEvent(data);
      });
    } catch (error) {
      LogWithHa.error(log, `createSubscriber error: ${error?.message}`,
        StatusBarExceptionCode.NEARLINK_FAIL, error, TAG);
    }
  }

  /**
   * 注册星闪开关监听
   */
  private subscribeNearLinkState(): void {
    try {
      // manager.on('stateChange', this.onNearLinkState);
    } catch (error) {
      log.showError('subscribe near link state error', error);
    }
  }

  private unSubscribeNearLinkState(): void {
    try {
      // manager.off('stateChange', this.onNearLinkState);
    } catch (error) {
      log.showError('unsubscribe near link state error', error);
    }
  }

  // private onNearLinkState = (nearLinkState: manager.NearlinkState): void => {
  //   log.showInfo(`subscribeNearLinkState stateChange : ${nearLinkState}`);
  //   this.isOn = nearLinkState === manager.NearlinkState.STATE_ON;
  //   this.handleStateByTypeAndConnected(this.statusBarType, this.mStarflashData.isConnected, this.isOn);
  // }

  /**
   * 初始化获取星闪状态
   * @returns
   */
  getNearlinkState(): void {
    try {
      // let getState: manager.NearlinkState = manager.getState();
      // this.isOn = getState === manager.NearlinkState.STATE_ON;
      this.handleStateByTypeAndConnected(this.statusBarType, this.mStarflashData.isConnected, this.isOn);
    } catch (error) {
      LogWithHa.error(log, `getNearlinkState err: code is ${error?.code}, message is ${error?.message}`,
        StatusBarExceptionCode.NEARLINK_FAIL, error, TAG);
    }
  }

  private async subscribeNearlinkBatteryChangedEvent(): Promise<void> {
    // 系统公共事件注册
    const SYSTEM_SUBSCRIBE_INFO: commonEvtMgr.CommonEventSubscribeInfo = {
      events: [
        NEARLINK_EVENT_BATTERY_VALUE_UPDATE
      ]
    };
    try {
      this.mNearlinkBatterySubscriber = await commonEvtMgr.createSubscriber(SYSTEM_SUBSCRIBE_INFO);
      commonEvtMgr.subscribe(this.mNearlinkBatterySubscriber, (err, data) => {
        // 处理电量事件
        if (err && err.code !== 0) {
          LogWithHa.error(log, `Can't handle common event, err: ${err?.message}`,
            StatusBarExceptionCode.NEARLINK_FAIL, err, TAG);
          return;
        }
        log.showWarn(`listenBattery, event: ${data.event}` + `batteryLevel: ${data.parameters?.batteryLevel}`);
        if (data.event === NEARLINK_EVENT_BATTERY_VALUE_UPDATE) {
          // 更新电量, 默认:-1
          this.mStarflashData.batteryValue = data.parameters?.batteryLevel ?? -1;
          log.showInfo(`listenConnectStatusAndBattery, batteryLeve: ${data.parameters?.batteryLevel}`);
        }
      });
    } catch (e) {
      LogWithHa.error(log, `subscribe nearlink battery error: ${e?.message}`,
        StatusBarExceptionCode.NEARLINK_FAIL, e, TAG)
    }
  }

  private handleNearlinkConnectedChangedEvent(data: commonEventManager.CommonEventData): void {
    log.showWarn(`receive nearlink connected event data, event: ${data?.event}, state: ${data?.parameters?.state}`);
    if (data && SUBSCRIBE_INFO.events.indexOf(data.event) !== -1) {
      const state: number = data.parameters?.state;
      if (state === SLE_CONNECTION_STATE_CONNECTED) {
        this.onStarflashStateChange(true);
      } else {
        this.onStarflashStateChange(false);
      }
    }
  }

  onStarflashStateChange(status: boolean): void {
    log.showInfo(`onStarflashStateChange status is ${status}`);
    this.mStarflashData.isConnected = status;
    this.handleStateByTypeAndConnected(this.statusBarType, this.mStarflashData.isConnected, this.isOn);
  }

  onStop(): void {
    super.onStop();
    InnerEventUtil.off(StatusBarTypeChangeEvent, this.onStatusBarTypeChangeEvent);
    InnerEventUtil.off(SpecialIconEvent, this.handleSpecialEvent);
    try {
      if (this.mNearlinkSubscriber) {
        commonEventManager.unsubscribe(this.mNearlinkSubscriber);
        this.mNearlinkSubscriber = null;
      }
    } catch (error) {
      log.showError('unsubscribe nearlink error');
    }
    try {
      if (this.mNearlinkBatterySubscriber) {
        commonEventManager.unsubscribe(this.mNearlinkBatterySubscriber);
        this.mNearlinkBatterySubscriber = null;
      }
    } catch (error) {
      log.showError('unsubscribe nearlink battery event error');
    }
    this.unSubscribeNearLinkState();
    log.showInfo('onStop');
  }

  getData(): StarflashData {
    return this.mStarflashData;
  }

  isAvailable(): boolean {
    return true;
  }

  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_STAR_FLASH;
  }

  /**
   * 星闪显隐受下拉和连接态控制
   */
  private handleStateByTypeAndConnected = (statusbarType: StatusBarType,
    isConnected: boolean, status: boolean): void => {
    this.handleStatusBarState(status);
    this.specialEvent.isCanShowInLauncherStatusBar = isConnected;
    EvtBus.post(SpecialIconEvent, this.specialEvent);
  }

  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    log.showInfo(`StatusBarSuperPrivacy status bar status change, newState: ${newState}, oldState: ${oldState}`);
    if (oldState !== newState) {
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }
}

let sStarflashController = SingletonHelper.getInstance(StarflashController, TAG);

export default sStarflashController as StarflashController;

