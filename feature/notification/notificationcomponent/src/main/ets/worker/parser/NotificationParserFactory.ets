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

import { BaseNotification, SysTypeCode } from '@ohos/systemuicommon';
import notificationSubscribe from '@ohos.notificationSubscribe';
import notificationManager from '@ohos.notificationManager';
import {
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil
} from '@ohos/basicutils';
import { BaseNotificationParser } from './BaseNotificationParser';
import { LiveType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../../maintenance/NotificationExceptionCode';
import { ParseNotificationMaintenance } from '../../maintenance/ParseNotificationMaintenance';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationParserFactory');

export class NotificationParserFactory {
  /**
   * 解析通知数据
   * @param postData
   * @returns
   */
  public static async parse(postData: notificationSubscribe.SubscribeCallbackData, needUpdate: boolean):
    Promise<BaseNotification | undefined> {
    try {
      if (CommonUtils.isInvalid(postData.request?.creatorUserId)) {
        log.info('Parse notification failed, creatorUserId is invalid:', postData.request?.hashCode);
        new ParseNotificationMaintenance(false).reportParseFailed(postData.request, new Error('userId invalid'));
        return undefined;
      }
      if (!NotificationParserFactory.checkValid(postData)) {
        new ParseNotificationMaintenance(false).reportParseFailed(postData.request, new Error('invalid data'));
        return undefined;
      }
      log.warn('Parse notification begin:', postData.request.hashCode);
      TraceUtil.startTrace(DomainName.SYS_UI, `ParseNotification:${postData.request.hashCode}`);
      const isConvertedFromNormal = NotificationParserFactory.convertTemplate(postData);
      const entry = await new BaseNotificationParser().parse(postData, needUpdate);
      entry.isConvertFromNormal = isConvertedFromNormal;
      TraceUtil.endTrace(DomainName.SYS_UI, `ParseNotification:${postData.request.hashCode}`);
      log.warn('Parse notification end:', entry.hashCode);
      NotificationParserFactory.logParseInfo(entry);
      return entry;
    } catch (e) {
      log.error('Parse notification failed:', e);
      new ParseNotificationMaintenance(false).reportParseFailed(postData.request, e);
      return undefined;
    }
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
   * 检查消息合法性
   * @param postData
   * @returns
   */
  private static checkValid(postData: notificationSubscribe.SubscribeCallbackData): boolean {
    const systemLiveView = postData.request.content?.systemLiveView;
    const liveType = systemLiveView?.liveViewType as number as LiveType;
    if (liveType === LiveType.INSTANT || liveType === LiveType.INSTANT_BANNER) {
      LogWithHa.error(log, `Current version is not support instant live or banner: ${postData.request.hashCode}`,
        NotificationExceptionCode.LIVE_VIEW_INVALID, undefined, 'parseNotification');
      return false;
    }
    return true;
  }

  /**
   * 记录通知解析后的数据信息，只打印重要信息，不能打印敏感信息
   * @param entry
   */
  private static logParseInfo(entry: BaseNotification): void {
    const result: Record<string, Object> = {};

    result.id = entry.id;
    result.slotType = entry.slotType;
    result.slotLevel = entry.slotLevel;
    result.isAutoDelete = entry.isAutoDelete;
    result.isShowHeadsUp = entry.isShowHeadsUp;
    result.isHiddenInKg = entry.isHiddenInKg;
    if (entry.isFromSystemApp) {
      result.isFromSystemApp = entry.isFromSystemApp;
    }
    result.isHeadsUpStick = entry.isHeadsUpStick;
    result.isNoClear = entry.isNoClear;
    result.isRemoveAllowed = entry.isRemoveAllowed;
    if (entry.agentBundle) {
      result.agentBundle = entry.agentBundle;
    }
    if (entry.sound) {
      result.sound = entry.sound;
    }
    if (entry.vibration) {
      result.vibration = entry.vibration;
    }
    result.remindConfig = entry.remindConfig;
    if (entry.isFromSystemApp) {
      result.isFromSystemApp = entry.isFromSystemApp;
    }
    result.appLabel = entry.appLabel;
    if (entry.smallIcon?.getPixelBytesNumber()) {
      result.smallIconBytes = entry.smallIcon?.getPixelBytesNumber();
    }
    result.controlConfig = entry.controlConfig;
    result.isAlertOnce = entry.isAlertOnce;
    if (entry.soundDuration) {
      result.soundDuration = entry.soundDuration;
    }
    if (entry.channelId) {
      result.channelId = entry.channelId;
    }
    result.deliveryTime = entry.deliveryTime;
    if (entry.classification) {
      result.classification = entry.classification;
    }
    log.warn('Parse notification result:', result);
  }
}