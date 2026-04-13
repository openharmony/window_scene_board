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

import { LiveExtendType } from '../../common/LiveConstants';
import type { ILiveExtendData } from '../../common/ILiveExtendData';
import { BaseExtendProperty } from '../../../base/common/info/BaseExtendProperty';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';

/**
 * 实况卡片、胶囊扩展数据，计时器信息
 */
@Observed
export class LiveCapsuleStyle extends BaseExtendProperty implements ILiveExtendData {
  /**
   * 胶囊外边缘宽度
   * 可选场景：单胶囊默认态、多胶囊默认态、胶囊拓展态
   */
  borderWidth: number = LiveViewCapsuleStyle.CAPSULE_BORDER_WIDTH;
  /**
   * 胶囊内图标间距
   * 可选场景：单胶囊、多胶囊
   */
  iconSpace: number = LiveViewCapsuleStyle.CAPSULE_ICON_LEFT_MARGIN;
  /**
   * 胶囊图片左对齐
   * 可选场景：单胶囊、多胶囊
   */
  imageMarginLeft: number = LiveViewCapsuleStyle.CAPSULE_ICON_LEFT_MARGIN;
  /**
   * 胶囊阴影默认颜色
   * 可选场景：默认阴影、录屏阴影
   */
  shadowColor: string = LiveViewCapsuleStyle.CAPSULE_SHADOW_COLOR_BLACK;
  /**
   * 胶囊高度
   */
  height: number = LiveViewCapsuleStyle.CAPSULE_HEIGHT;
  /**
   * 胶囊主文本区宽度
   */
  mainTextWidth: number = LiveViewCapsuleStyle.CAPSULE_MAIN_TEXT_WIDTH;
  /**
   * 胶囊副文本区宽度
   */
  negativeTextWidth: number = LiveViewCapsuleStyle.CAPSULE_EXTEND_TEXT_WIDTH;
  /**
   * 胶囊文本区高度
   */
  textHeight: number = LiveViewCapsuleStyle.CAPSULE_TEXT_HEIGHT;
  /**
   * 胶囊图片宽度
   */
  imageWidth: number = LiveViewCapsuleStyle.CAPSULE_IMAGE_WIDTH;
  /**
   * 胶囊图片高度
   */
  imageHeight: number = LiveViewCapsuleStyle.CAPSULE_IMAGE_HEIGHT;
  /**
   * 胶囊外边缘弧度
   */
  radius: number = LiveViewCapsuleStyle.CAPSULE_RADIUS;
  /**
   * 胶囊文字大小
   */
  textFontSize: number = LiveViewCapsuleStyle.TEXT_FONT_SIZE;
  /**
   * 胶囊文字左对齐
   */
  textMarginLeft: number = LiveViewCapsuleStyle.TEXT_MARGIN_LEFT;

  /**
   * 阴影胶囊左对齐
   */
  shadowLeftMargin: number = LiveViewCapsuleStyle.CAPSULE_SHADOW_LEFT_MARGIN;

  /**
   * 胶囊文字颜色
   */
  textColor: string = LiveViewCapsuleStyle.CAPSULE_TEXT_COLOR;

  /**
   * 复写接口ILiveExtendData
   *
   * @returns 计时器类型
   */
  getLiveExtendType(): LiveExtendType {
    return LiveExtendType.TYPE_CAPSULE_STYLE;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof LiveCapsuleStyle) && !forceRefresh) {
      return;
    }
    let otherStyle = other as LiveCapsuleStyle;
    ObjectCopyUtil.deepClone(otherStyle, this);
  }
}