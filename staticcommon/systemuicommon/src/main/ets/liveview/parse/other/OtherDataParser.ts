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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import NtfMgr from '@ohos.notificationManager';
import { LiveType } from '../../common/LiveConstants';
import type { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import { LiveViewData } from '../../data/LiveViewData';
import type { LiveBaseTemplate } from '../../data/template/LiveBaseTemplate';
import { BaseDataParser } from '../interface/BaseDataParser';
import type { Parse } from '../interface/Parse';
import { OtherBaseTemplateParser } from './OtherBaseTemplateParser';
import { LiveFlightTemplateParser } from './LiveFlightTemplateParser';
import { LivePickUpTemplateParser } from './LivePickUpTemplateParser';
import { LiveProgressTemplateParser } from './LiveProgressTemplateParser';
import { LiveScoreTemplateParser } from './LiveScoreTemplateParser';
import { OtherLiveCapsuleDataParser } from './OtherLiveCapsuleParser';
import { LiveNavigationTemplateParser } from './LiveNavigationTemplateParser';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'OtherDataParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 三方应用数据解析器
 */
export class OtherDataParser extends BaseDataParser<LiveViewData> {
  /**
   * 映射实况卡片模板类型 => 对应模板解析器
   */
  private templateParsers: Map<LiveType, Parse<LiveBaseTemplate>> = new Map();

  /**
   * 胶囊数据解析器
   */
  private capsuleDataParser: Parse<LiveCapsuleData> = new OtherLiveCapsuleDataParser();

  /**
   * 三方应用模板类型集合
   */
  private typeSet: Set<LiveType>;

  constructor() {
    super();
    this.init();
  }

  /**
   * 尝试解析三方实况数据，解析失败则交给下一级责任链继续解析
   *
   * @param request 原数据
   * @returns 解析结果
   */
  parse(request: NtfMgr.NotificationRequest): LiveViewData | undefined {
    log.showInfo('begin parse data');
    let data: LiveViewData | undefined = this.doParse(request);
    // 本地应用数据解析成功
    if (!CommonUtils.isInvalid(data)) {
      return data;
    }
    return this.getNextParser()?.parse(request);
  }

  /**
   * 模板与胶囊数据解析
   *
   * @param request 实况通知请求
   * @returns 解析完毕的实况通知数据
   */
  doParse(request: NtfMgr.NotificationRequest): LiveViewData | undefined {
    if (!this.isOtherLiveView(request)) {
      log.showInfo('not other live view data, ' + request?.content?.notificationContentType +
        ', ' + !CommonUtils.isInvalid(request?.content?.liveView?.extraInfo) +
        ', ' + request?.content?.liveView?.extraInfo?.['LayoutData.layoutType']);
      throw new Error('OtherLiveView parse failed, invalid data');
    }
    let newData = new LiveViewData();
    newData.setStatus(request.content.liveView?.status?.valueOf());
    let liveType = request?.content?.liveView?.extraInfo?.['LayoutData.layoutType'] as number;
    newData.setLiveType(liveType);
    log.showInfo('doParse, liveType:' + liveType);
    let templateParser = this.templateParsers.get(liveType);
    if (templateParser) {
      // 解析模板数据
      newData.setTemplate(templateParser.parse(request));
    }
    // 解析胶囊数据
    newData.setCapsule(this.capsuleDataParser.parse(request));
    return newData;
  }

  /**
   * 检测是否为三方应用实况通知
   *
   * @param request 实况通知数据
   * @returns 检测结果
   */
  private isOtherLiveView(request: NtfMgr.NotificationRequest): boolean {
    let contentType = request?.content?.notificationContentType;
    let extraInfo = request?.content?.liveView?.extraInfo;
    let type = request?.content?.liveView?.extraInfo?.['LayoutData.layoutType'] as number;
    return contentType === NtfMgr.ContentType.NOTIFICATION_CONTENT_LIVE_VIEW &&
      !CommonUtils.isInvalid(extraInfo) && this.typeSet.has(type);
  }

  /**
   * 初始化，卡片模板类型与解析器之间的关系
   */
  private init(): void {
    log.showInfo('begin init');

    this.templateParsers.set(LiveType.NO_LAYOUT, new OtherBaseTemplateParser());
    this.templateParsers.set(LiveType.PROGRESS, new LiveProgressTemplateParser());
    this.templateParsers.set(LiveType.FLIGHT, new LiveFlightTemplateParser());
    this.templateParsers.set(LiveType.PICK_UP, new LivePickUpTemplateParser());
    this.templateParsers.set(LiveType.SCORE, new LiveScoreTemplateParser());
    this.templateParsers.set(LiveType.NAVIGATION, new LiveNavigationTemplateParser());

    this.typeSet = new Set();
    this.typeSet.add(LiveType.NO_LAYOUT);
    this.typeSet.add(LiveType.PROGRESS);
    this.typeSet.add(LiveType.PICK_UP);
    this.typeSet.add(LiveType.FLIGHT);
    this.typeSet.add(LiveType.SCORE);
    this.typeSet.add(LiveType.NAVIGATION);
  }
}