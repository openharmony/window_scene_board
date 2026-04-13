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

import { SingletonHelper, LogDomain, LogHelper, TraceUtil, DomainName } from '@ohos/basicutils';
import { EvtBus, EventManager } from '@ohos/frameworkwrapper';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { DataShareUtils, SettingsConstant } from './DataShareUtils';
import {
  TimeFormatEvent,
  NtfHideContentEvent,
  NtfAutoScreenOnEvent,
  PureShowEvent,
  NotificationIconEvent,
  RealTimeNetworkSpeedEvent,
  BatterySocEvent,
  CellularDataEnableEvent,
  FocusModeSwitchDataEvent,
  SuperHubSwitchDataEvent,
  FaceSwitchEnableEvent,
  FingerprintUnlockSwitchEnableEvent,
  HiddenBannerNtfEnableEvent,
  UnifiedGroupEnableEvent,
  SatelliteModeSwitchEvent,
  SpaceSlidingSwitchEvent,
  GrabScreenCaptureSwitchEvent,
  MultiDeviceCollaborationServiceEnableEvent,
  DistributedModemSwitchEvent,
  SpaceShareSwitchEvent,
  LiveViewHideContentEvent,
  BasicStatementAgreedEvent,
  ForbiddenGestureSwitchEvent,
  EnableSwitchEvent,
  BasicStatementAgreedSecureEvent,
  SlNtfStyleChangeEvent,
  VibrateSwitchEvent,
  AppNtfConfigShowContentKGEvent,
  FlashReminderSwitchEvent,
  FlashReminderSlotChangeEvent,
} from './SysUIDataShareEvent';
import DataShare from '@ohos.data.dataShare';
import type Context from '@ohos.app.ability.common';
import { DataShareEvent } from './DataShareEvent';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../maintenance/CommonExceptionCode';


const TAG = 'SysUI_DataShareManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const MAX_RETRY_TIMES: number = 5; // dataShare最多重试次数
const RETRY_INTERVAL_MS: number = 1500; // 重试间隔
const loadSettingsDataTraceName: string = 'LoadSystemUISettingsData';
export type DataShareType = number | boolean;

/**
 * 数据共享管理
 * 包含设置数据库
 *
 * @since 2022-12-10
 */
class DataShareManager {
  /**
   * 环境
   */
  private context: Context.ExtensionContext;

  /**
   * 数据共享数据变化事件集
   * 数据库uri路径 => 共享数据uri路径 => 事件
   */
  private shareEventMap: Map<string, Map<string, DataShareEvent<boolean | string>>> = new Map();

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 初始化
   *
   * @param context 环境
   */
  async init(context: Context.ExtensionContext): Promise<void> {
    this.context = context;
    // 初始化事件集
    await this.initEventMap();
  }

