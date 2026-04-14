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

import { LengthMetrics } from '@kit.ArkUI';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { ImmCardData } from '../../../model/data/v2/ImmCardData';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';

/**
 * 沉浸大卡返回按钮组件
 */
@ComponentV2
export struct ImmCardBackBtnView {
  // 沉浸模块通用业务能力注入器
  @Consumer() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.defaultNtfInjector;

  // 大卡条目数据
  @Require @Param cardData: ImmCardData;

  // 沉浸大卡业务管理器
  private cardVm: IImmersiveCardVm = this.ntfVmInjector?.getImmersiveCardVm();

  // 大卡item布局返回按钮样式
  @Computed get backStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_BACK_STYLE);
    return helper?.getItemSt(this.cardData?.getCardShowType());
  }

  build() {
    EffectComponent() {
      Stack() {
        // 模糊背景
        Column()
          .width('100%')
          .height('100%')
          .useEffect(true)

        // 提亮背景
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(this.backStyle?.getBgColor())
          .backgroundBrightnessInternal(this.backStyle?.getBgBrightnessInner())

        // 返回按钮图标
        Image($r('app.media.chevron_backward'))
          .width(this.backStyle?.getWidth())
          .height(this.backStyle?.getHeight())
          .matchTextDirection(true)
          .foregroundColor(this.backStyle?.getFgColor())
          .foregroundBrightness(this.backStyle?.getFgBrightness())
      }
      .clip(true)
      .width(this.backStyle?.getBgWidth())
      .height(this.backStyle?.getBgHeight())
      .borderRadius(this.backStyle?.getBorderRadiusTL())
      .accessibilityLevel(this.backStyle?.getAccessibilityLevel())
      .accessibilityText(this.backStyle?.getAccessibilityText())
      .onClick(() => {
        this.cardVm?.onBackBtnClick?.(this.cardData);
      })
    }
    .backgroundEffect(this.backStyle?.getBgEffect())
    .visibility(this.backStyle?.getVisibility())
    .opacity(this.backStyle?.getAlpha())
    // 绝对坐标
    .position({
      start: LengthMetrics.vp(this.backStyle?.getMarginL()),
      top: LengthMetrics.vp(this.backStyle?.getMarginT())
    })
  }
}