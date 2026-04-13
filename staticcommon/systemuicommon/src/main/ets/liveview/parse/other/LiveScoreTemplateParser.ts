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
import type image from '@ohos.multimedia.image';
import { CommonUtils, LogDomain, LogHelper, ArrayUtils } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import type NtfMgr from '@ohos.notificationManager';
import { LiveScoreTemplate } from '../../data/template/LiveScoreTemplate';
import type { Parse } from '../interface/Parse';
import parseUtils from '../utils/ParseUtils';
import transResToPicHelper from '../utils/TransResToPicHelper';
import { OtherBaseTemplateParser } from './OtherBaseTemplateParser';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveScoreTemplateParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * 扩展区中间上方描述文本字符串长度需小于128。
 */
const descMaxLen: number = 128;

/**
 * 赛事类模板解析器
 */
export class LiveScoreTemplateParser extends OtherBaseTemplateParser implements Parse<LiveScoreTemplate> {
  /**
   * 解析模板数据
   *
   * @param request 实况请求
   * @returns 模板数据
   */
  parse(request: NtfMgr.NotificationRequest): LiveScoreTemplate {
    let extraInfo = request.content.liveView.extraInfo;
    let pictureInfo = request.content.liveView.pictureInfo;
    let data = new LiveScoreTemplate();
    // 解析公有数据
    super.parseCommonData(request, data);
    // 解析扩展区数据
    data.setHostName(extraInfo['ScoreLayout.hostName'] as string);
    let icons: Array<image.PixelMap> = pictureInfo?.['ScoreLayout.hostIcon'];
    if (!CommonUtils.isInvalid(icons) && icons.length > 0) {
      data.setHostIcon(icons[0]);
    }
    const iconUpdateKey = extraInfo.ExtraInfoUpdateKey as Array<string>;
    if (transResToPicHelper.needParsePic(iconUpdateKey, 'ScoreLayout.hostIcon.res')) {
      data.setHostIconRes(extraInfo['ScoreLayout.hostIcon.res'] as string);
      const images: image.PixelMap[] = extraInfo.liveImages?.['ScoreLayout.hostIcon.res'];
      this.setImageFromParser(data, 'hostIcon', images);
    }
    data.setHostScore(extraInfo['ScoreLayout.hostScore'] as string);
    data.setGuestName(extraInfo['ScoreLayout.guestName'] as string);
    icons = pictureInfo?.['ScoreLayout.guestIcon'];
    if (!CommonUtils.isInvalid(icons) && icons.length > 0) {
      data.setGuestIcon(icons[0]);
    }
    if (transResToPicHelper.needParsePic(iconUpdateKey, 'ScoreLayout.guestIcon.res')) {
      data.setGuestIconRes(extraInfo['ScoreLayout.guestIcon.res'] as string);
      const images: image.PixelMap[] = extraInfo.liveImages?.['ScoreLayout.guestIcon.res'];
      this.setImageFromParser(data, 'guestIcon', images);
    }
    data.setGuestScore(extraInfo['ScoreLayout.guestScore'] as string);
    let richTextArr = parseUtils.parseRichText(extraInfo['ScoreLayout.competitionDesc'] as string, descMaxLen);
    data.setCompetitionDesc(richTextArr);
    data.setCompetitionTime(extraInfo['ScoreLayout.competitionTime'] as string);
    data.setDisplayHorizontalLine(extraInfo['ScoreLayout.isDisplayHorizontalLine'] as boolean);
    return data;
  }
}