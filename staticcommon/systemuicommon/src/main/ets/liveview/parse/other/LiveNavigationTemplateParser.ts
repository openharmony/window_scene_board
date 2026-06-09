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

import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import type NtfMgr from '@ohos.notificationManager';
import type { Parse } from '../interface/Parse';
import { OtherBaseTemplateParser } from './OtherBaseTemplateParser';
import { LiveNavigationTemplate } from '../../data/template/LiveNavigationTemplate';
import { image } from '@kit.ImageKit';
import transResToPicHelper from '../utils/TransResToPicHelper';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveNavTemplateParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 导航模板解析器
 */
export class LiveNavigationTemplateParser extends OtherBaseTemplateParser implements Parse<LiveNavigationTemplate> {
  /**
   * 解析模板数据
   *
   * @param request 实况请求
   * @returns 模板数据
   */
  parse(request: NtfMgr.NotificationRequest): LiveNavigationTemplate {
    let extraInfo = request.content.liveView.extraInfo;
    let pictureInfo = request.content.liveView.pictureInfo;
    let data = new LiveNavigationTemplate();

    // 解析公有数据
    super.parseCommonData(request, data);

    // 解析扩展区数据
    const currentNavigationIcon: Array<image.PixelMap> = pictureInfo?.['NavigationLayout.currentNavigationIcon'];
    if (CommonUtils.isInvalid(currentNavigationIcon) || currentNavigationIcon.length <= 0) {
      log.showInfo('currentNavigationIcon invalid.');
    } else {
      data.setCurrNavDirectionIcon(currentNavigationIcon[0]);
    }

    const iconUpdateKey = extraInfo.ExtraInfoUpdateKey as Array<string>;
    if (transResToPicHelper.needParsePic(iconUpdateKey, 'NavigationLayout.currentNavigationIcon.res')) {
      data.setCurrNavDirectionIconRes(extraInfo?.['NavigationLayout.currentNavigationIcon.res'] as string);
      const images: image.PixelMap[] = extraInfo?.liveImages?.['NavigationLayout.currentNavigationIcon.res'];
      this.setImageFromParser(data, 'currNavDirectionIcon', images);
    }

    const navigationIcons: Array<image.PixelMap> = pictureInfo?.['NavigationLayout.navigationIcons'];
    if (CommonUtils.isInvalid(navigationIcons) || navigationIcons.length <= 0) {
      log.showInfo('navigationIcons invalid.');
    } else {
      data.setNavDirectionIconsFromPixel(navigationIcons);
    }

    if (transResToPicHelper.needParsePic(iconUpdateKey, 'NavigationLayout.navigationIcons.res')) {
      data.setNavDirectionIconsRes(extraInfo?.['NavigationLayout.navigationIcons.res'] as string[]);
      data.setNavDirectionIconsFromPixel(extraInfo?.liveImages?.['NavigationLayout.navigationIcons.res'] as image.PixelMap[]);
    }

    data.setIsNavigationIconsDisplayed(extraInfo['NavigationLayout.isNavigationIconsDisplayed'] as boolean);
    data.setDisplayHorizontalLine(extraInfo['FlightLayout.isDisplayHorizontalLine'] as boolean);

    return data;
  }
}