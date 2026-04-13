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
import {
  EvtBus,
  DeviceHelper,
  PluginSlot,
  EventManager,
  OobeActivatedEvent
} from '@ohos/frameworkwrapper';
import { SCBOobeManager } from '@ohos/windowscene';
import {
  NotificationIconEvent,
  PureShowEvent,
  RealTimeNetworkSpeedEvent,
} from '@ohos/systemuicommon';
import {
  StatusBarType,
  scbStatusBarStatusManager,
} from '@ohos/systemuicommon/Index';
import display from '@ohos.display';
// instrument ignore file
const TAG = 'PluginRootController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export type PluginVisibleSettingCallback = (isVisible: boolean) => void;

export interface PluginRootControllerConstructor {
  slot?: string;
  statusBarType: number;
  callback: PluginVisibleSettingCallback;
}

export class PluginRootController {
  /**
   * 默认状态栏（桌面和应用界面），纯净显示下，默认允许时间、WiFi、胶囊、信号、电量、超级隐私、定位、热点、通知、网速 显示
   */
  private static readonly INCLUDE_PURE_SHOW_SLOT: Array<string> = [PluginSlot.SLOT_STATUS_CLOCK,
    PluginSlot.SLOT_STATUS_WIFI, PluginSlot.LIVE_VIEW_CAPSULE, PluginSlot.SLOT_STATUS_SIGNAL,
    PluginSlot.SLOT_STATUS_BATTERY, PluginSlot.SLOT_STATUS_SUPER_PRIVACY, PluginSlot.SLOT_STATUS_LOCATION,
    PluginSlot.SLOT_STATUS_HOT_SPOT, PluginSlot.SLOT_STATUS_NOTIFICATION, PluginSlot.SLOT_STATUS_NET_SPEED,
    PluginSlot.SLOT_STATUS_ETHERNET];
  /**
   * 锁屏状态栏，纯净显示下，默认允许显示 时间、WiFi、移动信号、电量，运营商信息、超级隐私、地理位置隐私指示器、网速
   */
  private static readonly INCLUDE_PURE_SHOW_SLOT_KEYGUARD: Array<string> = [PluginSlot.SLOT_STATUS_CLOCK,
    PluginSlot.SLOT_STATUS_WIFI, PluginSlot.SLOT_STATUS_SIGNAL, PluginSlot.SLOT_STATUS_BATTERY,
    PluginSlot.SLOT_STATUS_OPERATOR, PluginSlot.SLOT_STATUS_SUPER_PRIVACY, PluginSlot.SLOT_STATUS_LOCATION,
    PluginSlot.SLOT_STATUS_HOT_SPOT, PluginSlot.SLOT_STATUS_NET_SPEED, PluginSlot.SLOT_STATUS_ETHERNET];

  /**
   * 扩展新形态小折叠产品外屏所有显示的图标
   */
  private static readonly PLUGINS_OUTER_HOME_OUTER_SCREEN: Array<string> = [PluginSlot.SLOT_STATUS_CLOCK,
    PluginSlot.SLOT_STATUS_WIFI, PluginSlot.LIVE_VIEW_CAPSULE, PluginSlot.SLOT_STATUS_SIGNAL,
    PluginSlot.SLOT_STATUS_BATTERY, PluginSlot.SLOT_STATUS_NOTIFICATION, PluginSlot.SLOT_STATUS_LOCATION,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY, PluginSlot.SLOT_STATUS_HOT_SPOT, PluginSlot.SLOT_STATUS_ETHERNET];
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
   * 判断是否处于OOBE阶段
   */
  private isInOobe = false;

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
  private isFoldStatusRegister = false;

  // 仅在StatusBarGroup组件中不传slot
  constructor(options: PluginRootControllerConstructor) {
    this.slot = options.slot ?? '';
    this.statusBarType = options.statusBarType;
    this.callback = options.callback;
  }

  public static getPureShowPlugin(statusbarType?: number): Array<string> {
    if (statusbarType === StatusBarType.TYPE_MAIN_PHONE_KEYGUARD) {
      return PluginRootController.INCLUDE_PURE_SHOW_SLOT_KEYGUARD;
    }
    return PluginRootController.INCLUDE_PURE_SHOW_SLOT;
  }

