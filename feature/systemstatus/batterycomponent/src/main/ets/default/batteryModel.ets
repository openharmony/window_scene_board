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

import {
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  EvtBus,
  sSettingsUtil,
  ConfigurationEvent,
  EventManager,
  PluginSlot
} from '@ohos/frameworkwrapper';
import BatteryInfo from '@ohos.batteryInfo';
import charger from '@ohos.charger';
import commonEventManager from '@ohos.commonEventManager';
import { BatterySocEvent } from '@ohos/systemuicommon';
import { ShowBatteryDialogEvent } from '@ohos/systemuicommon/src/main/ets/event/ShowBatteryDialogEvent';
import power from '@ohos.power';
import batteryInfo from '@ohos.batteryInfo';
import Constants from './common/constants';
import { CommonEventData } from 'commonEvent/commonEventData';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import PhoneNotificationController from '../phone/PhoneNotificationController';
import StyleConfiguration, { BatteryComponentStyle } from './common/StyleConfiguration';
import lazy NotificationController from '../pc/NotificationController';
import { PluginWidthChangeEvent } from '@ohos/systemuicommon/Index';
import { LogWithHa } from '@ohos/systemuicommon';

const TAG = 'BatteryComponent-batteryModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const CHARGING_ENABLE: number = 1;

enum ChargeTypeEnum {
  CHARGE_TYPE_NONE = '0',
  CHARGE_TYPE_WIRED_NORMAL = '1',
  CHARGE_TYPE_WIRED_QUICK = '2',
  CHARGE_TYPE_WIRED_SUPER_QUICK = '3',
  CHARGE_TYPE_WIRELESS_NORMAL = '4',
  CHARGE_TYPE_WIRELESS_QUICK = '5',
  CHARGE_TYPE_WIRELESS_SUPER_QUICK = '6'
}

const BATTERY_CONFIG_SCENENAME = 'charger_type';

const DEFAULT_PROGRESS = 100;
const SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED,
    commonEventManager.Support.COMMON_EVENT_CHARGE_TYPE_CHANGED,
    commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED
  ]
};

interface ComponentCallback {
  onBatterySoc(isEnable: boolean): void
}

// 发送是否充电切换广播事件
export class BatteryChargingEvent {

  public static readonly eventTypeName = 'BatteryChargingEvent';
  // true充电中 false未充电
  public charging: boolean = false;
}

// 电池电量百分比VM
export class BatterySocVm {
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private callback?: ComponentCallback;

  init(callback: ComponentCallback): void {
    this.callback = callback;
    this.eventMgr.on(BatterySocEvent, this.onBatterySocEvent.bind(this));
  }

  destroy(): void {
    this.eventMgr.offAll();
    this.callback = undefined;
  }

  private onBatterySocEvent(event: BatterySocEvent): void {
    const isEnable: boolean = event.isBatterySocEnable();
    log.showInfo(`onBatterySocEvent isEnable: ${isEnable} ${typeof isEnable}`);

    if (this.callback) {
      this.callback.onBatterySoc(isEnable);
    }
  }
}

export class BatteryModel {
  private mBatterySoc?: AbstractProperty<number>;
  private mBatteryCapacityLevel?: AbstractProperty<BatteryInfo.BatteryCapacityLevel>;
  private mBatteryCharging?: AbstractProperty<boolean>;
  private mPluggedType?: AbstractProperty<BatteryInfo.BatteryPluggedType>;
  private mChargerType?: AbstractProperty<charger.ChargeType>;
  private mSubscriber?: CommonEventSubscriber | null;
  private mIsReleased: boolean = true;
  private batteryChargingEvent: BatteryChargingEvent = new BatteryChargingEvent;
  private mPowerSaveMode?: AbstractProperty<number>;
  private mShowBatterySoc: boolean = false;
  private style: BatteryComponentStyle = StyleConfiguration.getBatteryComponentStyle();
  private pluginWidthChangeEvent: PluginWidthChangeEvent = PluginWidthChangeEvent.create(PluginSlot.SLOT_STATUS_BATTERY,
    this.style.statusBarBatteryWidth as number);

  /**
   * PC低电通知回调函数
   */
  private checkPcLowBattery?: (batterySoc: number, oldBatterySoc: number,
    oldBatteryCapacityLevel: BatteryInfo.BatteryCapacityLevel) => void;

