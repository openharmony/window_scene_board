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

import Notification from '@ohos.notificationManager';
import { image } from '@kit.ImageKit';
import { WantAgent } from '@kit.AbilityKit';
import resourceManager from '@ohos.resourceManager';
import INotificationConfig from './INotificationConfig';
import { AigcPixelmapUtils } from '../AigcPixelmapUtils';
import { Log } from '../IdlService/Log';

const TAG = '[AigcService]AigcNotificationManager';

const NOTIFICATION_ID: number = 522;

const AIGC_NOTIFICATION_ID: number = 523;

const DYNAMIC_NOTIFICATION_ID: number = 524;

const NOTICE_CTRL_FLAG: number = 0x15;

export enum AigcNoticeType {
  FAIL = -1,
  EXECUTING = 0,
  FINISH = 1,
}

export default class AigcNotificationManager {
  private static instance: AigcNotificationManager;

  public static readonly STATUS_ONGOING: number = 0;

  public static readonly STATUS_SUCCESS: number = 1;

  public static readonly STATUS_FAIL: number = -1;

  public static readonly STATUS_CANCEL: number = 10000;

  public static readonly NOTIFICATION_MODE: number = 1;

  private notifyIconPixmap?: PixelMap;

  /**
   * 获取NotificationManager实例
   *
   * @returns NotificationManager实例
   */
  public static getInstance(): AigcNotificationManager {
    if (!AigcNotificationManager.instance) {
      AigcNotificationManager.instance = new AigcNotificationManager();
    }
    return AigcNotificationManager.instance;
  }

  /**
   * 发送通知
   *
   * @param {string} editorId - 主题ID
   * @param {number} type - 通知类型
   * @param notificationConfig 通知配置，标题，描述等信息
   * @param {number} [errCode=0] - 错误代码，默认为0
   * @param {string} version aigc版本
   * @return {Promise<void>} 返回一个Promise，当通知发送成功时resolve，失败时reject
   */
  public async sendNotice(editorId: string, type: number, notificationConfig: INotificationConfig,
    errCode: number = 0, version?: string): Promise<void> {
    Log.info(TAG, `begin to send wallpaper notification, type is ${type},
      notiId is ${notificationConfig.getNotificationId(version)}.`);
    await this.cancelNotice(notificationConfig.getNotificationId(version));
    let notificationRequest: Notification.NotificationRequest =
      await this.buildNotice(editorId, type, errCode, notificationConfig, version);

    Notification.publish(notificationRequest).then(() => {
      Log.info(TAG, `notification publish success`);
    }).catch((err: Error) => {
      Log.error(TAG, `notification publish has an error, msg: ${err.message}.`);
    }).finally(() => {
      this.notifyIconPixmap?.release();
      this.notifyIconPixmap = undefined;
    })
  }

  private async buildNotice(editorId: string, type: number, errCode: number, notificationConfig: INotificationConfig,
    version?: string): Promise<Notification.NotificationRequest> {
    let notificationRequest: Notification.NotificationRequest = {
      id: notificationConfig.getNotificationId(version),
      notificationSlotType: Notification.SlotType.SERVICE_INFORMATION,
      tapDismissed: type !== AigcNoticeType.EXECUTING,
      notificationControlFlags: NOTICE_CTRL_FLAG,
      isOngoing: true,
      content: {
        // 是否会弹出通知图标、通知具体内容等等
        notificationContentType: Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT
      },
      extraInfo: {
        editorId: editorId
      }
    }
    // const resourceManager = getContext(this).resourceManager;
    // let textContent: Notification.NotificationBasicContent | undefined =
      // notificationConfig.buildTextContent(resourceManager, type, version);
    // if (textContent !== undefined) {
    //   notificationRequest.content.normal = textContent;
    // }

    let wantAgentObj: WantAgent | null = await notificationConfig.getWantAgent(editorId, type, errCode, version);
    // this.notifyIconPixmap = await this.buildNoticeIcon(resourceManager);
    AigcPixelmapUtils.addName(this.notifyIconPixmap, `Notify_Icon_Pixmap`);
    if (this.notifyIconPixmap !== undefined) {
      notificationRequest.smallIcon = this.notifyIconPixmap;
    }
    if (wantAgentObj) {
      notificationRequest.wantAgent = wantAgentObj;
    }
    return notificationRequest;
  }

  private async buildNoticeIcon(resourceManager: resourceManager.ResourceManager): Promise<image.PixelMap | undefined> {
    try {
      // const noticeIcon: Uint8Array = await resourceManager.getMediaContent($r('app.media.desktop_and_personalize'));
      const noticeIcon: Uint8Array = await resourceManager.getMediaContent($r('app.media.icon'));
      const imageSource: image.ImageSource = image.createImageSource(noticeIcon.buffer);
      const iconPixelmap: image.PixelMap = await imageSource.createPixelMap();
      imageSource.release();
      return iconPixelmap;
    } catch (err) {
      Log.error(TAG, `get notification icon error. Code is ${err?.code}, message is ${err?.message}`);
      return undefined;
    }
  }

  /**
   * 取消通知接口
   *
   * @param editorId 主题id
   * @param notificationConfig 通知接口，用于确定具体的通知id
   * @returns Promise<void>
   */
  public async cancelNotifyByEditorId(editorId: string, notificationConfig: INotificationConfig): Promise<void> {
    Log.info(TAG, `cancelNotifyByEditorId start`);
    try {
      let requests = await Notification.getActiveNotifications();
      let requestCount = requests.length;
      for (let i = 0; i < requestCount; i++) {
        if (!requests[i].id) {
          continue;
        }
        if ((requests[i].id === notificationConfig.getNotificationId() ||
          requests[i].id === DYNAMIC_NOTIFICATION_ID ||
          requests[i].id === AIGC_NOTIFICATION_ID ||
          requests[i].id === NOTIFICATION_ID) &&
          requests[i].extraInfo?.editorId === editorId) {
          this.cancelNotice(requests[i].id!);
          break;
        }
      }
    } catch (err) {
      Log.error(TAG, `cancelNotifyByEditorId err. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  public async cancelNotice(noticeId: number): Promise<void> {
    return new Promise((resolve, reject) => {
      Notification.cancel(noticeId).then((err) => {
        Log.info(TAG, `notification cancel success`);
        resolve();
      }).catch((err: Error) => {
        Log.info(TAG, `notification cancel has an error, msg: ${err.message}.`);
        resolve();
      });
    })
  }
}
