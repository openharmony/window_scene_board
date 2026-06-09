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
import { LiveCardOtherModel } from './LiveCardOtherModel';
import { LiveCardType } from './LiveCommonModel';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';

/**
 * 取餐类三方实况卡片数据
 */
export class LiveCardPickupModel extends LiveCardOtherModel {
  readonly cardType: LiveCardType = LiveCardType.PICK_UP;

  /**
   * 扩展区标题
   */
  layoutTitle: string;
  /**
   * 扩展区内容
   */
  layoutContent: string;
  /**
  /**
   * 展区内容下划线颜色，默认不显示下划线
   */
  layoutUnderlineColor?: string;
  /**
   * 扩展区右侧产品描述图
   */
  layoutDescPic: image.PixelMap;
  /**
   * 扩展区右下角提供商名称
   */
  layoutProviderName?: string;

  releaseImages(newCard?: LiveCardPickupModel): void {
    super.releaseImages(newCard);
    SystemUICommonUtil.releaseImage(this.layoutDescPic, newCard?.layoutDescPic);
  }
}