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
import { LiveButtonArray } from '../../data/extend/LiveButtonData';
import { LiveProgressTemplate } from '../../data/template/LiveProgressTemplate';
import type { Parse } from '../interface/Parse';
import transResToPicHelper from '../utils/TransResToPicHelper';
import { OtherBaseTemplateParser } from './OtherBaseTemplateParser';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveProgressTemplateParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 进度类模板解析器
 */
export class LiveProgressTemplateParser extends OtherBaseTemplateParser implements Parse<LiveProgressTemplate> {
  /**
   * 解析模板数据
   *
   * @param request 实况请求
   * @returns 模板数据
   */
  parse(request: NtfMgr.NotificationRequest): LiveProgressTemplate {
    let extraInfo = request.content.liveView.extraInfo;
    let pictureInfo = request.content.liveView.pictureInfo;
    let data = new LiveProgressTemplate();
    // 解析公有数据
    super.parseCommonData(request, data);
    // 解析扩展区数据
    data.setProgress(extraInfo['ProgressLayout.progress'] as number);
    data.setColor(extraInfo['ProgressLayout.color'] as string);
    data.setBackgroundColor(extraInfo['ProgressLayout.backgroundColor'] as string);
    data.setLineType(extraInfo['ProgressLayout.lineType'] as number);
    data.setIndicatorType(extraInfo['ProgressLayout.indicatorType'] as number);
    let icons: Array<image.PixelMap> = pictureInfo?.['ProgressLayout.indicatorIcon'];
    if (!CommonUtils.isInvalid(icons) && icons.length > 0) {
      data.setIndicatorIcon(icons[0]);
    }

    const iconUpdateKey = extraInfo.ExtraInfoUpdateKey as Array<string>;
    if (transResToPicHelper.needParsePic(iconUpdateKey, 'ProgressLayout.indicatorIcon.res')) {
      log.showInfo('need to parse indicatorIcon.');
      data.setIndicatorIconRes(extraInfo['ProgressLayout.indicatorIcon.res'] as string);
      const images: image.PixelMap[] = extraInfo.liveImages?.['ProgressLayout.indicatorIcon.res'];
      this.setImageFromParser(data, 'indicatorIcon', images);
    }

    this.processNodeIcons(data, extraInfo, pictureInfo, iconUpdateKey);
    log.showInfo('parse:' + data.toString());
    return data;
  }

  private processNodeIcons(data: LiveProgressTemplate, extraInfo: { [key: string]: Object },
    pictureInfo: { [key: string]: Array<image.PixelMap> }, iconUpdateKey: Array<string>): void {
    let nodeIcons: Array<image.PixelMap> = pictureInfo?.['ProgressLayout.nodeIcons'];
    if (!CommonUtils.isInvalid(nodeIcons) && nodeIcons.length > 0) {
      let liveButtonArray: LiveButtonArray = new LiveButtonArray();
      liveButtonArray.setButtonArrayByIcons(nodeIcons);
      data.nodeIcons = liveButtonArray;
    }
    let nodeIconsRes: Array<string> = extraInfo['ProgressLayout.nodeIcons.res'] as Array<string>;
    if (CommonUtils.isInvalid(nodeIconsRes) || nodeIconsRes.length <= 0) {
      return;
    }

    if (transResToPicHelper.needParsePic(iconUpdateKey, 'ProgressLayout.nodeIcons.res')) {
      log.showInfo('need to parse nodeIcons.');
      data.setNodeIconsRes(nodeIconsRes);
      data.setNodeIcons(extraInfo.liveImages?.['ProgressLayout.nodeIcons.res'] as image.PixelMap[]);
    }
  }
}