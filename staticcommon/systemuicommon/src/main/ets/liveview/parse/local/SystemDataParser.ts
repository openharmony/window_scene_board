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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import NtfMgr from '@ohos.notificationManager';
import { CapsuleType, LiveExtendType, LiveType } from '../../common/LiveConstants';
import { LiveViewData } from '../../data/LiveViewData';
import type { LiveSystemTemplate } from '../../data/template/LiveSystemTemplate';
import { BaseDataParser } from '../interface/BaseDataParser';
import { LocalLiveCapsuleDataParser } from './LocalLiveCapsuleDataParser';
import { LiveSystemTemplateParser } from './LiveSystemTemplateParser';
import type { Parse } from '../interface/Parse';
import type { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'SystemDataParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 系统类应用实况数据解析器
 */
export class SystemDataParser extends BaseDataParser<LiveViewData> {
  private liveSystemTemplateParser: Parse<LiveSystemTemplate> = new LiveSystemTemplateParser();
  private liveCapsuleDataParser: Parse<LiveCapsuleData> = new LocalLiveCapsuleDataParser;

  /**
   * 尝试解析本地系统实况数据，解析失败则交给下一级责任链继续解析
   *
   * @param request 原数据
   * @returns 解析结果
   */
  parse(request: NtfMgr.NotificationRequest): LiveViewData | undefined {
    log.showDebug('begin parse data');
    let data: LiveViewData | undefined = this.doParse(request);
    // 系统应用数据解析成功，直接返回
    if (!CommonUtils.isInvalid(data)) {
      return data;
    }
    return this.getNextParser()?.parse(request);
  }

  /**
   * 数据解析,分别解析系统模板数据和胶囊数据
   *
   * @param request 实况通知请求
   * @returns 解析完毕的实况通知数据
   */
  doParse(request: NtfMgr.NotificationRequest): LiveViewData | undefined {
    if (!this.isSystemLiveView(request)) {
      log.showInfo('not local live view data');
      return undefined;
    }
    let newData = new LiveViewData();
    // 设置实况数据模板类型，区分三方应用或系统应用
    newData.setLiveType(LiveType.TYPE_SYSTEM);
    newData.setSysTypeCode(request?.content?.systemLiveView?.typeCode);
    newData.setTemplate(this.liveSystemTemplateParser.parse(request));
    newData.setCapsule(this.liveCapsuleDataParser.parse(request));
    // 设置isMute
    newData.setIsMute(request?.extraInfo?.isMute);
    this.fillCapsuleExtendData(newData);
    return newData;
  }

  /**
   * 检测是否为本地系统应用实况通知
   *
   * @param request 实况通知数据
   * @returns 检测结果
   */
  private isSystemLiveView(request: NtfMgr.NotificationRequest): boolean {
    let contentType = request?.content?.notificationContentType;
    let systemLiveView = request?.content?.systemLiveView;
    return contentType === NtfMgr.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW &&
      !CommonUtils.isInvalid(systemLiveView);
  }

  /**
   * 对于系统应用而言，胶囊扩展数据与卡片中的扩展数据一致，将卡片中的扩展数据填充一份到胶囊中
   *
   * @param data 解析得到的实况数据
   */
  private fillCapsuleExtendData(data: LiveViewData): void {
    if (!data || !data.capsule || !data.template) {
      return;
    }
    let type = data.capsule.type;
    log.showInfo('fillCapsuleExtendData, type:' + type);
    let template = data.template as LiveSystemTemplate;
    switch (type) {
      case CapsuleType.TYPE_PROGRESS:
        data.capsule.setCapsuleTypeData(template.getExtendData(LiveExtendType.TYPE_COMMON_PROGRESS));
        break;
      case CapsuleType.TYPE_TIMER:
        data.capsule.setCapsuleTypeData(template.getExtendData(LiveExtendType.TYPE_COMMON_TIMER));
        break;
      default:
        log.showWarn('fillCapsuleExtendData no capsule type data');
        break;
    }
  }
}