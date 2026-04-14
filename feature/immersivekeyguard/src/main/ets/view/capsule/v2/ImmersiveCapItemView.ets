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
import { CommonUtils } from '@ohos/basicutils';
import { ImmersiveMediaCapsule } from '@ohos/mediacontrolcomponent';
import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { AccessibilityLevel } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityData';
import { CapAnimSuffix, CapShowType, CapStyleSuffix } from '../../../common/constants/ImmCapConst';
import { IImmersiveCapsuleHandle } from '../../../common/interface/IImmersiveCapsuleHandle';
import { IImmersiveCapVm } from '../../../common/interface/IImmersiveCapVm';
import { ImmCapData } from '../../../model/data/v2/ImmCapData'
import { ImmCapDataArray } from '../../../model/data/v2/ImmCapDataArray';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';
import { ImmCapComView } from './ImmCapComView';

/**
 * V2装饰器，沉浸胶囊条目组件
 */
@ComponentV2
export struct ImmersiveCapItemView {
  // 沉浸模块普通通知业务能力注入器
  @Consumer() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.defaultNtfInjector;

  // 胶囊条目数据
  @Require @Param capData: ImmCapData;

  // 沉浸胶囊业务管理器
  private capVm: IImmersiveCapVm = this.ntfVmInjector.getImmersiveCapVm();

  // 事件管理
  private capsuleHandle: IImmersiveCapsuleHandle = this.ntfVmInjector.getImmersiveCapsuleHandle();

