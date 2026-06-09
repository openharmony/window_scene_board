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
import { CardShowType, CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { IImmCardLiveOtherFlightVm } from '../../../common/interface/IImmCardLiveOtherFlightVm';
import { ImmersiveLiveOtherFlightVm } from './ImmersiveLiveOtherFlightVm';

/**
 * 沉浸大卡中实况三方卡片左右卡片类型扩展区业务管理器
 */
@ObservedV2
export class ImmCardLiveOtherFlightVm extends ImmersiveLiveOtherFlightVm implements IImmCardLiveOtherFlightVm {
  // 标题文本样式state
  @Computed
  get cardMainTextStyleState(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_MAIN_TEXT_STYLE);
    return helper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 内容文本样式state
  @Computed
  get cardSecondaryTextStyleState(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_SECONDARY_TEXT_STYLE);
    return helper?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 标题样式
  @Computed
  get layoutTitleColor(): ResourceColor | undefined {
    return this.cardMainTextStyleState?.getFontColor() ?? super.layoutTitleColor;
  }

  // 内容样式
  @Computed
  get layoutContentColor(): ResourceColor | undefined {
    return this.cardSecondaryTextStyleState?.getFontColor() ?? super.layoutContentColor;
  }

  // 航班模板空白文本颜色
  @Computed
  get layoutSpaceTextColor(): ResourceColor {
    return this.cardMainTextStyleState?.getFontColor() ?? super.layoutSpaceTextColor;
  }

  // 航班模板空白边框颜色
  @Computed
  get layoutSpaceTextBorderColor(): ResourceColor {
    return this.cardSecondaryTextStyleState?.getFontColor() ?? super.layoutSpaceTextBorderColor;
  }

  // 航班模板中间摘要文本颜色
  @Computed
  get layoutAdditionalTextColor(): ResourceColor {
    return this.cardSecondaryTextStyleState?.getFontColor() ?? super.layoutAdditionalTextColor;
  }
}