  /**
   * 初始化事件集
   */
  private async initEventMap(): Promise<void> {
    // 设置数据库map
    let settingsMap: Map<string, DataShareEvent<boolean | string>> = new Map();
    // 设置数据库map多用户
    let settingsSecureMap: Map<string, DataShareEvent<boolean | string>> = new Map();
    // 时间小时制事件
    let timeFormatEvent = new TimeFormatEvent();
    settingsMap.set(timeFormatEvent.dataShareUri, timeFormatEvent);
    // 隐藏通知内容事件
    let ntfHideContentEvent = new NtfHideContentEvent();
    await ntfHideContentEvent.init();
    settingsSecureMap.set(ntfHideContentEvent.dataShareUri, ntfHideContentEvent);
    // 隐藏实况内容事件
    let liveViewHideContentEvent = new LiveViewHideContentEvent();
    await liveViewHideContentEvent.init();
    settingsSecureMap.set(liveViewHideContentEvent.dataShareUri, liveViewHideContentEvent);
    // 收到通知自动亮屏事件
    let ntfAutoScreenOnEvent = new NtfAutoScreenOnEvent();
    await ntfAutoScreenOnEvent.init();
    settingsSecureMap.set(ntfAutoScreenOnEvent.dataShareUri, ntfAutoScreenOnEvent);
    // 显示移动数据开关事件
    let cellularDataEnableEvent = new CellularDataEnableEvent();
    settingsMap.set(cellularDataEnableEvent.dataShareUri, cellularDataEnableEvent);
    let focusModeSwitchDataEvent = new FocusModeSwitchDataEvent();
    await focusModeSwitchDataEvent.init();
    settingsMap.set(focusModeSwitchDataEvent.dataShareUri, focusModeSwitchDataEvent);
    // 闪烁提醒开关
    let flashReminderSwitchEvent = new FlashReminderSwitchEvent();
    await flashReminderSwitchEvent.init();
    settingsSecureMap.set(flashReminderSwitchEvent.dataShareUri, flashReminderSwitchEvent);
    // 闪烁提醒启用方式
    let flashReminderSlotChangeEvent = new FlashReminderSlotChangeEvent();
    await flashReminderSlotChangeEvent.init();
    settingsSecureMap.set(flashReminderSlotChangeEvent.dataShareUri, flashReminderSlotChangeEvent);
    // 监听人脸开关的开启和关闭
    let faceSwitchEnableEvent = new FaceSwitchEnableEvent();
    settingsSecureMap.set(faceSwitchEnableEvent.dataShareUri, faceSwitchEnableEvent);
    // 监听智能横幅通知隐藏内容开关的开启关闭状态事件
    let hiddenBannerNtfEnableEvent = new HiddenBannerNtfEnableEvent();
    settingsSecureMap.set(hiddenBannerNtfEnableEvent.dataShareUri, hiddenBannerNtfEnableEvent);
    // 中转站开关
    let superHubSwitchDataEvent = new SuperHubSwitchDataEvent();
    settingsMap.set(superHubSwitchDataEvent.dataShareUri, superHubSwitchDataEvent);
    // 隔空滑动开关事件
    let spaceSlidingSwitchEvent = new SpaceSlidingSwitchEvent();
    await spaceSlidingSwitchEvent.init();
    settingsSecureMap.set(spaceSlidingSwitchEvent.dataShareUri, spaceSlidingSwitchEvent);
    // 隔空截屏开关事件
    let grabScreenCaptureSwitchEvent = new GrabScreenCaptureSwitchEvent();
    await grabScreenCaptureSwitchEvent.init();
    settingsSecureMap.set(grabScreenCaptureSwitchEvent.dataShareUri, grabScreenCaptureSwitchEvent);
    // 隔空分享开关事件
    let spaceShareSwitchEvent = new SpaceShareSwitchEvent();
    await spaceShareSwitchEvent.init();
    settingsSecureMap.set(spaceShareSwitchEvent.dataShareUri, spaceShareSwitchEvent);
    // 智能聚合开关
    let unifiedGroupEnableEvent = new UnifiedGroupEnableEvent();
    settingsSecureMap.set(unifiedGroupEnableEvent.dataShareUri, unifiedGroupEnableEvent);
    // 互联互通服务开关事件
    let multiDeviceCollaborationServiceEnableEvent = new MultiDeviceCollaborationServiceEnableEvent();
    settingsMap.set(multiDeviceCollaborationServiceEnableEvent.dataShareUri, multiDeviceCollaborationServiceEnableEvent);
    await this.initStatusBarSettingEvent(settingsSecureMap);
    // 声音与振动-响铃时振动开关
    const vibrateSwitchEvent = new VibrateSwitchEvent();
    await vibrateSwitchEvent.init();
    settingsMap.set(vibrateSwitchEvent.dataShareUri, vibrateSwitchEvent);
    this.shareEventMap.set(SettingsConstant.SETTINGS_URI, settingsMap);
    this.shareEventMap.set(SettingsConstant.SETTINGS_URI + 'Secure', settingsSecureMap);
    // 仙人掌开关事件
    let satelliteModeSwitchEvent = new SatelliteModeSwitchEvent();
    settingsMap.set(satelliteModeSwitchEvent.dataShareUri, satelliteModeSwitchEvent);
    // oobe声明与协议同意开关事件
    let basicStatementAgreedEvent = BasicStatementAgreedEvent.get();
    settingsMap.set(basicStatementAgreedEvent.dataShareUri, basicStatementAgreedEvent);
    // oobe声明与协议同意开关事件 Secure 库
    let basicStatementAgreedSecureEvent = new BasicStatementAgreedSecureEvent();
    await basicStatementAgreedSecureEvent.init();
    settingsSecureMap.set(basicStatementAgreedSecureEvent.dataShareUri, basicStatementAgreedSecureEvent);
    // 手写笔防误触开关
    let forbiddenGestureSwitchEvent = new ForbiddenGestureSwitchEvent();
    settingsMap.set(forbiddenGestureSwitchEvent.dataShareUri, forbiddenGestureSwitchEvent);
    // 锁屏通知显示样式更新事件
    let slNtfStyleChangeEvent = new SlNtfStyleChangeEvent();
    await slNtfStyleChangeEvent.init();
    settingsMap.set(slNtfStyleChangeEvent.dataShareUri, slNtfStyleChangeEvent);
    // 显示锁屏通知内容事件
    let appNtfConfigShowContentKGEvent = new AppNtfConfigShowContentKGEvent();
    await appNtfConfigShowContentKGEvent.init();
    settingsSecureMap.set(appNtfConfigShowContentKGEvent.dataShareUri, appNtfConfigShowContentKGEvent);
    // TODO 其他数据库map
    // 初始化事件数据值，注册事件生产者
    TraceUtil.startTrace(DomainName.SYS_UI, loadSettingsDataTraceName);
    log.showInfo('Init dataShare begin');
    this.shareEventMap.forEach((eventMap) => {
      eventMap.forEach((event) => {
        // 第一次加载数据
        event.onDataChange(true).then(() => {
          // 注册生产者
          this.eventMgr.produceOn(event.getEventClass(), (): DataShareEvent<boolean | string> => event);});
      });
    });
    TraceUtil.endTrace(DomainName.SYS_UI, loadSettingsDataTraceName);
    // 初始化设置数据库dataShare
    let mUri = DataShareUtils.getSettingsUriSync(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON);
    this.subscribeDataShare(settingsMap, SettingsConstant.SETTINGS_URI, mUri, MAX_RETRY_TIMES);
    let mUriSecure = DataShareUtils.getSettingsSecureUriSync(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON);
    this.subscribeDataShare(settingsSecureMap, SettingsConstant.SETTINGS_URI + 'Secure', mUriSecure, MAX_RETRY_TIMES);
  }

