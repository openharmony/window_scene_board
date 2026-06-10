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
import {
  ParserController
} from '@ohos/systemuicommon';
import type {
  IParser
} from '@ohos/systemuicommon';
import ntfMgr from '@ohos.notificationManager';
import { ImmersiveKgData } from '../../viewmodel/viewdata/ImmersiveKgData';
import {
  ParseResultType
} from '@ohos/systemuicommon';
import { CommonUtils } from '@ohos/basicutils';

const TAG = 'ImmersiveKgParserController';

/**
 * 沉浸实况数据解析器
 */
class ImmersiveKgParser implements IParser<ntfMgr.NotificationRequest, ImmersiveKgData> {
  /**
   * 复写IParser
   *
   * @param oriData 原数据
   * @param result 上层结果数据
   * @returns 此次结果数据
   */
  parse(oriData: ntfMgr.NotificationRequest, result?: ImmersiveKgData): ImmersiveKgData {
    // 不存在结果则新建
    if (!result) {
      result = new ImmersiveKgData();
    }
    let content = this.getContent(oriData);
    result.setTitle(content?.title);
    result.setContent(content?.text);
    // 数据解析完成
    result.resultType = ParseResultType.MATCH;
    return result;
  }

  private getContent(oriData: ntfMgr.NotificationRequest): ntfMgr.NotificationBasicContent | undefined {
    let type = oriData?.content?.notificationContentType;
    let content = oriData?.content;
    switch (type) {
      case ntfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT:
        return content?.normal;
      case ntfMgr.ContentType.NOTIFICATION_CONTENT_LONG_TEXT:
        return content?.longText;
      case ntfMgr.ContentType.NOTIFICATION_CONTENT_PICTURE:
        return content?.picture;
      case ntfMgr.ContentType.NOTIFICATION_CONTENT_MULTILINE:
        return content?.multiLine;
      case ntfMgr.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW:
        return content?.systemLiveView;
      case ntfMgr.ContentType.NOTIFICATION_CONTENT_LIVE_VIEW:
        return content?.liveView;
      default:
        return undefined;
    }
  }
}

/**
 * 沉浸实况数据解析器管理
 */
export class ImmersiveKgParserController extends ParserController<ntfMgr.NotificationRequest, ImmersiveKgData> {
  constructor() {
    super(TAG);
    // 添加数据解析器
    this.addParser(new ImmersiveKgParser());
  }
}