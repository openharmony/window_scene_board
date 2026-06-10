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

import { ImmersiveMediaCard } from '@ohos/mediacontrolcomponent';
import { SlWidgetId } from '@ohos/screenlockcommon';
import { IBaseState, SlComBinStPt } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { AccessibilityAppName } from '@ohos/systemuicommon/Index';
import { CardShowType } from '../../../common/constants/ImmCardConst';
import { CardAnimSuffix, CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmCardData } from '../../../model/data/v2/ImmCardData';
import { ImmCardDataArray } from '../../../model/data/v2/ImmCardDataArray';
import { SlCardBindStateV2 } from '../../../model/data/v2/SlCardBindStateV2';
import { SlCardStaticStateV2 } from '../../../model/data/v2/SlCardStaticStateV2';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';
import { ImmCardBackBtnView } from './ImmCardBackBtnView';
import { ImmCardComView } from './ImmCardComView';

/**
 * V2装饰器，大卡条目组件
 */
@ComponentV2
export struct ImmersiveCardItemView {
  // 沉浸模块通用业务能力注入器
  @Consumer() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.defaultNtfInjector;

  // 大卡条目数据
  @Require @Param cardData: ImmCardData;

  // 沉浸大卡业务管理器
  private cardVm: IImmersiveCardVm = this.ntfVmInjector?.getImmersiveCardVm();

  // 条目辅助工具
  private itemHelper: IImmItemHelperVm = this.ntfVmInjector?.getImmItemHelperVm();

  // 静态状态
  private staticSt: SlCardStaticStateV2 = this.cardVm?.getSlStaticState();

  // 锁屏通用UI绑定状态
  @Computed get slComBind(): IBaseState | undefined {
    return this.ntfVmInjector?.getPanelVm()?.getSlComBindState();
  }

  // 大卡UI绑定状态
  @Computed get bindSt(): SlCardBindStateV2 {
    return this.cardVm?.getSlBindState();
  }

  // 大卡root样式
  @Computed get rootStyle(): WidgetStyleStateV2 | undefined {
    return this.cardVm?.getSlStyleState();
  }

