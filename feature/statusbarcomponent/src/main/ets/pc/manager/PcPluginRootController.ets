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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { EventManager, EvtBus, PluginSlot } from '@ohos/frameworkwrapper';
import { StatusBarType } from '@ohos/systemuicommon';
import {
  NotificationIconEvent,
  RealTimeNetworkSpeedEvent,
  PureShowEvent,
  CapsuleShowEvent
} from '@ohos/systemuicommon';

const TAG = 'PluginRootController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export type PluginVisibleSettingCallback = (isVisible: boolean) => void;

export interface PluginRootControllerConstructor {
  slot?: string;
  statusBarType: number;
  callback: PluginVisibleSettingCallback;
}

export class PcPluginRootController {
  /**
   * 默认状态栏（桌面和应用界面），纯净显示下，默认仅显示时间、WiFi、移动信号、电量
   */
  private static readonly INCLUDE_PURE_SHOW_SLOT: Array<string> = [PluginSlot.SLOT_STATUS_CLOCK,
    PluginSlot.SLOT_STATUS_WIFI, PluginSlot.LIVE_VIEW_CAPSULE, PluginSlot.SLOT_STATUS_SIGNAL,
    PluginSlot.SLOT_STATUS_BATTERY];
  /**
   * 锁屏状态栏，纯净显示下，默认仅显示时间、WiFi、移动信号、电量，运营商信息
   */
  private static readonly INCLUDE_PURE_SHOW_SLOT_KEYGUARD: Array<string> = [PluginSlot.SLOT_STATUS_CLOCK,
    PluginSlot.SLOT_STATUS_WIFI, PluginSlot.SLOT_STATUS_SIGNAL, PluginSlot.SLOT_STATUS_BATTERY,
    PluginSlot.SLOT_STATUS_OPERATOR];

  /**
   * 状态栏（锁屏、桌面、应用界面），胶囊显示下，不显示通知图标
   */
  private static readonly EXCLUDE_CAPSULE_SHOW_SLOT: Array<string> = [PluginSlot.SLOT_STATUS_NOTIFICATION];
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * plugin唯一标识
   */
  private slot: string;
  /**
   * 状态栏类型，默认桌面状态栏
   */
  private statusBarType: number;
  /**
   * 是否纯净显示
   */
  private isPureShow?: boolean;
  /**
   * 是否胶囊显示
   */
  private isCapsuleShow?: boolean = false;
  /**
   * 是否显示通知图标
   */
  private isNotificationIconEnable?: boolean;
  /**
   * 是否显示网速图标
   */
  private isRealTimeNetworkIconEnable?: boolean;
  /**
   * 图标可见性
   */
  private isPluginVisibleSetting: boolean = true;
  private callback: PluginVisibleSettingCallback;

  // 仅在StatusBarGroup组件中不传slot
  constructor(options: PluginRootControllerConstructor) {
    this.slot = options.slot ?? '';
    this.statusBarType = options.statusBarType;
    this.callback = options.callback;
  }

  /**
   * 初始化Controller
   */
  onStart(): void {
    this.listenStatusBarSettingEvent();
  }

  /**
   * 监听状态栏设置变化的事件
   */
  private listenStatusBarSettingEvent() {
    // Pc产品不响应状态栏设置
    if (StatusBarType.isMacStyle(this.statusBarType) || StatusBarType.isWindowStyle(this.statusBarType)) {
      return;
    }

    // 监听当前四种图标显示隐藏的事件，给图标父容器StatusBarGroup组件使用（如果不传slot）
    if (!this.slot) {
      this.eventMgr
        .on(NotificationIconEvent, this.onEvents)// .on(RealTimeNetworkSpeedEvent, this.onEvents)
        .on(PureShowEvent, this.onEvents)
        .on(CapsuleShowEvent, this.onEvents)
      return;
    }

    // 通知图标显示
    if (this.slot === PluginSlot.SLOT_STATUS_NOTIFICATION) {
      this.eventMgr.on(NotificationIconEvent, this.onNotificationIconEvent);
    }

    // 网速图标显示
    if (this.slot === PluginSlot.SLOT_STATUS_NET_SPEED) {
      this.eventMgr.on(RealTimeNetworkSpeedEvent, this.onRealTimeNetworkSpeedEvent);
    }

    // 非下拉状态栏需要响应纯净显示设置
    if (!StatusBarType.isDropdown(this.statusBarType)) {
      this.listenPureShowEvent();
    }
  }