  /**
   * 初始化Controller
   */
  onStart(): void {
    log.showInfo(`PluginRootController(${this.slot}) onStart`);
    this.initOobePureShow();
    this.listenStatusBarSettingEvent();
    this.registerFoldStatusListener();
  }

  /**
   * 监听折叠屏状态
   */
  public registerFoldStatusListener(): void {
    if (!this.isAllowRegisterFoldListener()) {
      return;
    }
    try {
      display.on('foldStatusChange', this.foldStatusCallback);
      this.isFoldStatusRegister = true;
    } catch (error) {
      log.showError('registerFoldStatusListener on error');
    }
  }

  /**
   * 注销监听
   */
  public unRegisterFoldStatusListener(): void {
    if (!this.isFoldStatusRegister) {
      return;
    }
    try {
      display.off('foldStatusChange', this.foldStatusCallback);
      this.isFoldStatusRegister = false;
    } catch (error) {
      log.showError('unRegisterFoldStatusListener on error');
    }
  }

  private isAllowRegisterFoldListener(): boolean {
    if (this.slot !== PluginSlot.LIVE_VIEW_CAPSULE ||
    this.isFoldStatusRegister) {
      return false;
    }
    return true;
  }

  private foldStatusCallback = (newFoldStatus: display.FoldStatus) => {
    // 锁屏折叠态需要刷新图标
    if (newFoldStatus === display.FoldStatus.FOLD_STATUS_FOLDED &&
      this.getStatusBarType() === StatusBarType.TYPE_MAIN_PHONE_KEYGUARD) {
      this.pluginVisibleSetting();
    }
  };

  private initOobePureShow(): void {
    // OOBE阶段，状态栏需要处理纯净显示
    this.isInOobe = SCBOobeManager.isOobeActivated();
    log.showInfo(`PluginRootController(${this.slot}) init isOobe is ${this.isInOobe}.`);
    this.pluginVisibleSetting();
  }

