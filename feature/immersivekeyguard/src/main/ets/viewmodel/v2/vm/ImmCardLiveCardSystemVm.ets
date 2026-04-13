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

import { IImmCardLiveCardSystemVm } from '../../../common/interface/IImmCardLiveCardSystemVm';
import { ImmCardData } from '../../../model/data/v2/ImmCardData';
import { ImmCardDataArray } from '../../../model/data/v2/ImmCardDataArray';
import { ImmersiveLiveCardSystemVm } from './ImmersiveLiveCardSystemVm';
import { CardShowType, CardStyleSuffix } from '../../../common/constants/ImmCardConst'
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';

/**
 * 系统实况大卡业务管理器
 */
@ObservedV2
export class ImmCardLiveCardSystemVm extends ImmersiveLiveCardSystemVm implements IImmCardLiveCardSystemVm {
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
    let helper = this.vmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_SYS_MAIN_TEXT_STYLE);
    return helper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 内容文本样式state
  @Computed
  get cardSecondaryTextStyleState(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_SYS_SECONDARY_TEXT_STYLE);
    return helper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 标题文本颜色
  @Computed
  get titleFontColor(): ResourceColor | undefined {
    return this.cardMainTextStyleState?.getFontColor() ?? super.titleFontColor;
  }

  // 内容文本颜色
  @Computed
  get textFontColor(): ResourceColor | undefined {
    return this.cardSecondaryTextStyleState?.getFontColor() ?? super.textFontColor;
  }

  // 文本字号
  @Computed
  get textFontSize(): Length | undefined {
    return this.cardSecondaryTextStyleState?.getFontSize();
  }

  // 标题
  @Computed
  get title(): ResourceStr {
    let extTitle = this.cardData?.getExtTitle();
    if (extTitle) {
      return extTitle;
    }
    return super.title;
  }

  // 内容
  @Computed
  get text(): ResourceStr {
    let extText = this.cardData?.getExtContent();
    if (extText) {
      return extText;
    }
    return super.text;
  }

  // 沉浸态不显示按钮
  @Computed
  get hasActionButtons(): boolean {
    return false;
  }

  // 沉浸态不显示按钮
  @Computed
  get isShowActionButtons(): boolean {
    return false;
  }
}