  private eventMgr: EventManager = EvtBus.createEventManager();
  private language: string | undefined = undefined;
  private initEventMgr(): void {
    this.eventMgr.on(ConfigurationEvent, this.onConfigurationEvent)
      .on(BatterySocEvent, this.onBatterySocEvent);
  }

  private onBatterySocEvent = (event: BatterySocEvent): void => {
    this.mShowBatterySoc = event.isBatterySocEnable();
    this.updatePluginWidthChangeEvent();
  };

  /**
   * 切换语言更新弹窗内容
   */
  private onConfigurationEvent = (event: ConfigurationEvent): void => {
    try {
      log.showInfo(`onConfigurationEvent, config.language: ${event.config?.language}, ${this.language}`);
      if (this.language === event.config?.language) {
        return;
      }
      this.language = event.config?.language;
      const hasNotification = PhoneNotificationController.getInstance().hasNotification();
      if (hasNotification) {
        const batterySoc = BatteryInfo.batterySOC ?? DEFAULT_PROGRESS;
        log.showInfo(`onConfigurationEvent publishNotification batterySoc: ${batterySoc}`);
        PhoneNotificationController.getInstance().publishNotification(batterySoc, true);
      }
    } catch (error) {
      log.error('onConfigurationEvent error', error);
    }
  };

  async initBatteryModel(): Promise<void> {
    if (!this.mIsReleased) {
      log.showInfo('already init');
      return;
    }
    log.showInfo('initBatteryModel start');
    this.mIsReleased = false;
    this.style.initStyle();
    this.mBatterySoc = AppStorage.setAndRef('batterySoc', 0);
    this.mBatteryCapacityLevel =
      AppStorage.setAndRef('batteryCapacityLevel', BatteryInfo.BatteryCapacityLevel.LEVEL_FULL);
    this.mBatteryCharging = AppStorage.setAndRef('batteryCharging', false);
    this.mChargerType = AppStorage.setAndRef('chargerType', charger.ChargeType.NONE);
    this.mPluggedType = AppStorage.setAndRef('batteryPluggedType', 0);
    this.mPowerSaveMode = AppStorage.setAndRef('powerSaveMode', Constants.POWER_SAVE_MODE_OFF);
    // 开关机,切换用户场景下,基于settingsdata数据矫正电池模式参数
    this.mPowerSaveMode?.set(Number.parseInt(sSettingsUtil.getValue(Constants.POWER_MODE_STATUS_KET)));
    this.setBatteryStatus();

    try {
      const subscriber: CommonEventSubscriber = await commonEventManager.createSubscriber(SUBSCRIBE_INFO);
      log.showInfo('init createSubscriber end');
      if (this.mIsReleased) {
        log.showInfo('init createSubscriber but model released');
        return;
      }
      this.mSubscriber = subscriber;
      commonEventManager.subscribe(subscriber, (err, data) => {
        log.showInfo('initBatteryModel start');
        if (err && err.code !== 0) {
          log.showError(`Can't handle common event, err: ${err.message}`);
          return;
        }
        this.updateBatteryStatus(data);
      });
      this.setBatteryStatus();
      log.showInfo('setBatteryStatus in initBatteryModel');
    } catch (error) {
      log.error('commonEventManager error', error);
    }

    this.getBatteryConfig(); // 获取电池配置

    if (!DeviceHelper.isPC()) {
      PhoneNotificationController.getInstance().init();
    }
    this.initEventMgr();
  }

