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

import { notificationManager, notificationSubscribe } from '@kit.NotificationKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationAction, NotificationBaseContent, NtfLongTextContent,
  NtfMultiLineContent, NtfPictureContent } from '@ohos/systemuicommon';
import { NormalNotification, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationBaseParser } from './NotificationBaseParser';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NormalNotificationParser');

/**
 * 普通通知解析
 */
export class NormalNotificationParser extends NotificationBaseParser<NormalNotification> {
  protected oldNtf?: NotificationBase;

  constructor(postData: notificationSubscribe.SubscribeCallbackData, oldNtf?: NotificationBase) {
    super(postData, new NormalNotification());
    this.oldNtf = oldNtf;
  }

  public async parseData(): Promise<void> {
    await super.parseData();
    this.parseContent();
  }

  protected isHeadsUp(): boolean {
    return this.ntf.remindConfig.isBannerEnable();
  }

  /**
   * 解析通知显示内容
   */
  private parseContent(): void {
    const content: notificationManager.NotificationContent = this.request.content;
    if (!content) {
      log.showError('No content');
      return;
    }

    switch (this.ntf.contentType) {
      // 基础类型
      case notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT:
        this.ntf.content = new NotificationBaseContent(content.normal!);
        break;
      // 长文本类型
      case notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT:
        this.ntf.content = new NtfLongTextContent(content.longText!);
        this.ntf.isExpandable = true;
        break;
      // 多行文本类型
      case notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE:
        this.ntf.content = new NtfMultiLineContent(content.multiLine!);
        this.ntf.isExpandable = true;
        break;
      // 大图片类型
      case notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE:
        this.ntf.content = new NtfPictureContent(content.picture!);
        this.ntf.isExpandable = true;
        break;
      default:
        break;
    }
  }
}