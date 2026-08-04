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
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import notificationManager from '@ohos.notificationManager';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import Constants from '../default/common/constants';
import type context from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';
import bundleManager from '@ohos.bundle.bundleManager';
import type { BusinessError } from '@ohos.base';
import { TaskItem, TaskQueue, crossModuleCallUtil } from '@ohos/systemuicommon';
import common from '@ohos.app.ability.common';
import { OutdoorVm } from '@ohos/systemuicommon/src/main/ets/vm/OutdoorVm';

// instrument ignore file
const TAG = 'PhoneNotificationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export default class PhoneNotificationController {

  /**
   * 发布消息通知的任务队列
   */
  private publishNotificationQueue: TaskQueue = new TaskQueue('PhoneNotificationController', 5);

  /**
   * 低电量图标
   */
  private smallIcon?: image.PixelMap;

  private static instance?: PhoneNotificationController = undefined;

  private constructor() {
  };

  /**
   * Get the instance of the NotificationController class
   */
  static getInstance(): PhoneNotificationController {
    if (!PhoneNotificationController.instance) {
      PhoneNotificationController.instance = new PhoneNotificationController();
    }
    return PhoneNotificationController.instance;
  }

  /**
   * 发布低电量通知
   */
  private async publishLowBatteryNtf(batterySoc: number, isAlertOnce: boolean = false): Promise<void> {
    log.showInfo(`publishLowBatteryNtf start`);
    try {
      const context: context.Context = GlobalContext.getContext() as context.Context;
      const ntfTitle = context.resourceManager.getStringByNameSync('low_battery_ntf_title');
      const ntfText = context.resourceManager.getStringByNameSync('low_battery_ntf_content', `${batterySoc}%`);
      const actionButtons: notificationManager.NotificationActionButton[] = [];
      // 云端模式下不需要按钮
      if (!OutdoorVm.instance.isInOutdoorMode) {
        const ntfBtnText = context.resourceManager.getStringByNameSync('low_battery_ntf_btn_text');
        const agent = await this.getWantAgent();
        actionButtons.push({
          title: ntfBtnText,
          wantAgent: agent,
        });
      }

      let array = context.resourceManager.getMediaByNameSync(Constants.LOW_BATTERY_NTF_ICON);
      let res: image.ImageSource = image.createImageSource(array.buffer);
      let smallIcon: image.PixelMap = await res.createPixelMap()
      const lowBatteryNtfRequest: notificationManager.NotificationRequest = {
        notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
        id: Constants.LOW_BATTERY_NTF_ID,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: ntfTitle,
            text: ntfText
          }
        },
        actionButtons,
        smallIcon: smallIcon,
        isAlertOnce,
        extraInfo: {
          hw_custom_appname: ntfTitle
        }
      };
      await notificationManager.publish(lowBatteryNtfRequest);
      log.showInfo(`publishLowBatteryNtf success ${Constants.LOW_BATTERY_NTF_ID}`);
    } catch (err) {
      log.showError(`publishLowBatteryNtf failed: ${err}`);
    };
  };

  init(): void {
    log.showInfo('init');
    this.setSmallIcon();
  }

  unInit(): void {
    log.showInfo('unInit');
    this.smallIcon?.release((err) => {
      if (err) {
        log.showError(`unInit smallIcon release failed: ${err}`);
      }
    });
  }

  /**
   * 发送通知
   */
  public async publishNotification(batterySoc: number, isAlertOnce: boolean = false): Promise<void> {
    const task = new TaskItem('publishPhone', async (): Promise<void> => {
      await this.publishLowBatteryNtf(batterySoc, isAlertOnce);
    });
    this.publishNotificationQueue.add(task);
  }

  /**
   * 关闭通知
   */
  public async cancelNotification(): Promise<void> {
    const hasNotification = this.hasNotification();
    if (!hasNotification) {
      return;
    }
    const task = new TaskItem('cancelPhone', async (): Promise<void> => {
      log.showInfo(`cancelNotification start`);
      try {
        await notificationManager.cancel(Constants.LOW_BATTERY_NTF_ID);
        log.showInfo(`cancelNotification success`);
      } catch (err) {
        log.showError(`cancelNotification failed: ${err}`);
      }
    });
    this.publishNotificationQueue.add(task);
  }

  /**
   * 判断是否存在低电量通知
   */
  public hasNotification(): boolean {
    const context: common.Context = GlobalContext.getContext();
    const hasNotification: boolean =
      crossModuleCallUtil?.call('hasNotification', context.applicationInfo.uid, Constants.LOW_BATTERY_NTF_ID);
    return hasNotification;
  }

  private async getWantAgent(): Promise<WantAgent> {
    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [{
        action: Constants.LOW_BATTERY_NTF_EVENT
      }],
      actionType: wantAgent.OperationType.SEND_COMMON_EVENT,
      requestCode: Constants.LOW_BATTERY_NTF_REQUEST_CODE
    };
    const agent = await wantAgent.getWantAgent(wantAgentInfo);
    return agent;
  }

  private setSmallIcon(): void {
    log.showInfo(`setSmallIcon start`);
    try {
      let context: context.Context = GlobalContext.getContext() as context.Context;
      let array = context.resourceManager.getMediaByNameSync(Constants.LOW_BATTERY_NTF_ICON);
      let res: image.ImageSource = image.createImageSource(array.buffer);
      if (!res) {
        log.showError(`setSmallIcon failed. no resourceManager`);
        return;
      }
      res.createPixelMap().then((pixelMap) => {
        if (pixelMap) {
          this.smallIcon = pixelMap;
          log.showInfo('setSmallIcon success');
          PixelMapUtil.addName(this.smallIcon, `PhoneNotificationCtrl_setSmall`);
        }
      }).finally(() => {
        res.release((err) => {
          log.showError(`setSmallIcon release error: ${err?.code}-${err?.message}`);
        });
      });
    } catch (err) {
      log.showError(`setSmallIcon failed: ${err}`);
    };
  }
}