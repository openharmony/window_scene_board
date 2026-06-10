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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { OobeActivatedEvent, PluginSlot } from '@ohos/frameworkwrapper';
import {
  CutoutVm,
  DropdownVm,
  IStatusBarIconVm, IStatusBarSettingVm, StatusBarBaseVm, EnvVm } from '@ohos/systemuicommon/newIndex';
import { NotificationIconEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  OobeAdapter,
  EnableSwitchEvent,
  StatusBarType,
  OperatorClockChangeEvent,
  SpecialIconEvent
} from '@ohos/systemuicommon/src/main/ets/TsIndex';

import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex'
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { IconFilterType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';

const TAG = 'StatusBarSettingVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class StatusBarSettingVm extends StatusBarBaseVm implements IStatusBarSettingVm {
  private dropDownVm: DropdownVm = DropdownVm.instance;

  /**
   * 是否为纯净模式
   */
  @Trace public isPureShow: boolean = false;
  /**
   * 是否为OOBE模式
   */
  @Trace public isOobe: boolean = true;

  /**
   * 是否锁屏内应用
   */
  @Trace public isLockInApp: boolean = false;

  /**
   * 是否通知中心显示时间
   */
  @Trace public isShowClockInNC: boolean = false;

  /**
   * 使能开关数据
   */
  @Trace public switchInfo: Map<SettingsKeyConstants, boolean> = new Map();

  /**
   * 特殊的可在桌面显示的图标
   */
  @Trace public specialHideIcon: Set<string> = new Set();

  @Trace public iconFilterType: IconFilterType = IconFilterType.DEFAULT;

  @Trace private isMiddleCutout: boolean = CutoutVm.instance.isMiddleCutout();

  /**
   * oobe下允许显示的图标
   */
  protected static readonly OOBE_SLOT: Array<string> = [PluginSlot.SLOT_STATUS_CLOCK,
    PluginSlot.SLOT_STATUS_WIFI, PluginSlot.SLOT_STATUS_SIGNAL, PluginSlot.SLOT_STATUS_BATTERY,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY, PluginSlot.SLOT_STATUS_LOCATION,
    PluginSlot.SLOT_STATUS_HOT_SPOT, PluginSlot.SLOT_STATUS_NET_SPEED, PluginSlot.SLOT_STATUS_ETHERNET];
  protected envVm: EnvVm = EnvVm.instance;
  private filterRuleCheckMap: Map<IconFilterType, Function> =
    new Map([
      [IconFilterType.DEFAULT,
        (enableSwitchState: boolean, pluginName: string) => this.checkDefaultFilterRule(enableSwitchState,
          pluginName)],
      [IconFilterType.DROPDOWN,
        (enableSwitchState: boolean, pluginName: string) => this.checkDropdownFilterRule(enableSwitchState,
          pluginName)],
      [IconFilterType.KEYGUARD,
        (enableSwitchState: boolean, pluginName: string) => this.checkKeyguardFilterRule(enableSwitchState,
          pluginName)],
      [IconFilterType.KEYGUARD_IN_APP,
        (enableSwitchState: boolean, pluginName: string) => this.checkKeyguardInAppFilterRule(enableSwitchState,
          pluginName)],
      [IconFilterType.OOBE,
        (enableSwitchState: boolean, pluginName: string) => this.checkOobeFilterRule(enableSwitchState,
          pluginName)],
      [IconFilterType.OOBE_AND_KEYGUARD,
        (enableSwitchState: boolean, pluginName: string) => this.checkOobeAndKeyguardFilterRule(enableSwitchState,
          pluginName)]
    ]);

  init(): void {
    try {
      log.showInfo(`StatusBarSettingVm init event`);
      // 注册事件
      InnerEventUtil.on(OobeActivatedEvent, this.onOobeActiveEvent);
      InnerEventUtil.on(EnableSwitchEvent, this.onEnableSwitchEventChange);
      InnerEventUtil.on(NotificationIconEvent, this.onNotificationIconEvent);
      InnerEventUtil.on(OperatorClockChangeEvent, this.onOperatorClockChangeEvent);
      InnerEventUtil.on(SpecialIconEvent, this.specialIconEvent);
    } catch (e) {
      log.showError('register StatusBarSetting event error:', e);
    }
  };

  unInit(): void {
    InnerEventUtil.off(OobeActivatedEvent, this.onOobeActiveEvent);
    InnerEventUtil.off(EnableSwitchEvent, this.onEnableSwitchEventChange);
    InnerEventUtil.off(NotificationIconEvent, this.onNotificationIconEvent);
    InnerEventUtil.off(OperatorClockChangeEvent, this.onOperatorClockChangeEvent);
    InnerEventUtil.off(SpecialIconEvent, this.specialIconEvent);
  }

  private specialIconEvent = async (event: SpecialIconEvent): Promise<void> => {
    const isHide = this.specialHideIcon.has(event.pluginName);
    if (isHide !== event.isCanShowInLauncherStatusBar) {
      return;
    }
    if (event.isCanShowInLauncherStatusBar) {
      this.specialHideIcon.delete(event.pluginName);
    } else {
      this.specialHideIcon.add(event.pluginName);
    }
    log.showInfo(`specialIconEvent: ${event.pluginName} can show: ${event.isCanShowInLauncherStatusBar}`);
    this.vmInjector.getStatusBarLayoutVm().recalculateLayout(true);
  };

  private onOobeActiveEvent = async (event: OobeActivatedEvent): Promise<void> => {
    this.isOobe = (event.isActivated || (await OobeAdapter.isOobeActivated())) ?? false;
    log.showInfo(`onOobeActiveEvent: ${event.isActivated} isOobe: ${this.isOobe}`);
    this.vmInjector.getStatusBarLayoutVm().recalculateLayout(false);
  };

  private onNotificationIconEvent = (event: NotificationIconEvent): void => {
    log.showInfo(`onNotificationIconEvent ${event.shareValue}`)
    this.switchInfo.set(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON, event.shareValue);
    this.vmInjector.getStatusBarLayoutVm().recalculateLayout(false);
  }

  private onEnableSwitchEventChange = (event: EnableSwitchEvent): void => {
    log.showInfo(`onEnableSwitchEventChange ${event.subEventType} ${event.shareValue}`)
    this.switchInfo.set(event.subEventType, event.shareValue);
    setTimeout(()=>{
      this.vmInjector.getStatusBarLayoutVm().recalculateBaseLayout();
    }, 0);
  }

  private onOperatorClockChangeEvent = (event: OperatorClockChangeEvent): void => {
    log.showInfo(`onOperatorClockChangeEvent ${event.isShowClock}`)
    this.isShowClockInNC = event.isShowClock;
    this.vmInjector.getStatusBarLayoutVm().recalculateBaseLayout();
  }

  @Monitor('dropDownVm.isDropDown', 'dropDownVm.checkShowDropDownType')
  statusBarChange() {
    if (!this.dropDownVm.isDropDown) {
      this.isShowClockInNC = false;
    }
    this.vmInjector.getStatusBarLayoutVm().recalculateBaseLayout();
  }

  /**
   * 检查图标在当前过滤规则下是否在状态栏中显示
   * @param pluginName 检查的图标名称
   * @param checkFilterType 是否自定义过滤规则类型、UNDEFINED为使用当前过滤规则
   * @returns
   */
  isShouldShowInStatusBar(pluginName: string, checkFilterType: IconFilterType): boolean {
    if (checkFilterType === IconFilterType.UNDEFINED) {
      checkFilterType = this.iconFilterType;
    }
    // 实时网速使能开关直接控制其显隐
    if (pluginName === PluginSlot.SLOT_STATUS_NET_SPEED) {
      return this.checkEnableSwitchState(pluginName);
    }
    // 使能开关显隐控制，特殊开关可以临时关闭使能开关状态
    const enableSwitchState: boolean = this.checkEnableSwitchState(pluginName) && !this.specialHideIcon.has(pluginName);
    const filterRuleCheckFun = this.filterRuleCheckMap.get(checkFilterType);
    if (filterRuleCheckFun && !filterRuleCheckFun(enableSwitchState, pluginName)) {
      return false;
    }
    return this.isIconNeedOnTheTree(pluginName);
  }

  public setFilterType(filter: IconFilterType) {
    this.iconFilterType = filter;
  }

  /**
   * 提供必要条件可通过该方法可以获取图标过滤规则
   */
  public checkIconFilterRule(curStatusBarType: number): IconFilterType {
    let tempFilterType = IconFilterType.DEFAULT;
    // 注意条件判定顺序，一些场景的条件是共存的，优先级高的场景需要提前判定
    if (this.envVm.isPwdVisible) {
      tempFilterType = IconFilterType.KEYGUARD; // 密码界面强制按照锁屏状态显示
    } else if (this.isOobe && (StatusBarType.isKeyguard(curStatusBarType) || this.isLockInApp)) {
      tempFilterType = IconFilterType.OOBE_AND_KEYGUARD;
    } else if (this.isOobe) {
      tempFilterType = IconFilterType.OOBE;
    } else if (this.dropDownVm.checkShowDropDownType) {
      tempFilterType = IconFilterType.DROPDOWN;
    } else if (this.isLockInApp) {
      tempFilterType = IconFilterType.KEYGUARD_IN_APP;
    } else if (StatusBarType.isKeyguard(curStatusBarType)) {
      tempFilterType = IconFilterType.KEYGUARD;
    }
    log.showInfo(`checkIconFilterRule iconFilterType: ${tempFilterType}`)
    return tempFilterType;
  }

  /**
   * 计算图标的基础显隐
   */
  protected isIconNeedOnTheTree(pluginName: string): boolean {
    const iconVm: IStatusBarIconVm = this.vmInjector.getStatusBarIconVm(pluginName);
    if (!iconVm) {
      log.showInfo(`isIconNeedOnTheTree iconVm not null`);
      return true;
    }
    return iconVm.getIsOnTheTree();
  }

  protected checkEnableSwitchState(pluginName: PluginSlot): boolean {
    let checkResult: boolean = true;
    switch (pluginName) {
      case PluginSlot.SLOT_STATUS_NOTIFICATION:
        checkResult = this.switchInfo.get(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON) ?? true;
        break
      case PluginSlot.SLOT_STATUS_NET_SPEED:
        checkResult = this.switchInfo.get(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED) ?? false;
        break
      case PluginSlot.SLOT_STATUS_VPN:
        checkResult = this.switchInfo.get(SettingsKeyConstants.SHOW_VPN_ICON) ?? true;
        break
      case PluginSlot.SLOT_STATUS_RING:
        checkResult = this.switchInfo.get(SettingsKeyConstants.SHOW_RING_MODE_ICON) ?? true;
        break
      case PluginSlot.SLOT_STATUS_STAR_FLASH:
      case PluginSlot.SLOT_STATUS_BLE:
        checkResult = this.switchInfo.get(SettingsKeyConstants.SHOW_NEARLINK_ICON) ?? true;
        break
      case PluginSlot.SLOT_STATUS_ALARM_CLOCK:
        checkResult = this.switchInfo.get(SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON) ?? true;
        break
      case PluginSlot.SLOT_STATUS_NFC:
        checkResult = this.switchInfo.get(SettingsKeyConstants.SHOW_NFC_ICON) ?? false;
        break
      case PluginSlot.SLOT_STATUS_EARPHONE:
        checkResult = this.switchInfo.get(SettingsKeyConstants.SHOW_HEAD_PHONES_ICON) ?? false;
        break
    }
    return checkResult;
  }

  protected checkDefaultFilterRule(enableSwitchState: boolean, pluginName: string): boolean {
    if (this.isMiddleCutout && PluginSlot.LIVE_VIEW_CAPSULE === pluginName) {
      // 中挖孔场景状态栏内部的胶囊不显示
      return false;
    }
    if (!enableSwitchState) {
      return false;
    }
    if (PluginSlot.SLOT_STATUS_OPERATOR === pluginName) {
      // 不显示运营商名称
      return false;
    }
    return true;
  }

  protected checkDropdownFilterRule(enableSwitchState: boolean, pluginName: string): boolean {
    if (PluginSlot.LIVE_VIEW_CAPSULE === pluginName &&
      (this.isMiddleCutout || !this.vmInjector.getStatusBarLayoutVm().isInstantShowing) ) {
      // 中挖孔 或 非及时胶囊 在下拉时不显示
      return false;
    }
    if (this.isShowClockInNC) {
      if ([PluginSlot.SLOT_STATUS_OPERATOR, PluginSlot.SLOT_STATUS_NOTIFICATION].includes(pluginName)) {
        // 不显示运营商和通知
        return false;
      }
    } else {
      if ([PluginSlot.SLOT_STATUS_CLOCK, PluginSlot.SLOT_STATUS_NOTIFICATION].includes(pluginName)) {
        // 不显示时间和通知
        return false;
      }
    }
    return true;
  }

  protected checkKeyguardFilterRule(enableSwitchState: boolean, pluginName: string): boolean {
    if (!enableSwitchState) {
      return false;
    }
    // 锁屏不显示时间、运营商、通知和胶囊
    if ([PluginSlot.SLOT_STATUS_CLOCK, PluginSlot.SLOT_STATUS_OPERATOR, PluginSlot.SLOT_STATUS_NOTIFICATION,
      PluginSlot.LIVE_VIEW_CAPSULE].includes(pluginName)) {
      return false;
    }
    return true;
  }

  protected checkKeyguardInAppFilterRule(enableSwitchState: boolean, pluginName: string): boolean {
    if (!enableSwitchState) {
      return false;
    }
    // 锁屏应用内不显示运营商、通知
    if ([PluginSlot.SLOT_STATUS_OPERATOR, PluginSlot.SLOT_STATUS_NOTIFICATION].includes(pluginName)) {
      return false;
    }
    const isCapsule: boolean = PluginSlot.LIVE_VIEW_CAPSULE === pluginName;
    const isInstantShowing: boolean = this.vmInjector.getStatusBarLayoutVm().isInstantShowing;
    if (isCapsule && (!isInstantShowing || this.isMiddleCutout)) {
      return false
    }
    return true;
  }

  protected checkOobeFilterRule(enableSwitchState: boolean, pluginName: string): boolean {
    if (!enableSwitchState) {
      return false;
    }
    if (!ArrayUtils.contains(StatusBarSettingVm.OOBE_SLOT, pluginName)) {
      return false;
    }
    return true;
  }

  protected checkOobeAndKeyguardFilterRule(enableSwitchState: boolean, pluginName: string): boolean {
    let resultForKeyguard: boolean = false;
    if (this.isLockInApp) {
      resultForKeyguard = this.checkKeyguardInAppFilterRule(enableSwitchState, pluginName);
    } else {
      resultForKeyguard = this.checkKeyguardFilterRule(enableSwitchState, pluginName);
    }
    if (!resultForKeyguard) {
      return false;
    }

    return this.checkOobeFilterRule(enableSwitchState, pluginName);
  }

}