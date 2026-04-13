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
import { LiveExtensionType } from '@ohos/systemuicommon/newTsIndex';
import { CardShowType, CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { IImmCardLiveOtherExtendVm } from '../../../common/interface/IImmCardLiveOtherExtendVm';
import { ImmCardData } from '../../../model/data/v2/ImmCardData';
import { ImmCardDataArray } from '../../../model/data/v2/ImmCardDataArray';
import { ImmersiveLiveOtherExtendVm } from './ImmersiveLiveOtherExtendVm';

/**
 * 沉浸大卡中实况三方卡片扩展辅助区业务管理器
 */
@ObservedV2
export class ImmCardLiveOtherExtendVm extends ImmersiveLiveOtherExtendVm implements IImmCardLiveOtherExtendVm {
  // 卡片数据集
  @Computed get cardDataArr(): ImmCardDataArray | undefined {
    return this.ntfInjector?.getImmersiveCardVm()?.getSlCardData();
  }

  // 当前卡片数据
  @Computed get cardData(): ImmCardData | undefined {
    return this.cardDataArr?.findCardData(this.live?.groupKey);
  }

  @Computed get extStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_STYLE);
    return styleH?.getItemSt(CardShowType.CARD_CONTENT);
  }

  @Computed get extWantStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_WANT_STYLE);
    return styleH?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 扩展区文本样式
  @Computed get extTextStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_TEXT_STYLE);
    return styleH?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 扩展区按钮样式
  @Computed get extBtnStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_BTN_STYLE);
    return styleH?.getItemSt(CardShowType.CARD_CONTENT);
  }

  // 扩展区通用透明度
  @Computed get opacity(): number | undefined {
    if (this.card.extensionType === LiveExtensionType.CAPSULE_TEXT) {
      return undefined;
    }
    if (this.cardData?.hasExtWant()) {
      return this.extWantStyle?.getAlpha();
    }
    // 其他情况使用扩展区通用透明度
    return this.extStyle?.getAlpha();
  }

  // 扩展区文本颜色
  @Computed get textColor(): ResourceColor | undefined {
    return this.extTextStyle?.getFontColor() ?? super.textColor;
  }

  // 扩展区文本前景模糊
  @Computed get fontFgBrightness(): BrightnessOptions | undefined {
    return this.extTextStyle?.getFgBrightness() ?? super.fontFgBrightness;
  }

  // 扩展区按钮背景颜色
  @Computed get buttonBgColor(): ResourceColor | undefined {
    return this.extBtnStyle?.getBgColor() ?? super.buttonBgColor;
  }

  // 扩展区按钮背景模糊
  @Computed get buttonBgBrightness(): BrightnessOptions | undefined {
    return this.extBtnStyle?.getBgBrightnessInner() ?? super.buttonBgBrightness;
  }

  // 扩展区按钮文本透明度
  @Computed get buttonTextOpacity(): number | undefined {
    return this.extBtnStyle?.getAlpha();
  }
}