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
import { LiveCardType, LiveRichTextModel } from './LiveCommonModel';
import { LiveCardOtherModel } from './LiveCardOtherModel';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';

/**
 * 比分类三方实况卡片数据
 */
export class LiveCardScoreModel extends LiveCardOtherModel {
  readonly cardType: LiveCardType = LiveCardType.SCORE;

  /**
   * 扩展区左侧名称
   */
  layoutHostName: string;
  /**
   * 扩展区左侧图标
   */
  layoutHostIcon?: image.PixelMap;
  /**
   * 扩展区左侧比分
   */
  layoutHostScore: string;
  /**
   * 扩展区右侧名称
   */
  layoutGuestName: string;
  /**
   * 扩展区右侧图标
   */
  layoutGuestIcon?: image.PixelMap;
  /**
   * 扩展区右侧比分
   */
  layoutGuestScore: string;
  /**
   * 扩展区中间上方描述文本，比赛介绍
   */
  layoutCompetitionDesc: LiveRichTextModel[];
  /**
   * 扩展区中间下方比赛时间
   */
  layoutCompetitionTime: string;
  /**
   * 是否显示扩展区分割线
   */
  layoutIsDisplayHorizontalLine: boolean;

  releaseImages(newCard?: LiveCardScoreModel): void {
    super.releaseImages(newCard);
    SystemUICommonUtil.releaseImage(this.layoutHostIcon, newCard?.layoutHostIcon);
    SystemUICommonUtil.releaseImage(this.layoutGuestIcon, newCard?.layoutGuestIcon);
  }
}