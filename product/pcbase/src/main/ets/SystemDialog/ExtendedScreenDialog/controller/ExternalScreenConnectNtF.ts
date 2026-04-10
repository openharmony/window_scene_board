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

import WantAgent from '@ohos.app.ability.wantAgent';
import type { WantAgent as gWantAgent } from '@ohos.app.ability.wantAgent';
import notificationManager from '@ohos.notificationManager';
import type NtfMgr from '@ohos.notificationManager';

import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper} from '@ohos/basicutils';
import { BusinessError } from '@ohos.base';
import wantAgent from '@ohos.wantAgent';
import CommonEventManager from '@ohos.commonEventManager';
import { GlobalContext, sSettingsUtil, ResourceManager } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';
import { StartAbilityUtil } from '@ohos/windowscene';
import osAccount from '@ohos.account.osAccount';

const TAG: string = 'ExternalScreenConnectNtf';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const HIDE_TITLE_MODE: string = '012';
const SCENE_BOARD_BUNDLE_NAME = 'com.ohos.sceneboard';
const IGNORE_NOTIFICATION_ACTION = 'ignore_notification_screen_connect';
const GOTO_SETTINGS_ACTION = 'notification_goto_settings';
const IGNORE_NOTIFICATION_VALUE = 'no_remind';
const NOTIFICATION_REMIND_VALUE = 'remind';
const NOTIFICATION_IMAGE_PATH = 'notify_screen_conn.png';
const NOTIFICATION_ID = 1637;
const REQUEST_SETTINGS_CODE = 1635;
const REQUEST_IGNORE_CODE = 1636;


/**
 * 插外接显示器通知
 */