  unInitBatteryModel(): void {
    log.showDebug('unInitBatteryModel');
    this.mIsReleased = true;
    if (this.mSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      } catch (error) {
        log.error('commonEventManager unsubscribe error', error);
      }
    }
    if (!DeviceHelper.isPC()) {
      PhoneNotificationController.getInstance().unInit();
    }
    this.eventMgr.offAll();
  }

  getBatteryConfig(): void {
    let result: string = '';
    try {
      result = BatteryInfo.getBatteryConfig(BATTERY_CONFIG_SCENENAME);
      log.showInfo('batteryInfo.getBatteryConfig ' + result);
      if (!result) {
        return;
      }
    } catch (error) {
      log.error('getBatteryConfig error', error);
      return;
    }
    let chargerType: charger.ChargeType = charger.ChargeType.NONE;
    switch (result) {
      case ChargeTypeEnum.CHARGE_TYPE_NONE:
        chargerType = charger.ChargeType.NONE;
        break;
      case ChargeTypeEnum.CHARGE_TYPE_WIRED_NORMAL:
        chargerType = charger.ChargeType.WIRED_NORMAL;
        break;
      case ChargeTypeEnum.CHARGE_TYPE_WIRED_QUICK:
        chargerType = charger.ChargeType.WIRED_QUICK;
        break;
      case ChargeTypeEnum.CHARGE_TYPE_WIRED_SUPER_QUICK:
        chargerType = charger.ChargeType.WIRED_SUPER_QUICK;
        break;
      case ChargeTypeEnum.CHARGE_TYPE_WIRELESS_NORMAL:
        chargerType = charger.ChargeType.WIRELESS_NORMAL;
        break;
      case ChargeTypeEnum.CHARGE_TYPE_WIRELESS_QUICK:
        chargerType = charger.ChargeType.WIRELESS_QUICK;
        break;
      case ChargeTypeEnum.CHARGE_TYPE_WIRELESS_SUPER_QUICK:
        chargerType = charger.ChargeType.WIRELESS_SUPER_QUICK;
        break;
      default:
        chargerType = charger.ChargeType.NONE;
        break;
    }
    this.mChargerType?.set(chargerType);
  }

  /**
   * 注册PC低电通知回调函数
   *
   * @param checkPcLowBattery PC低电通知回调函数
   */
  registerCheckPcLowBatteryCallBack(checkPcLowBattery: (batterySoc: number, oldBatterySoc: number,
    oldBatteryCapacityLevel: BatteryInfo.BatteryCapacityLevel) => void): void {
    this.checkPcLowBattery = checkPcLowBattery;
  }

  /**
   * 反注册PC低电通知回调函数
   */
  unregisterCheckPcLowBatteryCallBack(): void {
    this.checkPcLowBattery = undefined;
  }

  /**
   * Get battery status and remaining power
   */
  private updateBatteryStatus(data: CommonEventData): void {
    if (data && data.event === commonEventManager.Support.COMMON_EVENT_CHARGE_TYPE_CHANGED) {
      this.mChargerType?.set(data.code);
      log.showInfo(`charger type changed to ${this.mChargerType?.get()}`);
      return;
    }
    if (data && data.event === commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED) {
      this.mPowerSaveMode?.set(data.code);
      this.updatePluginWidthChangeEvent();
      return;
    }
    this.setBatteryStatus();
  }

  private setBatteryStatus(): void {
    let oldBatterySoc = this.mBatterySoc?.get() ?? DEFAULT_PROGRESS;
    let batterySoc = BatteryInfo.batterySOC ?? DEFAULT_PROGRESS;
    let batteryCharging = BatteryInfo.chargingStatus;
    let oldBatteryCapacityLevel = this.mBatteryCapacityLevel?.get() ?? BatteryInfo.BatteryCapacityLevel.LEVEL_FULL;
    let batteryCapacityLevel = batteryInfo.batteryCapacityLevel ?? BatteryInfo.BatteryCapacityLevel.LEVEL_FULL;
    if (batterySoc <= 0) {
      // If the result is a negative number, set it as positive number.
      batterySoc = Math.abs(batterySoc) * Constants.PERCENT_NUMBER;
    }
    if (oldBatterySoc !== batterySoc) {
      LogWithHa.warn(log, `batterySoc refresh ${batterySoc}`);
    }
    // Set the battery status as charging when there is no battery hardware
    this.mBatterySoc?.set(batterySoc);
    this.mBatteryCapacityLevel?.set(batteryCapacityLevel);
    this.mPluggedType?.set(BatteryInfo.pluggedType);

    // 优化this.mBatteryCharging.set，减少广播到组件的无效次数
    const chargingStatus = DeviceHelper.isPC() ? this.getPcChargingStatus(batteryCharging)
      : this.getChargingStatus(batteryCharging);
    if (chargingStatus !== this.mBatteryCharging?.get()) {
      this.mBatteryCharging?.set(chargingStatus);
      this.updatePluginWidthChangeEvent();
      this.batteryChargingEvent.charging = chargingStatus;
      EvtBus.post(BatteryChargingEvent, this.batteryChargingEvent);
    }

    // 检测低电量弹框提醒
    this.checkShowOrHideDialog();
    // 检测PC低电量通知&重启后oldBatterySoc获取不到导致默认100%电量
    if (this.checkPcLowBattery && oldBatterySoc !== DEFAULT_PROGRESS &&
      oldBatteryCapacityLevel !== BatteryInfo.BatteryCapacityLevel.LEVEL_FULL) {
      this.checkPcLowBattery(batterySoc, oldBatterySoc, oldBatteryCapacityLevel);
    }
    this.checkPhoneLowBatteryNtf(batterySoc, oldBatterySoc);
  }

  private updatePluginWidthChangeEvent(): void {
    let iconWidth = this.style.statusBarBatteryWidth as number;
    if (this.mShowBatterySoc) {
      if (this.mBatteryCharging?.get()) {
        iconWidth += (this.style.statusBarBatteryChargingWidth as number);
      } else if (this.mPowerSaveMode && this.mPowerSaveMode?.get() === Constants.POWER_SAVE_MODE_ON) {
        iconWidth += (this.style.statusBarPowerSaveWidth as number);
      }
    }
    this.pluginWidthChangeEvent.setWidth(iconWidth);
    if (this.pluginWidthChangeEvent.getChangeDelta() > 0 &&
      this.pluginWidthChangeEvent.getChangeDelta() < this.style.statusBarBatteryWidth) {
      EvtBus.post(PluginWidthChangeEvent, this.pluginWidthChangeEvent);
    }
  }

  private async checkPhoneLowBatteryNtf(batterySoc: number, oldBatterySoc: number): Promise<void> {
    log.showInfo(`checkPhoneLowBatteryNtf: ${batterySoc}, ${oldBatterySoc}, ${this.batteryChargingEvent.charging}`);
    try {
      const powerMode = this.getPowerMode();
      const isCancelNotification = this.batteryChargingEvent.charging || batterySoc > Constants.BATTERY_LEVEL_LOW ||
        power.DevicePowerMode.MODE_POWER_SAVE === powerMode;
      if (isCancelNotification) {
        // 关闭通知
        await PhoneNotificationController.getInstance().cancelNotification();
        return;
      }

      const isBatteryDown: boolean = batterySoc - oldBatterySoc < 0;
      // 电量降至 20% 或 10% 需重新发送通知，电量变化则更新剩余电量显示
      const isRePublishNtf: boolean = isBatteryDown &&
        (batterySoc === Constants.BATTERY_LEVEL_LOW || batterySoc === Constants.BATTERY_LEVEL_VERY_LOW);
      // 低电量通知手动删除后，不再发送通知
      const hasNotification = PhoneNotificationController.getInstance().hasNotification();
      if (hasNotification || isRePublishNtf) {
        log.showInfo(`checkPhoneLowBatteryNtf publishNotification: ${hasNotification}, ${isRePublishNtf}`);
        await PhoneNotificationController.getInstance().publishNotification(batterySoc, !isRePublishNtf);
      }
    } catch (err) {
      log.error(`checkPhoneLowBatteryNtf request failed. ${err?.message}`);
    };
  }

  private getPowerMode(): power.DevicePowerMode {
    let curPowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
    try {
      curPowerMode = power.getPowerMode();
    } catch (err) {
      log.showError(`Get device power mode failed , err: ${err.code}, errMessage: ${err.message}`);
    }
    return curPowerMode;
  }

  private getChargingStatus(state: BatteryInfo.BatteryChargeState): boolean {
    let batteryStatus = false;
    switch (state) {
      case BatteryInfo.BatteryChargeState.ENABLE:
      case BatteryInfo.BatteryChargeState.FULL:
        batteryStatus = true;
        break;
      case BatteryInfo.BatteryChargeState.DISABLE:
        batteryStatus = false;
        break;
      default:
        batteryStatus = false;
        break;
    }
    return batteryStatus;
  }

  private getPcChargingStatus(state: BatteryInfo.BatteryChargeState): boolean {
    let batteryStatus = false;
    switch (state) {
      case BatteryInfo.BatteryChargeState.ENABLE:
      case BatteryInfo.BatteryChargeState.FULL:
      case BatteryInfo.BatteryChargeState.DISABLE:
        batteryStatus = true;
        break;
      default:
        batteryStatus = false;
        break;
    }
    return batteryStatus;
  }

  /**
   * 检测低电量关机提醒弹框显示/隐藏
   */
  private checkShowOrHideDialog(): void {
    // 当前电量
    let batterySoc = this.mBatterySoc?.get() ?? DEFAULT_PROGRESS;
    // 当前是否正在充电
    let isCharging = this.batteryChargingEvent.charging ?? false;
    EvtBus.post(ShowBatteryDialogEvent, new ShowBatteryDialogEvent(isCharging, batterySoc));
  }
}

let mBatteryModel = SingletonHelper.getInstance(BatteryModel, TAG);

export default mBatteryModel as BatteryModel;