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
import { LiveIconName, LiveType, LiveViewCommonConstants } from '../../common/LiveConstants';
import { OtherBaseTemplate } from './OtherBaseTemplate';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LivePickUpTemplate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况卡片模板，强文本类型模板
 */
@Observed
export class LivePickUpTemplate extends OtherBaseTemplate {
  /**
   * 扩展区标题, 如取餐码
   */
  extendTitle?: string;

  /**
   * 扩展区内容,如72988
   */
  extendContent?: string;

  /**
  * 扩展区内容下划线颜色，不提供默认颜色
  */
  underlineColor?: string;

  /**
   * 服务商提供信息
   */
  providerName?: string;

  /**
   * 扩展区右侧产品描述图片
   */
  descPic?: image.PixelMap;

  /**
   * 扩展区右侧产品描述图片资源路径
   */
  descPicRes?: string;

  /**
   * 复写接口ILiveTemplateData
   *
   * @returns 实况类型
   */
  getLiveType(): LiveType {
    return LiveType.PICK_UP;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    super.update(other, forceRefresh);
    if (!(other instanceof LivePickUpTemplate)) {
      return;
    }
    let otherTemplate = other as LivePickUpTemplate;
    this.setExtendTitle(otherTemplate.extendTitle, forceRefresh);
    this.setExtendContent(otherTemplate.extendContent, forceRefresh);
    this.setUnderlineColor(otherTemplate.underlineColor, forceRefresh);
    this.setProviderName(otherTemplate.providerName, forceRefresh);
    this.setDescPic(otherTemplate.descPic, forceRefresh || otherTemplate.clearImgForUpdate[LiveIconName.DESC_PIC_NAME]);
    this.setDescPicRes(otherTemplate.descPicRes, forceRefresh);
  }

  /**
   * 设置扩展区标题
   *
   * @param title 标题
   * @param forceRefresh 是否强制刷新
   */
  setExtendTitle(title?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(title)) {
      this.extendTitle = title;
    }
  }

  /**
   * 设置扩展区内容
   *
   * @param content 内容
   * @param forceRefresh 是否强制刷新
   */
  setExtendContent(content?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(content)) {
      this.extendContent = content;
    }
  }

  /**
   * 设置扩展区内容下划线颜色
   *
   * @param underlineColor 颜色
   * @param forceRefresh 是否强制刷新
   */
  setUnderlineColor(underlineColor?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(underlineColor)) {
      this.underlineColor = underlineColor;
    }
  }

  /**
   * 设置服务商提供信息
   *
   * @param providerName 服务商提供信息
   * @param forceRefresh 是否强制刷新
   */
  setProviderName(providerName?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(providerName)) {
      this.providerName = providerName;
    }
  }

  /**
   * 设置扩展区右侧产品描述图片
   *
   * @param descPic 图片
   * @param forceRefresh 是否强制刷新
   */
  setDescPic(descPic?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(descPic)) {
      if (this.descPic === descPic) {
        return;
      }
      this.descPic?.release();
      this.descPic = descPic;
    }
  }

  /**
   * 设置扩展区右侧产品描述图片资源路径
   *
   * @param descPic 图片资源路径
   * @param forceRefresh 是否强制刷新
   */
  setDescPicRes(descPicRes?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(descPicRes)) {
      this.descPicRes = descPicRes;
    }
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    super.releaseImages();
    if (this.descPicRes) {
      log.showInfo('release descPic');
      this.descPic?.release();
    }
  }
}