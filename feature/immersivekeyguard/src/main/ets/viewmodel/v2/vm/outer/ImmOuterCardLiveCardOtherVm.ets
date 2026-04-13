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

import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { LiveRichTextModel } from '@ohos/systemuicommon/newTsIndex';
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { CardStyleSuffix } from '../../../../common/constants/ImmCardConst';
import { ImmCardLiveCardOtherVm } from '../ImmCardLiveCardOtherVm';

/**
 * 小外屏沉浸大卡中实况三方卡片业务管理器
 */
@ObservedV2
export class ImmOuterCardLiveCardOtherVm extends ImmCardLiveCardOtherVm {
  // 内容富文本样式
  @Computed
  get richTextStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelper()?.getCardStyleH(CardStyleSuffix.ITEM_LIVE_RICH_STYLE);
    return helper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  public getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined {
    // AOD颜色区分加粗文字，其他场景继承
    if (richText.textColor) {
      return this.richTextStyle?.getFontColor() ?? richText.textColor;
    }
    return super.getContentFontColor(richText);
  }
}