  /**
   * 初始化状态栏设置的事件
   *
   * @param settingsMap 状态栏设置数据库map
   */
  private async initStatusBarSettingEvent(settingsMap: Map<string, DataShareEvent<boolean | string>>): Promise<void> {
    // 状态栏使能开关事件注册 由于事件类型都相同，所以用同一个事件不同key来触发
    let enableSwitchEvent = new EnableSwitchEvent(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED);
    await enableSwitchEvent.init();
    settingsMap.set(enableSwitchEvent.dataShareUri, enableSwitchEvent);
    enableSwitchEvent = new EnableSwitchEvent(SettingsKeyConstants.SHOW_VPN_ICON);
    await enableSwitchEvent.init();
    settingsMap.set(enableSwitchEvent.dataShareUri, enableSwitchEvent);
    enableSwitchEvent = new EnableSwitchEvent(SettingsKeyConstants.SHOW_RING_MODE_ICON);
    await enableSwitchEvent.init();
    settingsMap.set(enableSwitchEvent.dataShareUri, enableSwitchEvent);
    enableSwitchEvent = new EnableSwitchEvent(SettingsKeyConstants.SHOW_NEARLINK_ICON);
    await enableSwitchEvent.init();
    settingsMap.set(enableSwitchEvent.dataShareUri, enableSwitchEvent);
    enableSwitchEvent = new EnableSwitchEvent(SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON);
    await enableSwitchEvent.init();
    settingsMap.set(enableSwitchEvent.dataShareUri, enableSwitchEvent);
    enableSwitchEvent = new EnableSwitchEvent(SettingsKeyConstants.SHOW_NFC_ICON);
    await enableSwitchEvent.init();
    settingsMap.set(enableSwitchEvent.dataShareUri, enableSwitchEvent);
    enableSwitchEvent = new EnableSwitchEvent(SettingsKeyConstants.SHOW_HEAD_PHONES_ICON);
    await enableSwitchEvent.init();
    settingsMap.set(enableSwitchEvent.dataShareUri, enableSwitchEvent);

    // 纯净显示事件
    let pureShowEvent = new PureShowEvent();
    await pureShowEvent.init();
    settingsMap.set(pureShowEvent.dataShareUri, pureShowEvent);
    // 显示通知图标事件
    let notificationIconEvent = new NotificationIconEvent();
    await notificationIconEvent.init();
    settingsMap.set(notificationIconEvent.dataShareUri, notificationIconEvent);
    // 显示实时网速事件
    let realTimeNetworkSpeedEvent = new RealTimeNetworkSpeedEvent();
    await realTimeNetworkSpeedEvent.init();
    settingsMap.set(realTimeNetworkSpeedEvent.dataShareUri, realTimeNetworkSpeedEvent);
    // 显示电池电量百分比
    let batterySocEvent = new BatterySocEvent();
    await batterySocEvent.init();
    settingsMap.set(batterySocEvent.dataShareUri, batterySocEvent);
    // 指纹解锁开关事件
    let fingerprintUnlockSwitchEnableEvent = new FingerprintUnlockSwitchEnableEvent();
    await fingerprintUnlockSwitchEnableEvent.init();
    settingsMap.set(fingerprintUnlockSwitchEnableEvent.dataShareUri, fingerprintUnlockSwitchEnableEvent);
  }

