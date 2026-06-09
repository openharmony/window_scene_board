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

import { IImmCardLiveCardOtherVm } from '../../../common/interface/IImmCardLiveCardOtherVm';
import { ImmersiveLiveCardOtherVm } from './ImmersiveLiveCardOtherVm';
import { CardShowType, CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { LiveRichTextModel } from '@ohos/systemuicommon/newTsIndex';

/**
 * 沉浸大卡中实况三方卡片业务管理器
 */
@ObservedV2
export class ImmCardLiveCardOtherVm extends ImmersiveLiveCardOtherVm implements IImmCardLiveCardOtherVm {
  // 沉浸大卡屏蔽图标显示
  public isHideAppIcon: boolean = true;

  // 标题文本样式state
  @Computed
  get cardMainTextStyleState(): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelper()?.getCardStyleH(CardStyleSuffix.ITEM_MAIN_TEXT_STYLE);
    return helper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 内容文本样式state
  @Computed
  get cardSecondaryTextStyleState(): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelper()?.getCardStyleH(CardStyleSuffix.ITEM_SECONDARY_TEXT_STYLE);
    return helper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 三方实况扩展区样式
  @Computed
  get extStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelper()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_STYLE);
    return helper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 标题文本颜色
  @Computed
  get titleFontColor(): ResourceColor | undefined {
    // AOD颜色，非AOD复用
    return this.cardMainTextStyleState?.getFontColor() ?? super.titleFontColor;
  }

  // 标题字重
  @Computed
  get titleFontWeight(): number | FontWeight | string | undefined {
    return this.cardMainTextStyleState?.getFontWeight();
  }

  // 内容文本颜色
  @Computed
  get contentFontColor(): ResourceColor | undefined {
    return this.cardSecondaryTextStyleState?.getFontColor() ?? super.contentFontColor;
  }

  // 文本字号
  @Computed
  get contentTextFontSize(): Length | undefined {
    return this.cardSecondaryTextStyleState?.getFontSize();
  }

  // 扩展区透明度
  @Computed
  get extendOpacity(): number | undefined {
    return this.extStyle?.getAlpha() ?? super.extendOpacity;
  }

  public getContentFontWeight(richText: LiveRichTextModel): FontWeight {
    return richText.textColor ? FontWeight.Bold : FontWeight.Regular;
  }

  public getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined {
    // AOD颜色区分加粗文字
    if (richText.textColor) {
      return this.cardMainTextStyleState?.getFontColor() ?? super.getContentFontColor(richText);
    }
    return this.cardSecondaryTextStyleState?.getFontColor() ?? super.getContentFontColor(richText);
  }
}