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

import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { LiveRichTextModel } from '@ohos/systemuicommon/newTsIndex';
import { IImmCardLiveNavigationVm } from '../../../common/interface/IImmCardLiveNavigationVm';
import { ImmersiveLiveNavigationVm } from './ImmersiveLiveNavigationVm';
import { CardShowType, CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { ImmCardData } from '../../../model/data/v2/ImmCardData';
import { ImmCardDataArray } from '../../../model/data/v2/ImmCardDataArray';

/**
 * 沉浸大卡中实况导航卡片业务管理器
 */
@ObservedV2
export class ImmCardLiveNavigationVm extends ImmersiveLiveNavigationVm implements IImmCardLiveNavigationVm {
  // 沉浸大卡屏蔽图标显示
  public isHideAppIcon: boolean = true;

  // 卡片数据集
  @Computed get cardDataArr(): ImmCardDataArray | undefined {
    return this.ntfInjector?.getImmersiveCardVm()?.getSlCardData();
  }

  // 当前卡片数据
  @Computed get cardData(): ImmCardData | undefined {
    return this.cardDataArr?.findCardData(this.live?.groupKey);
  }

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

  // 标题文本颜色
  @Computed
  get titleFontColor(): ResourceColor | undefined {
    return this.cardMainTextStyleState?.getFontColor() ?? super.titleFontColor;
  }

  // 标题文本字号
  @Computed
  get mainNavInfoSize(): Length | undefined {
    return this.cardMainTextStyleState?.getFontSize();
  }

  // 标题文本字重
  @Computed
  get mainNavInfoWeight(): number | FontWeight | string | undefined {
    return this.cardMainTextStyleState?.getFontWeight();
  }

  // 内容文本字号
  @Computed
  get viceNavInfoSize(): Length | undefined {
    return this.cardSecondaryTextStyleState?.getFontSize();
  }

  // 内容文本字重
  @Computed
  get viceNavInfoColor(): ResourceColor | undefined {
    return this.cardSecondaryTextStyleState?.getFontColor() ?? super.viceNavInfoColor;
  }

  // 内容文本颜色
  public getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined {
    // AOD颜色区分加粗文字
    if (richText.textColor) {
      return this.cardMainTextStyleState?.getFontColor() ?? super.getContentFontColor(richText);
    }
    return this.cardSecondaryTextStyleState?.getFontColor() ?? super.getContentFontColor(richText);
  }
}