  // 大卡条目样式
  @Computed get itemStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.itemHelper?.getCardStyleH(CardStyleSuffix.ITEM_COMMON_STYLE);
    return helper?.getItemSt(this.cardData?.getCardShowType());
  }

  // 大卡条目背景样式
  @Computed get itemBgStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.itemHelper?.getCardStyleH(CardStyleSuffix.ITEM_BG_STYLE);
    return helper?.getItemSt(this.cardData?.getCardShowType());
  }

  // 大卡条目动效
  @Computed get itemAnim(): WidgetAnimStateV2 | undefined {
    let helper = this.itemHelper?.getCardAnimH(CardAnimSuffix.ITEM_COMMON_ANIM);
    return helper?.getItemSt(this.cardData?.getCardShowType());
  }

  @Builder
  private ItemContent() {
    // 内容保持固定大小
    Stack() {
      // 播控条目内容
      if (this.cardData?.isMediaCenter()) {
        ImmersiveMediaCard({
          notifyId: this.cardData?.getGroupKey(),
          cardStyle: {
            width: '100%',
            height: '100%'
          },
          isSmallFoldOuterScreen: this.staticSt?.isFoldOuter()
        })
      } else {
        // 通用条目内容
        ImmCardComView({ cardData: this.cardData })
      }

      // 返回按钮
      if (this.bindSt?.isBackBtnEnable()) {
        ImmCardBackBtnView({ cardData: this.cardData })
      }
    }
    .width(this.getStaticWidth())
    .height(this.getStaticHeight())
  }

  build() {
    Stack() {
      // 无障碍播报
      AccessibilityAppName({
        name: this.cardData?.getAppName(),
        isAccessibilityMode: this.isAccessibilityMode()
      })

      // 统一背景
      if (!this.bindSt?.isHideItemBg()) {
        Stack()
          .clip(true)
          .width('100%')
          .height('100%')
          .opacity(this.itemBgStyle?.getAlpha())
          .backgroundColor(this.itemStyle?.getBgColor())
          .backgroundBrightnessInternal(this.itemStyle?.getBgBrightnessInner())
      }

      this.ItemContent()
    }
    .onTouch((event?: TouchEvent) => {
      event?.stopPropagation();
    })
    .gestureModifier(this.itemStyle?.getGestureModifier())
    .clip(true)
    .enabled(this.isItemEnable())
    .zIndex(this.getItemZIndex())
    .visibility(this.getItemVisibility())
    .width(this.getClipWidth())
    .height(this.getClipHeight())
    .translate(this.getItemTran())
    .scale(this.getItemScale())
    .opacity(this.getItemAlpha())
    .pointLight(this.itemStyle?.getPointLight())
    .borderRadius(this.getClipBorderRadius())
    .onClick(this.getItemClick())
    .accessibilityGroup(true)
    .accessibilityLevel('yes')
    .id(SlWidgetId.IMMERSIVE_CARD_SHOW_AREA)
  }

  /**
   * 大卡条目点击事件
   *
   * @returns 点击事件
   */
  private getItemClick(): (() => void) | undefined {
    // 内部点击事件，外部清除
    if (this.bindSt?.isItemCLickInner() && !this.cardData?.isMediaCenter()) {
      return undefined;
    }
    return () => {
      this.cardVm?.onItemClick(this.cardData);
    };
  }

  private isItemEnable(): boolean {
    let isEnable = this.itemStyle?.isEnable() ?? true;
    if (this.itemAnim?.isWidgetAnimating()) {
      return this.itemAnim?.isEnable() ?? isEnable;
    }
    return isEnable;
  }

  private getItemVisibility(): Visibility {
    let isContent = this.cardData.getCardShowType() === CardShowType.CARD_CONTENT;
    let defVisibility = isContent ? Visibility.Visible : Visibility.Hidden;
    let styleVisibility = this.itemStyle?.getVisibility() ?? defVisibility;
    // 动效中保持可见
    if (this.itemAnim?.isWidgetAnimating()) {
      return Visibility.Visible;
    }
    return styleVisibility;
  }

  private getStaticWidth(): number | string | undefined {
    let styleWidth = this.rootStyle?.getWidth();
    if (this.itemAnim?.isWidgetAnimating()) {
      return this.itemAnim?.getWidth() ?? styleWidth;
    }
    return styleWidth;
  }

  private getStaticHeight(): number | string | undefined {
    let styleHeight = this.rootStyle?.getHeight();
    if (this.itemAnim?.isWidgetAnimating()) {
      return this.itemAnim?.getHeight() ?? styleHeight;
    }
    return styleHeight;
  }

  private getClipWidth(): number | string | undefined {
    let styleWidth = this.rootStyle?.getWidth();
    if (this.itemAnim?.isWidgetAnimating()) {
      return this.itemAnim?.getClipWidth() ?? styleWidth;
    }
    return styleWidth;
  }

  private getClipHeight(): number | string | undefined {
    let styleHeight = this.rootStyle?.getHeight();
    if (this.itemAnim?.isWidgetAnimating()) {
      return this.itemAnim?.getClipHeight() ?? styleHeight;
    }
    return styleHeight;
  }

  private getClipBorderRadius(): number | undefined {
    let styleRadius = this.itemStyle?.getBorderRadiusTL();
    if (this.itemAnim?.isWidgetAnimating()) {
      return this.itemAnim?.getBorderRadiusTL() ?? styleRadius;
    }
    return styleRadius;
  }

  private getItemTran(): TranslateOptions | undefined {
    if (this.itemAnim?.isWidgetAnimating()) {
      return { x: this.itemAnim?.getTranX(), y: this.itemAnim?.getTranY() };
    }
    return undefined;
  }

  private getItemScale(): ScaleOptions {
    let scaleX = this.itemStyle?.getScaleX();
    let scaleY = this.itemStyle?.getScaleY();
    if (this.itemAnim?.isWidgetAnimating()) {
      return {
        x: this.itemAnim?.getScaleX() ?? scaleX,
        y: this.itemAnim?.getScaleY() ?? scaleY
      };
    }
    return { x: scaleX, y: scaleY };
  }

  private getItemAlpha(): number | undefined {
    let alpha = this.itemStyle?.getAlpha();
    if (this.itemAnim?.isWidgetAnimating()) {
      return this.itemAnim?.getAlpha() ?? alpha;
    }
    return alpha;
  }

  private getItemZIndex(): number {
    // 条目Z轴索引
    let defaultZIndex = this.itemStyle?.getZIndex() ?? ImmCardDataArray.getZIndex(this.cardData?.getCardShowType());
    // 动效时层级
    if (this.itemAnim?.isWidgetAnimating()) {
      return this.itemAnim?.getZIndex() ?? defaultZIndex;
    }
    return defaultZIndex;
  }

  /**
   * 是否无障碍模式开启
   *
   * @returns true无障碍开启
   */
  private isAccessibilityMode(): boolean {
    return AccessibilityUtil.isAccessibilityMode();
  }
}