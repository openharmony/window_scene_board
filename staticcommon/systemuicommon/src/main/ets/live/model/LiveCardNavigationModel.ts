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

import type { image } from '@kit.ImageKit';
import { LiveCardOtherModel } from './LiveCardOtherModel';
import { LiveCardType } from './LiveCommonModel';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';

/**
 * 导航类三方实况卡片数据
 */
export class LiveCardNavigationModel extends LiveCardOtherModel {
  readonly cardType: LiveCardType = LiveCardType.NAVIGATION;

  /**
   * 当前导航方向
   */
  layoutCurrentNavigationIcon?: image.PixelMap;
  /**
   * 扩展区导航方向的箭头集合图片，支持2-6个
   */
  layoutNavigationIcons?: image.PixelMap[];
  /**
   * 是否展示导航方向的箭头集合图片
   */
  layoutIsNavigationIconsDisplayed: boolean = true;
  /**
   * 是否显示扩展区分割线
   */
  layoutIsDisplayHorizontalLine: boolean = true;
  /**
   * 导航方向图片类型
   */
  layoutNavigationIconMimeType: string;

  releaseImages(newCard?: LiveCardNavigationModel): void {
    super.releaseImages(newCard);
    SystemUICommonUtil.releaseImage(this.layoutCurrentNavigationIcon, newCard?.layoutCurrentNavigationIcon);
    this.layoutNavigationIcons?.forEach((icon, index) => {
      SystemUICommonUtil.releaseImage(icon, newCard?.layoutNavigationIcons?.[index]);
    });
  }
}