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

import { SysTypeCode } from '@ohos/systemuicommon';
import { NotificationBase, NotificationUtil, NotificationDataManager,
  LiveNotification, LiveCardNavigationModel } from '@ohos/systemuicommon/newTsIndex';
import notificationSubscribe from '@ohos.notificationSubscribe';
import notificationManager from '@ohos.notificationManager';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { NotificationBaseParser } from './NotificationBaseParser';
import { NormalNotificationParser } from './NormalNotificationParser';
import { LiveNotificationSystemParser } from './LiveNotificationSystemParser';
import { LiveNotificationOtherParser } from './LiveNotificationOtherParser';
import { notificationConfigManager } from '../manager/NotificationConfigManager';
import { ParseNewNotificationMaintenance } from '../maintenance/ParseNewNotificationMaintenance';
import camera from '@ohos.multimedia.camera';
import {
  GlobalContext
} from '@ohos/frameworkwrapper';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationParserFactory');

const TORCH_MODE_ON: number = 1;

/**
 * 通知解析工厂
 */
export class NotificationParserFactory {
  /**
   * 解析通知数据
   * @param postData
   * @returns
   */
  public static async parse(postData: notificationSubscribe.SubscribeCallbackData, oldNtf?: NotificationBase):
    Promise<NotificationBase | undefined> {
    try {
      if (!NotificationParserFactory.checkPostData(postData)) {
        new ParseNewNotificationMaintenance(false).reportParseFailed(postData.request, new Error('check data fail'),
          notificationConfigManager.userId);
        return undefined;
      }

      log.info(`Parse notification ${postData.request.hashCode} begin:`, NotificationParserFactory
        .getPreParseLog(postData.request));
      TraceUtil.startTrace(DomainName.NC, `ParseNotification:${postData.request.hashCode}`);

      const isConvertFromNormal = NotificationParserFactory.convertTemplate(postData);
      let parser: NotificationBaseParser;
      if (NotificationUtil.isSystemLiveView(postData.request)) {
        parser = new LiveNotificationSystemParser(postData, oldNtf);
      } else if (NotificationUtil.isOtherLiveView(postData.request)) {
        parser = new LiveNotificationOtherParser(postData, oldNtf);
      } else {
        parser = new NormalNotificationParser(postData, oldNtf);
      }
      await parser.parseData();
      await parser.parseResource();
      const ntf = parser.getParseResult();
      if (ntf?.isLiveView()) {
        ntf.isConvertFromNormal = isConvertFromNormal;
      }

      TraceUtil.endTrace(DomainName.NC, `ParseNotification:${postData.request.hashCode}`);
      log.info(`Parse notification ${postData.request.hashCode} end:`,
        NotificationParserFactory.getPostParseLog(ntf!));
      return ntf;
    } catch (e) {
      new ParseNewNotificationMaintenance(false).reportParseFailed(postData.request, e,
        notificationConfigManager.userId);
      log.error(`Parse notification ${postData.request.hashCode} failed:`, e);
      return undefined;
    }
  }

  /**
   * 校验数据合法性
   * @param postData
   * @returns
   */
  private static checkPostData(postData: notificationSubscribe.SubscribeCallbackData): boolean {
    const request = postData.request;
    if (!request?.hashCode) {
      log.showError(`Parse ${request?.hashCode} failed, invalid hashCode`);
      return false;
    }
    if (typeof request?.creatorUid !== 'number') {
      log.showError(`Parse ${request?.hashCode} failed, invalid creatorUid: ${request?.creatorUid}`);
      return false;
    }
    if (request?.creatorUserId === undefined ||
      ![notificationConfigManager.userId, 0].includes(request?.creatorUserId)) {
      log.showError(`Parse ${request?.hashCode} failed, invalid creatorUserId: ${request?.creatorUserId}`);
      return false;
    }
    if (request?.content.systemLiveView?.typeCode === SysTypeCode.FLASH_LIGHT &&
      !NotificationParserFactory.checkFlashLightValid()) {
      log.showError(`Parse ${request?.hashCode} failed, invalid flashlight live`);
      notificationSubscribe.remove([request?.hashCode], notificationSubscribe.RemoveReason.CANCEL_REASON_REMOVE);
      return false;
    }
    return true;
  }

