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

import type { image } from '@kit.ImageKit';
import { LiveCardType, LiveIndicatorType, LiveLineType } from './LiveCommonModel';
import { LiveCardOtherModel } from './LiveCardOtherModel';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';

/**
 * 进度类三方实况卡片数据
 */
export class LiveCardProgressModel extends LiveCardOtherModel {
  readonly cardType: LiveCardType = LiveCardType.PROGRESS;

  /**
   * 扩展区进度百分比
   */
  layoutProgress: number;
  /**
   * 扩展区进度条颜色
   */
  layoutColor?: string;
  /**
   * 扩展区进度条背景颜色
   */
  layoutBackgroundColor?: string;
  /**
   * 扩展区指示器小图标显示类型，默认不显示指示器小图标。
   */
  layoutIndicatorType: LiveIndicatorType = LiveIndicatorType.UNDISPLAYED;
  /**
   * 扩展区中间间隔图标
   */
  layoutIndicatorIcon?: image.PixelMap;
  /**
   * 扩展区进度条显示类型
   */
  layoutLineType: LiveLineType = LiveLineType.DOTTED_LINE;
  /**
   * 扩展区进度条每个节点图标，数组长度范围为[2, 5]
   */
  layoutNodeIcons?: image.PixelMap[];

  releaseImages(newCard?: LiveCardProgressModel): void {
    super.releaseImages(newCard);
    SystemUICommonUtil.releaseImage(this.layoutIndicatorIcon, newCard?.layoutIndicatorIcon);
    this.layoutNodeIcons?.forEach((icon, index) => {
      SystemUICommonUtil.releaseImage(icon, newCard?.layoutNodeIcons?.[index]);
    });
  }

  toString(): string {
    return 'LiveCardProgressModel' +
      '{ progress:' + this.layoutProgress +
      ', color:' + this.layoutColor +
      ', backgroundColor:' + this.layoutBackgroundColor +
      ', indicatorType:' + this.layoutIndicatorType +
      ', lineType:' + this.layoutLineType +
      '}';
  }
}