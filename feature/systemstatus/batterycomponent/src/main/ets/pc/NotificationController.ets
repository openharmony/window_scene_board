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

import { Log, LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus, GlobalContext, HiSysEventUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import notificationManager from '@ohos.notificationManager';
import image from '@ohos.multimedia.image';
import type context from '@ohos.app.ability.common';
import BatteryInfo from '@ohos.batteryInfo';
import batteryInfo from '@ohos.batteryInfo';
import CommonEventManager from '@ohos.commonEventManager';
import { ResUtils } from '@ohos/windowscene';
import mBatteryModel from '../default/batteryModel';
import Constants from '../default/common/constants';
// instrument ignore file

const TAG = 'NotificationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const LOW_BATTERY_NTF_VALUE = '10%';
const LOW_BATTERY_NTF_VALUE_2IN1 = '20%';
const LOW_BATTERY_NTF_ICON = 'lowBattery_light';

enum NtfType {
  PUBLISH_LOW_BATTERY_NTF = 'publishLowBatteryNtf',
  PUBLISH_2IN1_LOW_BATTERY_NTF = 'publish2in1LowBatteryNtf',
  PUBLISH_2IN1_VERY_LOW_BATTERY_NTF = 'publish2in1VeryLowBatteryNtf',
  PUBLISH_SHUTDOWN_NTF = 'publishShutdownNtf',
  CANCEL_LOW_BATTERY_NTF = 'cancelLowBatteryNtf',
  CANCEL_2IN1_LOW_BATTERY_NTF = 'cancel2in1LowBatteryNtf',
  CANCEL_2IN1_VERY_LOW_BATTERY_NTF = 'cancel2in1VeryLowBatteryNtf',
  CANCEL_SHUTDOWN_NTF = 'cancelShutdownNtf'
};

// 发送打开休眠弹窗广播事件
export class PublishHibernateEvent {
  public static readonly eventTypeName = 'PublishHibernateEvent';
  // true打开 false关闭
  public state: boolean = false;
}

export default class NotificationController {
  private hasLowBatteryNtf: boolean = false;
  private hasShutdownNtf: boolean = false;
  private has2in1LowBatteryNtf: boolean = false;
  private has2in1VeryLowBatteryNtf: boolean = false;
  private shouldPublishHibernateNtf: boolean = true;
  private smallIcon?: image.PixelMap = undefined;  // 低电量图标
  private context: context.Context = GlobalContext.getContext() as context.Context;
  private static instance?: NotificationController = undefined;
  private publishHibernateEvent: PublishHibernateEvent = new PublishHibernateEvent;

  private constructor() {
  };

  /**
   * Get the instance of the NotificationController class
   */
  static getInstance(): NotificationController {
    if (!NotificationController.instance) {
      NotificationController.instance = new NotificationController();
    };
    return NotificationController.instance;
  };

  private getNtfTitle(type: string): string {
    if (type === NtfType.PUBLISH_SHUTDOWN_NTF) {
      return ResUtils.getInnerStringByName('shutdown_ntf_title');
    } else {
      return ResUtils.getInnerStringByName('low_battery_notification_title');
    }
  }

  private getNtfText(type: string): string {
    let ntfText: string = '';
    switch (type) {
      case NtfType.PUBLISH_LOW_BATTERY_NTF:
      case NtfType.PUBLISH_2IN1_VERY_LOW_BATTERY_NTF:
        ntfText = ResUtils.getInnerStringByName('low_battery_notification_content');
        return ntfText.replace('%s', LOW_BATTERY_NTF_VALUE);
        break;
      case NtfType.PUBLISH_2IN1_LOW_BATTERY_NTF:
        ntfText = ResUtils.getInnerStringByName('low_battery_notification_content');
        return ntfText.replace('%s', LOW_BATTERY_NTF_VALUE_2IN1);
        break;
      case NtfType.PUBLISH_SHUTDOWN_NTF:
        return ResUtils.getInnerStringByName('shutdown_ntf_text');
        break;
      default:
        return ntfText;
        break;
    }
  }

  private getNtfId(type: string): number {
    switch (type) {
      case NtfType.PUBLISH_LOW_BATTERY_NTF:
      case NtfType.CANCEL_LOW_BATTERY_NTF:
        return Constants.PC_LOW_BATTERY_NTF_ID;
        break;
      case NtfType.PUBLISH_2IN1_VERY_LOW_BATTERY_NTF:
      case NtfType.CANCEL_2IN1_VERY_LOW_BATTERY_NTF:
        return Constants.VERY_LOW_BATTERY_NTF_ID_2IN1;
        break;
      case NtfType.PUBLISH_2IN1_LOW_BATTERY_NTF:
      case NtfType.CANCEL_2IN1_LOW_BATTERY_NTF:
        return Constants.LOW_BATTERY_NTF_ID_2IN1;
        break;
      case NtfType.PUBLISH_SHUTDOWN_NTF:
      case NtfType.CANCEL_SHUTDOWN_NTF:
        return Constants.PC_SHUTDOWN_NTF_ID;
        break;
      default:
        return Constants.LOW_BATTERY_ERROR_ID;
        break;
    }
  }

  private afterAction(type: string): void {
    switch (type) {
      case NtfType.PUBLISH_LOW_BATTERY_NTF:
        this.hasLowBatteryNtf = true;
        break;
      case NtfType.PUBLISH_2IN1_VERY_LOW_BATTERY_NTF:
        this.has2in1VeryLowBatteryNtf = true;
        break;
      case NtfType.PUBLISH_2IN1_LOW_BATTERY_NTF:
        this.has2in1LowBatteryNtf = true;
        break;
      case NtfType.PUBLISH_SHUTDOWN_NTF:
        this.hasShutdownNtf = true;
        break;
      case NtfType.CANCEL_LOW_BATTERY_NTF:
        this.hasLowBatteryNtf = false;
        break;
      case NtfType.CANCEL_2IN1_VERY_LOW_BATTERY_NTF:
        this.has2in1VeryLowBatteryNtf = false;
        break;
      case NtfType.CANCEL_2IN1_LOW_BATTERY_NTF:
        this.has2in1LowBatteryNtf = false;
        break;
      case NtfType.CANCEL_SHUTDOWN_NTF:
        this.hasShutdownNtf = false;
        break;
      default:
        break;
    }
  }

  /**
   * 发布通知
   */
  private publishNtf: (type: string) => Promise<void> = async (type: string) => {
    log.showInfo(`${type} start`);
    if (type === NtfType.PUBLISH_SHUTDOWN_NTF) {
      HiSysEventUtil.reportShutDownNotification();
    }
    try {
      let ntfTitle = this.getNtfTitle(type);
      let ntfText = this.getNtfText(type);
      let ntfRequest: notificationManager.NotificationRequest = {
        notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
        id: this.getNtfId(type),
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: ntfTitle,
            text: ntfText
          }
        },
        smallIcon: this.smallIcon
      };
      await notificationManager.publish(ntfRequest);
    } catch (err) {
      log.error(`${type} err. ${err?.code} ${err?.message}`);
      return;
    }
    log.showInfo(`${type} success`);
    this.afterAction(type);
  }

  /**
   * 删除通知
   */
  private cancelNtf: (type: string) => Promise<void> = async (type: string) => {
    log.showInfo(`${type} start`);
    try {
      await notificationManager.cancel(this.getNtfId(type));
    } catch (err) {
      log.error(`${type} failed. ${err?.code} ${err?.message}`);
      return;
    }
    log.showInfo(`${type} success`);
    this.afterAction(type);
  };

  /**
   * PC切换语言更新弹窗内容
   */
  public checkLanguageChange(): void {
    if (this.hasLowBatteryNtf) {
      this.publishNtf(NtfType.PUBLISH_LOW_BATTERY_NTF);
    }
    if (this.has2in1LowBatteryNtf) {
      this.publishNtf(NtfType.PUBLISH_2IN1_LOW_BATTERY_NTF);
    }
    if (this.has2in1VeryLowBatteryNtf) {
      this.publishNtf(NtfType.PUBLISH_2IN1_VERY_LOW_BATTERY_NTF);
    }
    if (this.hasShutdownNtf) {
      this.publishNtf(NtfType.PUBLISH_SHUTDOWN_NTF);
    }
  }

  /**
   * 通知打开低电量休眠弹窗
   */
  private publishHibernateNtf: () => void = () => {
    log.showInfo('publishHibernateNtf start');
    this.publishHibernateEvent.state = true;
    try {
      EvtBus.post(PublishHibernateEvent, this.publishHibernateEvent);
    } catch (err) {
      log.error(`publishHibernateNtf failed. ${err?.code} ${err?.message}`);
      return;
    }
    this.shouldPublishHibernateNtf = false;
  };

  /**
   * 重置打开低电量休眠弹窗flag
   */
  private setHibernateNtfFlag: () => void = () => {
    log.showInfo('setHibernateNtfFlag start');
    this.shouldPublishHibernateNtf = true;
  };

  /**
   * PC独有低电通知
   */
  private checkPcLowBatteryNtf: (oldBatteryCapacityLevel: BatteryInfo.BatteryCapacityLevel) => void =
    (oldBatteryCapacityLevel: BatteryInfo.BatteryCapacityLevel) => {
      log.showInfo('checkPcLowBatteryNtf start');
      const curCapacityLevel: number = batteryInfo.batteryCapacityLevel;
      const isCharging: boolean = (batteryInfo.chargingStatus === BatteryInfo.BatteryChargeState.ENABLE) ||
        (batteryInfo.chargingStatus === BatteryInfo.BatteryChargeState.FULL);

      // 10%低电提醒
      const isPublishLowBatteryNtf: boolean =
        (oldBatteryCapacityLevel < BatteryInfo.BatteryCapacityLevel.LEVEL_WARNING) &&
          (curCapacityLevel === BatteryInfo.BatteryCapacityLevel.LEVEL_WARNING) && (!this.hasLowBatteryNtf);
      if (isPublishLowBatteryNtf) {
        log.showInfo('checkPcLowBatteryNtf publish lowBatteryNtf');
        this.publishNtf(NtfType.PUBLISH_LOW_BATTERY_NTF);
      }

      // 消除10%低电提醒
      const isCancelLowBatteryNtf: boolean =
        (isCharging || curCapacityLevel < BatteryInfo.BatteryCapacityLevel.LEVEL_WARNING) && this.hasLowBatteryNtf;
      if (isCancelLowBatteryNtf) {
        log.showInfo('checkPcLowBatteryNtf cancel lowBatteryNtf');
        this.cancelNtf(NtfType.CANCEL_LOW_BATTERY_NTF);
      }

      // 发送5%低电休眠弹窗通知
      const isPublishHibernateNtf: boolean =
        (oldBatteryCapacityLevel < BatteryInfo.BatteryCapacityLevel.LEVEL_CRITICAL) &&
          (curCapacityLevel === BatteryInfo.BatteryCapacityLevel.LEVEL_CRITICAL) && this.shouldPublishHibernateNtf;
      if (isPublishHibernateNtf) {
        log.showInfo('checkPcLowBatteryNtf publish hibernateNtf');
        this.publishHibernateNtf();
      }

      // 重置5%低电休眠弹窗通知
      const isSetHibernateNtfFlag: boolean =
        (curCapacityLevel !== BatteryInfo.BatteryCapacityLevel.LEVEL_CRITICAL) && (!this.shouldPublishHibernateNtf);
      if (isSetHibernateNtfFlag) {
        log.showInfo('checkPcLowBatteryNtf setHibernateNtfFlag');
        this.setHibernateNtfFlag();
      }
    }

  /**
   * PC通用低电通知
   */
  private checkPcNormalLowBatteryNtf: (batterySoc: number, oldBatterySoc: number) => void =
    (batterySoc: number, oldBatterySoc: number) => {
      log.showInfo('checkPcNormalLowBatteryNtf start');
      const curCapacityLevel: number = batteryInfo.batteryCapacityLevel;
      const downOrUp: boolean = batterySoc - oldBatterySoc < 0;
      const isCharging: boolean = batteryInfo.chargingStatus === BatteryInfo.BatteryChargeState.ENABLE ||
        batteryInfo.chargingStatus === BatteryInfo.BatteryChargeState.FULL;

      // 1%低电关机通知
      const isPublishShutdownNtf: boolean =
        downOrUp && (curCapacityLevel === BatteryInfo.BatteryCapacityLevel.LEVEL_SHUTDOWN) && (!this.hasShutdownNtf);
      if (isPublishShutdownNtf) {
        log.showInfo('checkPcNormalLowBatteryNtf publish shutdownNtf');
        this.publishNtf(NtfType.PUBLISH_SHUTDOWN_NTF);
      }

      // 消除1%低电关机通知
      const isCancelShutdownNtf: boolean =
        (isCharging || curCapacityLevel < BatteryInfo.BatteryCapacityLevel.LEVEL_SHUTDOWN) && this.hasShutdownNtf;
      if (isCancelShutdownNtf) {
        log.showInfo('checkPcNormalLowBatteryNtf cancel shutdownNtf');
        this.cancelNtf(NtfType.CANCEL_SHUTDOWN_NTF);
      }
    }

  /**
   * 2in1PC模式低电通知
   */
  private check2in1LowBatteryNtf: (batterySoc: number, oldBatterySoc: number) => void =
    (batterySoc: number, oldBatterySoc: number) => {
      log.showInfo('check2in1LowBatteryNtf start');
      const isCharging: boolean = batteryInfo.chargingStatus === BatteryInfo.BatteryChargeState.ENABLE ||
        batteryInfo.chargingStatus === BatteryInfo.BatteryChargeState.FULL;

      // 20%低电提醒
      const isPublish2in1LowBatteryNtf: boolean =
        (oldBatterySoc > Constants.BATTERY_LEVEL_LOW) && (batterySoc <= Constants.BATTERY_LEVEL_LOW) &&
          (!this.has2in1LowBatteryNtf);
      if (isPublish2in1LowBatteryNtf) {
        log.showInfo('check2in1LowBatteryNtf publish 2in1LowBatteryNtf');
        this.publishNtf(NtfType.PUBLISH_2IN1_LOW_BATTERY_NTF);
      }

      // 消除20%低电提醒
      const isCancel2in1LowBatteryNtf: boolean =
        (isCharging || batterySoc > Constants.BATTERY_LEVEL_LOW) && this.has2in1LowBatteryNtf;
      if (isCancel2in1LowBatteryNtf) {
        log.showInfo('check2in1LowBatteryNtf cancel 2in1LowBatteryNtf');
        this.cancelNtf(NtfType.CANCEL_2IN1_LOW_BATTERY_NTF);
      }

      // 10%低电提醒
      const isPublish2in1VeryLowBatteryNtf: boolean =
        (oldBatterySoc > Constants.BATTERY_LEVEL_VERY_LOW) && (batterySoc <= Constants.BATTERY_LEVEL_VERY_LOW) &&
          (!this.has2in1VeryLowBatteryNtf);
      if (isPublish2in1VeryLowBatteryNtf) {
        log.showInfo('check2in1LowBatteryNtf publish 2in1VeryLowBatteryNtf');
        this.publishNtf(NtfType.PUBLISH_2IN1_VERY_LOW_BATTERY_NTF);
      }

      // 消除10%低电提醒
      const isCancel2in1VeryLowBatteryNtf: boolean =
        (isCharging || batterySoc > Constants.BATTERY_LEVEL_VERY_LOW) && this.has2in1VeryLowBatteryNtf;
      if (isCancel2in1VeryLowBatteryNtf) {
        log.showInfo('check2in1LowBatteryNtf cancel 2in1VeryLowBatteryNtf');
        this.cancelNtf(NtfType.CANCEL_2IN1_VERY_LOW_BATTERY_NTF);
      }
    }

  /**
   * PC低电通知
   */
  private checkPcLowBattery: (batterySoc: number, oldBatterySoc: number,
    oldBatteryCapacityLevel: BatteryInfo.BatteryCapacityLevel) => void =
    (batterySoc: number, oldBatterySoc: number, oldBatteryCapacityLevel: BatteryInfo.BatteryCapacityLevel) => {
      log.showInfo(`checkPcLowBattery ${batterySoc}, ${oldBatterySoc}`);
      if (DeviceHelper.isPcNot2in1Device()) {
        this.checkPcLowBatteryNtf(oldBatteryCapacityLevel);
      }
      this.checkPcNormalLowBatteryNtf(batterySoc, oldBatterySoc);
      if (DeviceHelper.is2In1DevicePcType()) {
        this.check2in1LowBatteryNtf(batterySoc, oldBatterySoc);
      }
    }

  init(): void {
    log.showInfo('init');
    mBatteryModel.registerCheckPcLowBatteryCallBack(this.checkPcLowBattery);
    this.setSmallIcon();
  };

  unInit(): void {
    log.showInfo('unInit');
    mBatteryModel.unregisterCheckPcLowBatteryCallBack();
    this.smallIcon?.release((err) => {
      if (err) {
        log.error(`unInit smallIcon release failed. ${err?.code} ${err?.message}`);
      };
    });
  };

  /**
   * 设置低电量图标
   */
  setSmallIcon(): void {
    log.showInfo('setSmallIcon start');
    try {
      let resourceManager = this.context.resourceManager;
      let array = resourceManager.getMediaByNameSync(LOW_BATTERY_NTF_ICON);
      let res: image.ImageSource = image.createImageSource(array.buffer);
      if (!res) {
        log.showError('setSmallIcon failed. no resourceManager');
        return;
      };
      res.createPixelMap().then((pixelMap) => {
        if (pixelMap) {
          this.smallIcon = pixelMap;
          log.showInfo('setSmallIcon success');
        };
      }).finally(() => {
        res.release((err) => {
          log.error(`setSmallIcon release error result ${err?.code} ${err?.message}`);
        });
      });
    } catch (err) {
      log.error(`setSmallIcon failed. ${err?.code} ${err?.message}`);
    };
  };
}