  /**
   * 检查手电筒实况是否要显示
   * @returns
   */
  private static checkFlashLightValid(): boolean {
    const mCameraManager: camera.CameraManager = camera.getCameraManager(GlobalContext.getContext());
    if (!mCameraManager || mCameraManager.getTorchMode() !== TORCH_MODE_ON) {
      log.showInfo('Torch mode is close, not need add live parse')
      return false;
    }
    const ntfMap = NotificationDataManager.instance.ntfMap;
    let hasFlight = Array.from(ntfMap.values()).some((ntf) => {
      return ntf.isLiveView() && ntf.isFlashLight()
    })
    log.showInfo(`flashlight live is exist = ${hasFlight}}`);
    return !hasFlight;
  }

  /**
   * 模板通知转换实况样式
   * @param postData
   * @returns
   */
  private static convertTemplate(postData: notificationSubscribe.SubscribeCallbackData): boolean {
    if (postData.request.template?.name !== 'downloadTemplate') {
      return false;
    }
    const templateData = postData.request.template.data ?? {};
    log.showInfo(`Convert from downloadTemplate, progress: ${templateData.progressValue}`);
    // 校验传入的进度数据
    if (typeof templateData.progressValue !== 'number' || templateData.progressValue < 0) {
      templateData.progressValue = 0;
    }
    // 使用普通通知展示
    postData.request.notificationSlotType = notificationManager.SlotType.SERVICE_INFORMATION;
    postData.request.content = {
      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      normal: {
          title: String(templateData.title),
          text: String(templateData.fileName),
      },
    };
    return true;
  }

  /**
   * 解析前的日志
   * @param postData
   * @returns
   */
  private static getPreParseLog(request: notificationManager.NotificationRequest): Record<string, Object> {
    const result: Record<string, Object> = {};
    if (request.creatorBundleName) {
      result['bundle'] = request.creatorBundleName;
    }
    if (request.creatorUserId) {
      result['userId'] = request.creatorUserId;
    }
    if (request.notificationSlotType) {
      result['slotType'] = request.notificationSlotType;
    }
    return result;
  }

  /**
   * 记录通知解析后的数据信息，只打印重要信息，不能打印敏感信息
   * @param entry
   */
  private static getPostParseLog(entry: NotificationBase): Record<string, Object> {
    const result: Record<string, Object> = {};

    result.key = entry.key;
    result.groupKey = entry.groupKey;
    result.category = entry.category;
    result.slotType = entry.slotType;
    result.appLabel = entry.appLabel;
    result.isAutoDelete = entry.isAutoDelete;
    result.isHeadsUp = entry.isHeadsUp;
    result.isHeadsUpStick = entry.isHeadsUpStick;
    result.isShowStatusBarIcon = entry.isShowStatusBarIcon;
    result.isClearAllowed = entry.isClearAllowed;
    result.isRemoveAllowed = entry.isRemoveAllowed;
    result.isSettingIgnore = entry.isSettingIgnore;
    result.isVibrationEnable = entry.isVibrationEnable;
    result.isSoundEnable = entry.isSoundEnable;
    if (entry.agentBundle) {
      result.agentBundle = entry.agentBundle;
    }
    if (entry.customSound) {
      result.customSound = entry.customSound;
    }
    if (entry.isFromSystemApp) {
      result.isFromSystemApp = entry.isFromSystemApp;
    }
    if (entry.smallIcon?.getPixelBytesNumber()) {
      result.smallIconBytes = entry.smallIcon?.getPixelBytesNumber();
    }
    result.remindFlags = entry.remindConfig.flags;
    result.controlFlags = entry.controlConfig.flags;
    result.isAlertOnce = entry.isAlertOnce;
    if (entry.channelId) {
      result.channelId = entry.channelId;
    }
    if (entry.classification) {
      result.classification = entry.classification;
    }
    result.wantAgentId = Reflect.get(entry.wantAgent ?? {}, 'innerKey');
    result.deliveryTime = entry.deliveryTime;
    if (entry instanceof LiveNotification && entry.card instanceof LiveCardNavigationModel) {
      result.layoutCurrentNavigationIcon = entry.card.layoutCurrentNavigationIcon
        ? Reflect.get(entry.card.layoutCurrentNavigationIcon, 'name')
        : undefined;
    }

    return result;
  }
}