  /**
   * 监听状态栏设置变化的事件
   */
  private listenStatusBarSettingEvent() {
    // 监听当前四种图标显示隐藏的事件，给图标父容器StatusBarGroup组件使用（如果不传slot）
    if (!this.slot) {
      this.eventMgr
        .on(NotificationIconEvent, this.onEvents)// .on(RealTimeNetworkSpeedEvent, this.onEvents)
        .on(PureShowEvent, this.onEvents)
        .on(OobeActivatedEvent, this.onEvents)
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

    this.listenPureShowEvent();
  }

  /**
   * 监听纯净显示开关变化的事件
   */
  private listenPureShowEvent(): void {
    log.showInfo('listenPureShowEvent slot: ' + this.slot);

    this.eventMgr
      .on(PureShowEvent, this.onPureShowEvent)
      .on(OobeActivatedEvent, this.onOobeChangeEvent);
  }

  /**
   * 销毁Controller
   */
  onStop(): void {
    this.eventMgr.offAll();
    this.unRegisterFoldStatusListener();
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
   * OOBE阶段变化回调
   *
   * @param event OOBE阶段变化事件
   */
  private onOobeChangeEvent = (event: OobeActivatedEvent): void => {
    let isActivated: boolean = event.isActivated;
    let isOobe = SCBOobeManager.isOobeActivated();
    this.isInOobe = (isActivated || isOobe) ?? false;
    log.showInfo(`onOobeChangeEvent(${this.slot}), isInOobe is ${this.isInOobe}`);
    this.pluginVisibleSetting();
  }
  /**
   * 纯净显示设置变化回调
   *
   * @param event 状态栏纯净显示开关事件
   */
  private onPureShowEvent = (event: PureShowEvent): void => {
    let isEnable = event.isPureShowEnable();
    log.showInfo(`onPureShowEvent(${this.slot}) pureShow old: ${this.isPureShow} new: ${isEnable}`);
    if (isEnable === undefined) {
      return;
    }
    this.isPureShow = isEnable;
    this.pluginVisibleSetting();
  }

  /**
   * 显示通知图标设置变化回调
   *
   * @param event 状态栏显示通知图标开关事件
   */
  private onNotificationIconEvent = (event: NotificationIconEvent): void => {
    log.showInfo(`onNotificationIconEvent(${this.slot}),isEnable is ${event.isNotificationIconEnable()}`);
    let isEnable = event.isNotificationIconEnable();
    this.isNotificationIconEnable = isEnable;
    this.pluginVisibleSetting();
  }
  /**
   * 显示网速设置变化回调
   *
   * @param event 状态栏显示网速开关事件
   */
  private onRealTimeNetworkSpeedEvent = (event: RealTimeNetworkSpeedEvent): void => {
    let isEnable = event.isRealTimeNetworkSpeedEnable();
    log.showInfo(`onRealTimeNetworkSpeedEvent(${this.slot}) isEnable: ${isEnable}.`);
    this.isRealTimeNetworkIconEnable = isEnable;
    this.pluginVisibleSetting();
  }

  refreshWhenStatusBarChange(statusBarType: number) {
    this.statusBarType = statusBarType;
    // 纯净模式下更新系统图标
    log.showInfo(`refreshWhenStatusBarChange ${this.statusBarType}`)
    this.pluginVisibleSetting();
  }
  /**
   * 同时监听多种事件，仅触发回调
   */
  private onEvents = (): void => {
    this.callback(true);
  }

  private pluginVisibleSetting(): void {
    let cacheVisible = this.isPluginVisibleSetting;
    if (this.isInOobe && !this.isPluginOOBEShow()) {
      // OOBE 图标显示过滤
      this.isPluginVisibleSetting = false;
    } else if (this.isPureShow && !this.isPluginPureShow()) {
      // 纯净显示 图标显示过滤
      this.isPluginVisibleSetting = false;
    } else {
      // 其余场景图标显示过滤
      this.isPluginVisibleSetting = this.isNormalShow();
    }
    // 只有可见设置变化才调用 callback
    if (cacheVisible !== this.isPluginVisibleSetting) {
      this.callback(this.isPluginVisibleSetting);
    }
    // 设置通知图标是否显示
    this.setNtfIconShow(this.isPluginVisibleSetting);
  }

  /**
   * 设置当前通知图标是否显示
   */
  private setNtfIconShow(isPluginVisibleSetting: boolean): void {
    if (this.slot === PluginSlot.SLOT_STATUS_NOTIFICATION) {
      scbStatusBarStatusManager.setNtfIconShow(isPluginVisibleSetting);
    }
  }

  /**
   * 计算当前图标是否应该在纯净模式下显示
   */
  private isPluginPureShow(): boolean {
    if (this.statusBarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
      // 纯净显示在下拉时不生效
      return true;
    }
    if (this.slot === PluginSlot.LIVE_VIEW_CAPSULE &&
      this.statusBarType === StatusBarType.TYPE_MAIN_PHONE_LAUNCHER) {
      // 桌面状态栏纯净显下要显示胶囊
      return true;
    }

    let pureShowSlotArr: string[];
    if (StatusBarType.isKeyguard(this.statusBarType)) {
      pureShowSlotArr = this.getKeyguardPurePlugin(false);
    } else {
      pureShowSlotArr = PluginRootController.INCLUDE_PURE_SHOW_SLOT;
    }
    return ArrayUtils.contains(pureShowSlotArr, this.slot);
  }

  private getKeyguardPurePlugin(isOuterHomeFolded: boolean): Array<string> {
      return PluginRootController.INCLUDE_PURE_SHOW_SLOT_KEYGUARD;
  }

  /**
   * 计算当前图标是否应该在OOBE模式显示
   */
  private isPluginOOBEShow(): boolean {
    if (this.slot === PluginSlot.SLOT_STATUS_NOTIFICATION) {
      // OOBE场景下不显示通知图标
      return false;
    }
    return this.isPluginPureShow();
  }

  /**
   * 判断图标当前是否要显示
   */
  private isNormalShow(): boolean {
    if (this.slot === PluginSlot.SLOT_STATUS_NOTIFICATION) {
      return this.isNotificationIconEnable ?? true;
    }
    if (this.slot === PluginSlot.SLOT_STATUS_NET_SPEED) {
      return this.isRealTimeNetworkIconEnable ?? false;
    }
    return true;
  }
}
