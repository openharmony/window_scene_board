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
import { LiveWeatherModel} from '../../../live/model/LiveWeatherModel';
import { FlightLayoutSpaceType, LiveIconName, LiveType } from '../../common/LiveConstants';
import { OtherBaseTemplate } from './OtherBaseTemplate';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveFlightTemplate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况卡片模板，左右文本类型模板
 */
@Observed
export class LiveFlightTemplate extends OtherBaseTemplate {
  /**
   * 扩展区左侧标题
   */
  firstTitle?: string;

  /**
   * 扩展区左侧内容
   */
  firstContent?: string;

  /**
   * 扩展区右侧标题
   */
  lastTitle?: string;

  /**
   * 扩展区右侧内容
   */
  lastContent?: string;

  /**
   * 扩展区右侧标题的右上角展示跨天"+X"
   */
  lastTitleSuperscript?: string;

  /**
   * 扩展区右侧内容的右上角展示跨天"+X"
   */
  lastContentSuperscript?: string;

  /**
   * 扩展区中间的显示类型
   */
  spaceType?: FlightLayoutSpaceType;

  /**
   * 扩展区中间间隔图标
   */
  spaceIcon?: image.PixelMap;

  /**
   * 扩展区中间间隔图标资源路径
   */
  spaceIconRes?: string;

  /**
   * 扩展区中间的文本内容
   */
  spaceText?: string;

  /**
   * 是否显示扩展区分割线
   */
  isDisplayHorizontalLine?: boolean = true;

  /**
   * 补充说明文字
   */
  additionalText?: string;

  /**
   * 天气信息
   */
  liveCardWeatherInfo?: LiveWeatherModel;

  /**
   * 复写接口ILiveTemplateData
   *
   * @returns 实况类型
   */
  getLiveType(): LiveType {
    return LiveType.FLIGHT;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    super.update(other, forceRefresh);
    if (!(other instanceof LiveFlightTemplate)) {
      return;
    }
    let otherTemplate = other as LiveFlightTemplate;
    this.setFirstTitle(otherTemplate.firstTitle, forceRefresh);
    this.setFirstContent(otherTemplate.firstContent, forceRefresh);
    this.setLastTitle(otherTemplate.lastTitle, forceRefresh);
    this.setLastContent(otherTemplate.lastContent, forceRefresh);
    this.setLastTitleSuperscript(otherTemplate.lastTitleSuperscript, forceRefresh);
    this.setLastContentSuperscript(otherTemplate.lastContentSuperscript, forceRefresh);
    this.setSpaceType(otherTemplate.spaceType, forceRefresh);
    this.setSpaceText(otherTemplate.spaceText, forceRefresh);
    this.setSpaceIcon(otherTemplate.spaceIcon, forceRefresh || otherTemplate.clearImgForUpdate[LiveIconName.SPACE_ICON_NAME]);
    this.setSpaceIconRes(otherTemplate.spaceIconRes, forceRefresh);
    this.setDisplayHorizontalLine(otherTemplate.isDisplayHorizontalLine, forceRefresh);
    this.setAdditionalText(otherTemplate.additionalText, forceRefresh);
    this.setWeatherInfo(otherTemplate.liveCardWeatherInfo);
  }

  /**
   * 设置隐私说明文案
   *
   * @param firstTitle 标题
   * @param forceRefresh 是否强制刷新
   */
  setAdditionalText(additionalText?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(additionalText)) {
      this.additionalText = additionalText;
    }
  }

  /**
   * 设置扩展区左侧标题
   *
   * @param firstTitle 标题
   * @param forceRefresh 是否强制刷新
   */
  setFirstTitle(firstTitle?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(firstTitle)) {
      this.firstTitle = firstTitle;
    }
  }

  /**
   * 设置扩展区左侧内容
   *
   * @param firstContent 内容
   * @param forceRefresh 是否强制刷新
   */
  setFirstContent(firstContent?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(firstContent)) {
      this.firstContent = firstContent;
    }
  }

  /**
   * 设置扩展区右侧标题
   *
   * @param lastTitle 右侧标题
   * @param forceRefresh 是否强制刷新
   */
  setLastTitle(lastTitle?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(lastTitle)) {
      this.lastTitle = lastTitle;
    }
  }

  /**
   * 设置扩展区右侧内容
   *
   * @param lastContent 右侧内容
   * @param forceRefresh 是否强制刷新
   */
  setLastContent(lastContent?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(lastContent)) {
      this.lastContent = lastContent;
    }
  }

  /**
   * 设置扩展区右侧标题的右上角展示跨天"+X"
   */
  setLastTitleSuperscript(lastTitleSuperscript?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(lastTitleSuperscript)) {
      this.lastTitleSuperscript = lastTitleSuperscript;
    }
  }

  /**
   * 设置扩展区右侧内容的右上角展示跨天"+X"
   */
  setLastContentSuperscript(lastContentSuperscript?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(lastContentSuperscript)) {
      this.lastContentSuperscript = lastContentSuperscript;
    }
  }

  /**
   * 设置扩展区中间的显示类型
   */
  setSpaceType(spaceType?: FlightLayoutSpaceType, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(spaceType)) {
      this.spaceType = spaceType;
    }
  }

  /**
   * 设置扩展区中间间隔图标
   *
   * @param spaceIcon 扩展区中间间隔图标
   * @param forceRefresh 是否强制刷新
   */
  setSpaceIcon(spaceIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(spaceIcon)) {
      if (this.spaceIcon === spaceIcon) {
        return;
      }
      this.spaceIcon?.release();
      this.spaceIcon = spaceIcon;
    }
  }

  /**
   * 设置扩展区中间间隔图标资源路径
   *
   * @param spaceIconRes 扩展区中间间隔图标资源路径
   * @param forceRefresh 是否强制刷新
   */
  setSpaceIconRes(spaceIconRes?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(spaceIconRes)) {
      this.spaceIconRes = spaceIconRes;
    }
  }

  /**
   * 设置扩展区中间的文本内容
   */
  setSpaceText(spaceText?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(spaceText)) {
      this.spaceText = spaceText;
    }
  }

  /**
   * 设置是否显示扩展区分割线
   *
   * @param isDisplayHorizontalLine 是否显示扩展区分割线
   * @param forceRefresh 是否强制刷新
   */
  setDisplayHorizontalLine(isDisplayHorizontalLine?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isDisplayHorizontalLine)) {
      this.isDisplayHorizontalLine = isDisplayHorizontalLine;
    }
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    super.releaseImages();
    if (this.spaceIconRes) {
      log.showInfo('release spaceIcon');
      this.spaceIcon?.release();
    }
  }

  setWeatherInfo(weatherInfo?: LiveWeatherModel): void {
    this.liveCardWeatherInfo = weatherInfo;
  }
}