export class ExternalScreenConnectNtF {
  private static subscriber?: CommonEventManager.CommonEventSubscriber;
  private static subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
    events: [IGNORE_NOTIFICATION_ACTION, GOTO_SETTINGS_ACTION],
    publisherBundleName: SCENE_BOARD_BUNDLE_NAME,
  };
  private static isShowNotify: boolean = false;

  public static registerButtonActionObserver(): void {
    if (!CheckEmptyUtils.isEmpty(this.subscriber)) {
      log.showWarn('registerChargeReminderObserver exits');
      return;
    }
    CommonEventManager.createSubscriber(this.subscribeInfo, (err, commonEventSubscriber) => {
      if (!CheckEmptyUtils.isEmpty(err)) {
        log.showError('createSubscriber is error');
        return;
      }
      this.subscriber = commonEventSubscriber;
      if (CheckEmptyUtils.isEmpty(this.subscriber)) {
        log.showError('subscriber is null');
        return;
      }
      this.createButtonActionSubscribe();
    });
  }

  private static unRegisterButtonActionObserver(): void {
    if (CheckEmptyUtils.isEmpty(this.subscriber)) {
      log.showWarn('registerReminderObserver not exits');
      return;
    }
    CommonEventManager.unsubscribe(this.subscriber, (error, data) => {
      if (error) {
        log.showError(`unsubscribe error code: ${error.code}`);
        return;
      }
      log.showInfo('unsubscribe reminder.');
      this.subscriber = null;
    });
  }

  private static saveNoReminder(): void {
    const res: boolean = sSettingsUtil.setSystemValue(IGNORE_NOTIFICATION_ACTION, IGNORE_NOTIFICATION_VALUE);
    if (!res) {
      log.showError('saveNoReminder error');
    }
    log.showInfo('notification ignore');
  }

  private static goToSettings(): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility',
      uri: 'display_settings',
      moduleName: 'pc_settings',
      parameters: {
        screenId: 0,
        externalDevice: true
      }
    });
    this.isShowNotify = false;
  }

  private static createButtonActionSubscribe(): void {
    CommonEventManager.subscribe(this.subscriber, (err, data) => {
      if (!CheckEmptyUtils.isEmpty(err)) {
        log.showError(`createButtonActionSubscribe error code: ${err?.code}`);
        return;
      }
      if (CheckEmptyUtils.isEmpty(data)) {
        log.showError(`createButtonActionSubscribe data is null code: ${err?.code}`);
        return;
      }
      if (!data?.bundleName || SCENE_BOARD_BUNDLE_NAME !== data?.bundleName) {
        log.showError(`is bundleName invalid, from: ${data?.bundleName}`);
        return;
      }
      if (data.event === IGNORE_NOTIFICATION_ACTION) {
        this.saveNoReminder();
      } else if (data.event === GOTO_SETTINGS_ACTION) {
        this.goToSettings();
      }
      this.cancelNotification();
    });
  }

  private static wantAgentInfo: WantAgent.WantAgentInfo = {
    wants: [
      {
        action: GOTO_SETTINGS_ACTION,
        bundleName: SCENE_BOARD_BUNDLE_NAME
      }
    ],
    actionType: wantAgent.OperationType.SEND_COMMON_EVENT,
    requestCode: REQUEST_SETTINGS_CODE,
    wantAgentFlags: [WantAgent.WantAgentFlags.CONSTANT_FLAG]
  };

  private static wantAgentIgnore: WantAgent.WantAgentInfo = {
    wants: [
      {
       action: IGNORE_NOTIFICATION_ACTION,
       bundleName: SCENE_BOARD_BUNDLE_NAME
      }
    ],
    actionType: wantAgent.OperationType.SEND_COMMON_EVENT,
    requestCode: REQUEST_IGNORE_CODE,
    wantAgentFlags: [WantAgent.WantAgentFlags.CONSTANT_FLAG]
  };

  public static rePublishNotification(): void {
    if (this.isShowNotify) {
      this.publishScreenConnNotification(false);
    }
  }

  public static publishScreenConnNotification(isFirstPublish: boolean): void {
    let osAccountManager: osAccount.AccountManager = osAccount.getAccountManager();
    osAccountManager.getOsAccountLocalId().then((currentId: number) => { // 获取当前进程的用户id
      log.showInfo('publishScreenConnNotification getOsAccountLocalId');
      osAccountManager.getForegroundOsAccountLocalId().then((currentForegroundId: number) => { // 获取前台用户id
        log.showInfo('publishScreenConnNotification getForegroundOsAccountLocalId');
        if (currentId === currentForegroundId) {
          log.showInfo('publishScreenConnNotification current is foreground');
          this.publishNotification(isFirstPublish);
        }
      }).catch((err: BusinessError) => {
        log.showError(`publishScreenConnNotification getForegroundOsAccountLocalId failed, code: ${err?.code}, message: ${err?.message}`);
      });
    }).catch((err: BusinessError) => {
      log.showError(`publishScreenConnNotification getOsAccountLocalId failed, code: ${err?.code}, message: ${err?.message}`);
    });
  }

  public static async publishNotification(isFirstPublish: boolean): Promise<void> {
    let userWant = sSettingsUtil.getSystemValue(IGNORE_NOTIFICATION_ACTION, NOTIFICATION_REMIND_VALUE);
    if (userWant === IGNORE_NOTIFICATION_VALUE) {
      log.showInfo(`user want to ignore the event`);
      return;
    }
    this.registerButtonActionObserver();
    let agent: gWantAgent;
    try {
      agent = await WantAgent.getWantAgent(this.wantAgentInfo);
      if (!agent) {
        log.showWarn('getWantAgent is invalid');
        return;
      }
    } catch (error) {
      log.showError('publishNotification getWantAgent error');
    }
    const pixelMap = await this.getRawPixelMap(NOTIFICATION_IMAGE_PATH);
    notificationManager?.publish(this.getNotificationRequest(pixelMap, agent, isFirstPublish))
      .then(() => {
        log.showInfo('publishNotification success');
      })
      .catch((error: BusinessError) => {
        log.showError(`publishNotification error: ${error?.code}`);
      });
    this.isShowNotify = true;
  }

  /**
   * 获取通知的请求体
   *
   * @param buttonArray 按钮集
   * @returns 发送通知所需的请求体
   */
  private static getNotificationRequest(pixelMap: image.PixelMap, agent: gWantAgent,
    isFirstPublish: boolean): NtfMgr.NotificationRequest {
    const notificationRequest: NtfMgr.NotificationRequest = {
      id: NOTIFICATION_ID,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: ResourceManager.getInstance().getStringByName('external_screen_connect_notify_title'),
          text: ResourceManager.getInstance().getStringByName('external_screen_connect_notify_content'),
        },
      },
      extraInfo: {
        'creatorBundleName': SCENE_BOARD_BUNDLE_NAME,
        'appName': '',
        'hideTitleCategory': HIDE_TITLE_MODE
      }
    };
    if (!CheckEmptyUtils.isEmpty(pixelMap)) {
      notificationRequest.smallIcon = pixelMap;
    }
    if (!CheckEmptyUtils.isEmpty(agent)) {
      notificationRequest.wantAgent = agent;
    }
    if (isFirstPublish) {
      notificationRequest.notificationSlotType = notificationManager.SlotType.SERVICE_INFORMATION;
    }
    return notificationRequest;
  }

  public static cancelNotification(): void {
    notificationManager?.cancel(NOTIFICATION_ID)
      .then(() => {
        log.showInfo('cancelNotification success');
      })
      .catch((error: BusinessError) => {
        log.showError(`cancelNotification error: ${error?.code}`);
      });
    this.unRegisterButtonActionObserver();
    this.isShowNotify = false;
  }

  /**
   * 从rawfile路径获取PixelMap
   *
   * @param path 图片资源rawfile路径
   * @returns PixelMap对象
   */
  public static async getRawPixelMap(path: string): Promise<image.PixelMap> {
    let pixelMap: image.PixelMap;
    let imageSource: image.ImageSource;
    if (CommonUtils.isEmpty(path)) {
      return pixelMap;
    }
    let context = GlobalContext.getContext();
    try {
      const content = await context?.resourceManager?.getRawFileContent(path);
      if (CheckEmptyUtils.isEmpty(content)) {
        log.showError('getRawPixelMap: content is null');
        return pixelMap;
      }
      let buffer: ArrayBuffer = content.buffer;
      imageSource = image.createImageSource(buffer);
      if (!CheckEmptyUtils.isEmpty(imageSource)) {
        let decodingOptions: image.DecodingOptions = {
          editable: false,
          desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
        };
        pixelMap = await imageSource.createPixelMap(decodingOptions);
      }
    } catch (err) {
      log.showError(`getRawPixelMap: err:${err?.message}`);
    } finally {
      this.releaseImageSource(imageSource);
    }
    return pixelMap;
  }

  public static releaseImageSource(imageSource: image.ImageSource): void {
    if (!CheckEmptyUtils.isEmpty(imageSource)) {
      imageSource.release((err: BusinessError) => {
        if (err) {
          log.showError(`${err.message} releaseImageSource release imageSource object`);
        }
      });
    }
  }
}