  private subscribeDataShare(eventMap: Map<string, DataShareEvent<boolean | string>>, dbUri: string, mUri: string, leftRetryTimes: number): void {
    if (leftRetryTimes <= 0) {
      log.error('no left retry times');
      return;
    }

    log.showInfo('subscribeDataShare[%{public}d]: %{public}s,%{public}s', leftRetryTimes, dbUri, mUri);
    try {
      DataShare.createDataShareHelper(this.context, mUri).then((dataShare) => {
        eventMap.forEach((event, dataUri) => {
          dataShare.on('dataChange', dataUri, this.onDataChange.bind(this, dbUri, dataUri));
        });
      }).catch((error) => {
        LogWithHa.error(log, `initDataShare error: ${error}`, CommonExceptionCode.CREATE_DATA_SHARE_FAIL, error);
        setTimeout(this.subscribeDataShare.bind(this, eventMap, dbUri, mUri, leftRetryTimes - 1), RETRY_INTERVAL_MS);
      });
    } catch (error) {
      LogWithHa.error(log, `initDataShare catch error: ${error}`, CommonExceptionCode.CREATE_DATA_SHARE_FAIL, error);
      setTimeout(this.subscribeDataShare.bind(this, eventMap, dbUri, mUri, leftRetryTimes - 1), RETRY_INTERVAL_MS);
    }
  }

  /**
   * 共享数据库数据变化回调
   *
   * @param dbUri 数据库路径
   * @param dataShareUri 数据路径
   */
  private onDataChange(dbUri: string, dataShareUri: string): void {
    log.showInfo(`onDataChange: dbUri ${dbUri}  dataShareUri ${dataShareUri}`);
    this.shareEventMap.get(dbUri)?.get(dataShareUri)?.onDataChange();
  }
}

// 单例
export let DataShareMgr: DataShareManager = SingletonHelper.getInstance(DataShareManager, TAG);