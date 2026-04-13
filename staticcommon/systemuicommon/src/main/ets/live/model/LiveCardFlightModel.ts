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
import { FlightLayoutSpaceType } from '../../liveview/common/LiveConstants';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { LiveWeatherModel } from './LiveWeatherModel';

/**
 * 航班类三方实况卡片数据
 */
export class LiveCardFlightModel extends LiveCardOtherModel {
  readonly cardType: LiveCardType = LiveCardType.FLIGHT;

  /**
   * 扩展区左侧标题
   */
  layoutFirstTitle: string;
  /**
   * 扩展区左侧内容
   */
  layoutFirstContent: string;
  /**
   * 扩展区右侧标题
   */
  layoutLastTitle: string;
  /**
   * 扩展区右侧内容
   */
  layoutLastContent: string;
  /**
   * 扩展区右侧标题的右上角展示跨天"+X"
   */
  layoutLastTitleSuperscript?: string;
  /**
   * 扩展区右侧内容的右上角展示跨天"+X"
   */
  layoutLastContentSuperscript?: string;
  /**
   * 扩展区中间的显示类型
   */
  layoutSpaceType?: FlightLayoutSpaceType;
  /**
   * 扩展区中间间隔图标
   */
  layoutSpaceIcon: image.PixelMap;
  /**
   * 扩展区中间间隔图标资源路径
   */
  layoutSpaceIconRes?: string;
  /**
   * 扩展区中间的文本内容
   */
  layoutSpaceText?: string;
  /**
   * 是否显示扩展区分割线，默认显示分割线。
   */
  layoutIsDisplayHorizontalLine: boolean;
  /**
   * 扩展区底部内容
   */
  layoutAdditionalText?: string;
  /**
   * 天气胶囊信息
   */
  liveCardWeatherInfo?: LiveWeatherModel;

  releaseImages(newCard?: LiveCardFlightModel): void {
    super.releaseImages(newCard);
    SystemUICommonUtil.releaseImage(this.layoutSpaceIcon, newCard?.layoutSpaceIcon);
  }
}