  /**
   * 监听纯净显示开关变化的事件
   */
  private listenPureShowEvent(): void {
    log.showInfo('listenPureShowEvent slot: ' + this.slot);
    let pureShowSlotArr: string[];
    if (StatusBarType.isKeyguard(this.statusBarType)) {
      pureShowSlotArr = PcPluginRootController.INCLUDE_PURE_SHOW_SLOT_KEYGUARD;
    } else {
      pureShowSlotArr = PcPluginRootController.INCLUDE_PURE_SHOW_SLOT;
    }
    if (!ArrayUtils.contains(pureShowSlotArr, this.slot)) {
      this.eventMgr.on(PureShowEvent, this.onPureShowEvent);
    }
    if (ArrayUtils.contains(PcPluginRootController.EXCLUDE_CAPSULE_SHOW_SLOT, this.slot)) {
      this.eventMgr.on(CapsuleShowEvent, this.onCapsuleShowEvent);
    }
  }

  /**
   * 销毁Controller
   */
  onStop(): void {
    this.eventMgr.offAll();
  }

  /**
   * 获取状态栏类型
   * ComponentCallback复写
   *
   * @return 状态栏类型
   */
  getStatusBarType(): number {
    return this.statusBarType;
  }

  /**
   * 纯净显示设置变化回调
   *
   * @param event 状态栏纯净显示开关事件
   */
  private onPureShowEvent = (event: PureShowEvent): void => {
    let isEnable = event.isPureShowEnable();
    log.showInfo('onPureShowEvent isEnable: ' + isEnable);
    if (this.isPureShow !== isEnable) {
      this.isPureShow = isEnable;
      this.pluginVisibleSetting();
    }
  }
  /**
   * 纯净显示设置变化回调
   *
   * @param event 状态栏纯净显示开关事件
   */
  private onCapsuleShowEvent = (event: CapsuleShowEvent): void => {
    let isEnable = event.isCapsuleShow;
    log.showInfo('onCapsuleShowEvent isEnable: ' + isEnable);
    if (this.isCapsuleShow !== isEnable) {
      this.isCapsuleShow = isEnable;
      this.pluginVisibleSetting();
    }
  }
  /**
   * 显示通知图标设置变化回调
   *
   * @param event 状态栏显示通知图标开关事件
   */
  private onNotificationIconEvent = (event: NotificationIconEvent): void => {
    let isEnable = event.isNotificationIconEnable();
    log.showInfo('onNotificationIconEvent isEnable: ' + isEnable);
    if (this.isNotificationIconEnable !== isEnable) {
      this.isNotificationIconEnable = isEnable;
      this.pluginVisibleSetting();
    }
  }
  /**
   * 显示网速设置变化回调
   *
   * @param event 状态栏显示网速开关事件
   */
  private onRealTimeNetworkSpeedEvent = (event: RealTimeNetworkSpeedEvent): void => {
    let isEnable = event.isRealTimeNetworkSpeedEnable();
    log.showInfo('onRealTimeNetworkSpeedEvent isEnable: ' + isEnable);
    if (this.isRealTimeNetworkIconEnable !== isEnable) {
      this.isRealTimeNetworkIconEnable = isEnable;
      this.pluginVisibleSetting();
    }
  }

  /**
   * 刷新状态栏图标显示
   */
  private pluginVisibleSetting(): void {
    log.showInfo('pluginVisibleSetting this.slot:' + this.slot);
    if (StatusBarType.isMacStyle(this.statusBarType) || StatusBarType.isWindowStyle(this.statusBarType)) {
      log.showWarn('pluginVisibleSetting is Pc, return');
      return;
    }
    if (this.isCapsuleShow) {
      // 胶囊开启，隐藏通知图标
      this.isPluginVisibleSetting = false;
      this.callback(this.isPluginVisibleSetting);
      return;
    }
    // 通知图标
    if (this.slot === PluginSlot.SLOT_STATUS_NOTIFICATION && this.isNotificationIconEnable !== undefined) {
      this.isPluginVisibleSetting = this.isNotificationIconEnable;
      this.callback(this.isPluginVisibleSetting);
      return;
    }

    if (this.slot === PluginSlot.SLOT_STATUS_NET_SPEED && this.isRealTimeNetworkIconEnable !== undefined) {
      this.isPluginVisibleSetting = this.isRealTimeNetworkIconEnable;
      this.callback(this.isPluginVisibleSetting);
      return;
    }

    let isCurrentVisibleSetting = !this.isPureShow;
    if (this.isPluginVisibleSetting !== isCurrentVisibleSetting) {
      this.isPluginVisibleSetting = isCurrentVisibleSetting;
      this.callback(this.isPluginVisibleSetting);
    }
  }

  /**
   * 同时监听多种事件，仅触发回调
   */
  private onEvents = (): void => {
    this.callback(true);
  }
}