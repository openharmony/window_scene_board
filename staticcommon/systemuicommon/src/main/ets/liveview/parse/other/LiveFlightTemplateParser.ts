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
import type image from '@ohos.multimedia.image';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import type NtfMgr from '@ohos.notificationManager';
import { LiveFlightTemplate } from '../../data/template/LiveFlightTemplate';
import type { Parse } from '../interface/Parse';
import transResToPicHelper from '../utils/TransResToPicHelper';
import { OtherBaseTemplateParser } from './OtherBaseTemplateParser';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveFlightTemplateParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * 左右文本类模板解析器
 */
export class LiveFlightTemplateParser extends OtherBaseTemplateParser implements Parse<LiveFlightTemplate> {
  /**
   * 解析模板数据
   *
   * @param request 实况请求
   * @returns 模板数据
   */
  parse(request: NtfMgr.NotificationRequest): LiveFlightTemplate {
    let extraInfo = request.content.liveView.extraInfo;
    let pictureInfo = request.content.liveView.pictureInfo;
    let data = new LiveFlightTemplate();
    // 解析公有数据
    super.parseCommonData(request, data);
    // 解析扩展区数据
    data.setFirstTitle(extraInfo['FlightLayout.firstTitle'] as string);
    data.setFirstContent(extraInfo['FlightLayout.firstContent'] as string);
    data.setLastTitle(extraInfo['FlightLayout.lastTitle'] as string);
    data.setLastContent(extraInfo['FlightLayout.lastContent'] as string);
    data.setLastTitleSuperscript(extraInfo['FlightLayout.lastTitleSuperscript'] as string);
    data.setLastContentSuperscript(extraInfo['FlightLayout.lastContentSuperscript'] as string);
    data.setSpaceType(extraInfo['FlightLayout.spaceType'] as number);
    data.setSpaceText(extraInfo['FlightLayout.spaceText'] as string);

    let icons: Array<image.PixelMap> = pictureInfo?.['FlightLayout.spaceIcon'];
    if (!CommonUtils.isInvalid(icons) && icons.length > 0) {
      data.setSpaceIcon(icons[0]);
    }

    const iconUpdateKey = extraInfo.ExtraInfoUpdateKey as Array<string>;
    if (transResToPicHelper.needParsePic(iconUpdateKey, 'FlightLayout.spaceIcon.res')) {
      data.setSpaceIconRes(extraInfo['FlightLayout.spaceIcon.res'] as string);
      const images: image.PixelMap[] = extraInfo.liveImages?.['FlightLayout.spaceIcon.res'];
      this.setImageFromParser(data, 'spaceIcon', images);
    }

    data.setDisplayHorizontalLine(extraInfo['FlightLayout.isDisplayHorizontalLine'] as boolean);
    data.setAdditionalText(extraInfo['FlightLayout.additionalText'] as string);
    return data;
  }
}