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
import { LivePickUpTemplate } from '../../data/template/LivePickUpTemplate';
import type { Parse } from '../interface/Parse';
import transResToPicHelper from '../utils/TransResToPicHelper';
import { OtherBaseTemplateParser } from './OtherBaseTemplateParser';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LivePickUpTemplateParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 强文本类模板解析器
 */
export class LivePickUpTemplateParser extends OtherBaseTemplateParser implements Parse<LivePickUpTemplate> {
  /**
   * 解析模板数据
   *
   * @param request 实况请求
   * @returns 模板数据
   */
  parse(request: NtfMgr.NotificationRequest): LivePickUpTemplate {
    let extraInfo = request.content.liveView.extraInfo;
    let pictureInfo = request.content.liveView.pictureInfo;
    let data = new LivePickUpTemplate();
    // 解析公有数据
    super.parseCommonData(request, data);
    // 解析扩展区数据
    data.setExtendTitle(extraInfo['PickupLayout.title'] as string);
    data.setExtendContent(extraInfo['PickupLayout.content'] as string);
    data.setUnderlineColor(extraInfo['PickupLayout.underlineColor'] as string);
    data.setProviderName(extraInfo['PrimaryData.providerName'] as string);
    let icons: Array<image.PixelMap> = pictureInfo?.['PickupLayout.descPic'];
    if (!CommonUtils.isInvalid(icons) && icons.length > 0) {
      data.setDescPic(icons[0]);
    }

    const iconUpdateKey = extraInfo.ExtraInfoUpdateKey as Array<string>;
    if (transResToPicHelper.needParsePic(iconUpdateKey, 'PickupLayout.descPic.res')) {
      data.setDescPicRes(extraInfo['PickupLayout.descPic.res'] as string);
      const images: image.PixelMap[] = extraInfo.liveImages?.['PickupLayout.descPic.res'];
      this.setImageFromParser(data, 'descPic', images);
    }
    return data;
  }
}