  // 胶囊条目样式
  @Computed get itemComStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.ntfVmInjector.getImmItemHelperVm().getCapStyleH(CapStyleSuffix.ITEM_COMMON_STYLE);
    return helper?.getItemSt(this.capData?.getCapShowType());
  }

  // 胶囊条目动效
  @Computed get itemComAnimSt(): WidgetAnimStateV2 | undefined {
    let helper = this.ntfVmInjector.getImmItemHelperVm().getCapAnimH(CapAnimSuffix.ITEM_COMMON_ANIM);
    return helper?.getItemSt(this.capData?.getCapShowType());
  }

  /**
   * 条目内容
   */
  @Builder
  private ItemContent() {
    // 播控条目内容
    if (this.capData?.isMediaCenter()) {
      ImmersiveMediaCapsule({
        capHeight: this.itemComStyle?.getHeight()
      })
    } else {
      // 通用条目内容
      ImmCapComView({ capData: this.capData })
    }
  }

  build() {
    // 外层固定大小，保持基本位置
    Stack({ alignContent: Alignment.Top }) {
      // 内层可变大小，允许动效修改宽高
      Stack({ alignContent: this.getItemAlignment() }) {
        // 模糊背景，默认开启模糊
        Stack()
          .accessibilityLevel('no')
          .useEffect(this.itemComStyle?.isUseEffect() ?? true)
          .width('100%')
          .height('100%')
          .borderRadius(this.itemComStyle?.getBorderRadiusTL())

        // 提亮背景
        Stack()
          .accessibilityLevel('no')
          .width('100%')
          .height('100%')
          .borderRadius(this.itemComStyle?.getBorderRadiusTL())
          .backgroundColor(this.itemComStyle?.getBgColor())
          .backgroundBrightnessInternal(this.getItemBgBrightnessInner())

        // 条目内容
        this.ItemContent()
      }
      .onClick(() => this.capVm?.onItemClick(this.capData))
      .clip(this.isItemClipEnable())
      .enabled(this.isItemEnable())
      .width(this.getItemAnimWidth())
      .height(this.getItemAnimHeight())
      .borderRadius(this.getItemAnimRadius())
      .pointLight(this.itemComStyle?.getPointLight())
      .accessibilityLevel(this.getItemAccessibilityLevel())
      .margin(this.getItemMargin())
      .gesture(PanGesture({ direction: PanDirection.Up })
        .onActionStart((event: GestureEvent) => this.capsuleHandle.onGestureStart(event))
        .onActionUpdate((event: GestureEvent) => this.capsuleHandle.onGestureUpdate(event))
        .onActionEnd((event: GestureEvent) => this.capsuleHandle.onGestureEnd(event, false))
        .onActionCancel((event: GestureEvent) => this.capsuleHandle.onGestureEnd(event, true))
      )
      .onGestureJudgeBegin(() => {
        // 屏蔽事件时及时生效
        return this.isItemEnable() ? GestureJudgeResult.CONTINUE : GestureJudgeResult.REJECT;
      })
    }
    .zIndex(this.getItemZIndex())
    .translate(this.getItemTran())
    .opacity(this.getItemAlpha())
    .scale(this.getItemScale())
    .blur(this.getItemBlur())
    .width('100%')
    .height(this.getRootHeight())
    .visibility(this.getItemVisibility())
    .hitTestBehavior(HitTestMode.Transparent)
  }

  private getRootHeight(): Length | undefined {
    let topMargin = this.itemComStyle?.getMarginT() ?? 0;
    // 动效间距控制高度
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      topMargin = this.itemComAnimSt?.getMarginT() ?? topMargin;
    }
    let itemStyleHeight = this.itemComStyle?.getHeight() as number ?? 0;
    return topMargin + itemStyleHeight;
  }

  private getItemVisibility(): Visibility {
    let styleVisibility = this.itemComStyle?.getVisibility() ?? Visibility.Visible;
    // 动效期间保持可见
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return Visibility.Visible;
    }
    return styleVisibility;
  }

  private isItemEnable(): boolean | undefined {
    let styleEnable = this.itemComStyle?.isEnable();
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.isEnable() ?? styleEnable;
    }
    return styleEnable;
  }

  private getItemAccessibilityLevel(): string {
    return this.capData?.getCapShowType() === CapShowType.CAP_SHADOW ? AccessibilityLevel.NO_HIDE_DESCENDANTS :
    AccessibilityLevel.YES;
  }

  private getItemAlignment(): Alignment {
    let defaultAlign = Alignment.Center;
    // 动效期间保持可见
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getAlignContent() ?? defaultAlign;
    }
    return defaultAlign;
  }

  private getItemStyleWidth(): string | undefined {
    // 条目样式状态下宽度，保持间距排除后全部占用
    let marginL = this.itemComStyle?.getMarginL() ?? 0;
    let marginR = this.itemComStyle?.getMarginR() ?? 0;
    return `calc(100% - ${CommonUtils.spliceVp(marginL + marginR)})`;
  }

  private getItemZIndex(): number {
    // 条目Z轴索引
    let defaultZIndex = this.itemComStyle?.getZIndex() ?? ImmCapDataArray.getZIndex(this.capData?.getCapShowType());
    // 动效时层级
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getZIndex() ?? defaultZIndex;
    }
    return defaultZIndex;
  }

  private isItemClipEnable(): boolean {
    // 动效时，开启切割
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.isClipEnable() ?? false;
    }
    return false;
  }

  private getItemAnimWidth(): Length | undefined {
    // 默认样式宽度
    let styleWidth = this.getItemStyleWidth();
    // 动效切割宽度
    if (this.isItemClipEnable()) {
      return this.itemComAnimSt?.getClipWidth() ?? styleWidth;
    }
    return styleWidth;
  }

  private getItemAnimHeight(): Length | undefined {
    // 默认样式高度
    let styleHeight = this.itemComStyle?.getHeight();
    // 动效切割高度
    if (this.isItemClipEnable()) {
      return this.itemComAnimSt?.getClipHeight() ?? styleHeight;
    }
    return styleHeight;
  }

  private getItemAnimRadius(): number | undefined {
    // 样式圆角
    let styleRadius = this.itemComStyle?.getBorderRadiusTL();
    // 动效切割圆角
    if (this.isItemClipEnable()) {
      return this.itemComAnimSt?.getBorderRadiusTL() ?? styleRadius;
    }
    return styleRadius;
  }

  private getItemTran(): TranslateOptions | undefined {
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return { x: this.itemComAnimSt?.getTranX() ?? 0, y: this.itemComAnimSt?.getTranY() ?? 0 };
    }
    return undefined;
  }

  private getItemAlpha(): number | undefined {
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getAlpha();
    }
    return undefined;
  }

  private getItemScale(): ScaleOptions | undefined {
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return { x: this.itemComAnimSt?.getScaleX(), y: this.itemComAnimSt?.getScaleY() };
    }
    return undefined;
  }

  private getItemBlur(): number {
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getBlur() ?? 0;
    }
    return 0;
  }

  private getItemMargin(): LocalizedMargin {
    let marginT = this.itemComStyle?.getMarginT();
    let marginL = this.itemComStyle?.getMarginL();
    let marginR = this.itemComStyle?.getMarginR();
    // 动效间距
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      marginT = this.itemComAnimSt?.getMarginT() ?? marginT;
      marginL = this.itemComAnimSt?.getMarginL() ?? marginL;
      marginR = this.itemComAnimSt?.getMarginR() ?? marginR;
    }
    return {
      top: LengthMetrics.vp(marginT),
      start: LengthMetrics.vp(marginL),
      end: LengthMetrics.vp(marginR)
    };
  }

  private getItemBgBrightnessInner(): BrightnessOptions | undefined {
    let styleBgBrightness = this.itemComStyle?.getBgBrightnessInner();
    // 动效提亮参数
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getBgBrightnessInner() ?? styleBgBrightness;
    }
    return styleBgBrightness;
  }
}