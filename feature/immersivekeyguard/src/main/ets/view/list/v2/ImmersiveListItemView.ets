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

import { LengthMetrics } from '@kit.ArkUI';
import { WDefault } from '@ohos/screenlockcommon';
import { WidgetAnimStateV2, WidgetStyleStateV2, ClipRectAnim } from '@ohos/screenlockcommon/Index';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationCardView } from '@ohos/notificationcomponent/newIndex';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ListAnimSuffix, ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveNtfItemVm } from '../../../common/interface/IImmersiveNtfItemVm';
import { IImmersiveNtfSwipeVm } from '../../../common/interface/IImmersiveNtfSwipeVm';

/**
 * 条目堆叠裁剪效果
 *
 * @param clipStyle 裁切样式
 */
@AnimatableExtend(Stack)
function itemClip(clipStyle: ClipRectAnim) {
  .clip(clipStyle.isRectClipEnable ? new Rect({
    width: clipStyle.clipWidth,
    height: clipStyle.clipHeight,
    radius: clipStyle.clipRadius
  })
    .position({
      x: clipStyle.clipOffsetX,
      y: clipStyle.clipOffsetY
    }) : clipStyle.comClip)
}

/**
 * V2装饰器，沉浸通知条目组件
 */
@ComponentV2
export struct ImmersiveListItemView {
  // 沉浸模块普通通知业务能力注入器
  @Consumer() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.defaultNtfInjector;

  // 单个条目数据
  @Param @Require itemData: NotificationBase;

  // 单个条目索引
  @Param @Require itemIndex: number;

  // 列表业务管理器
  private listVm: IImmersiveListVm = this.ntfVmInjector?.getImmersiveListVm();

  // 条目业务管理器
  @Computed get itemVm(): IImmersiveNtfItemVm | undefined {
    return this.ntfVmInjector?.getCardVm(this.itemData);
  }

  // 侧滑业务管理器
  @Computed get swipeVm(): IImmersiveNtfSwipeVm | undefined {
    return this.ntfVmInjector.getSwipeVm(this.itemData);
  }

  // 条目通用样式
  @Computed get itemComStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_COMMON_STYLE);
    return helper?.getItemSt(this.itemData?.groupKey);
  }

  // 条目通用动效状态
  @Computed get itemComAnimSt(): WidgetAnimStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm()?.getListAnimH(ListAnimSuffix.ITEM_COMMON_ANIM);
    return helper?.getItemSt(this.itemData?.groupKey);
  }

  // 条目翻转堆叠动效状态
  @Computed get itemFoldAnimSt(): WidgetAnimStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm()?.getListAnimH(ListAnimSuffix.ITEM_FOLD_ANIM);
    return helper?.getItemSt(this.itemData?.groupKey);
  }

  // 条目背景动效状态
  @Computed get itemBgAnimSt(): WidgetAnimStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm()?.getListAnimH(ListAnimSuffix.ITEM_BG_ANIM);
    return helper?.getItemSt(this.itemData?.groupKey);
  }

  // 条目阴影动效状态
  @Computed get itemShadowAnimSt(): WidgetAnimStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm()?.getListAnimH(ListAnimSuffix.ITEM_SHADOW_ANIM);
    return helper?.getItemSt(this.itemData?.groupKey);
  }

  /**
   * 列表条目背景
   */
  @Builder
  private ListItemBg() {
    // 动效背景，动效时背景裁切效果
    if (this.itemBgAnimSt?.isWidgetAnimating()) {
      Stack() {
        Stack()
          .width(this.getAnimClipWidth())
          .height(this.getAnimClipHeight())
          .backgroundColor(this.itemVm?.getCardBgColor())
          .backgroundBrightnessInternal(this.itemVm?.cardBgBrightness)
      }
      .useEffect(true)
      .opacity(this.getFoldAlpha())
      // 保持侧滑一致
      .offset({ start: LengthMetrics.vp(this.swipeVm?.offsetX) })
    }
  }

  /**
   * 列表条目阴影效果
   */
  @Builder
  private ListItemShadow() {
    Stack({ alignContent: this.getShadowAlign() }) {
      Stack()
        .clip(true)
        .width(this.getShadowWidth())
        .height(this.getShadowHeight())
        // 点击缩放保持一致
        .scale({ x: this.itemVm?.itemClickScale, y: this.itemVm?.itemClickScale })
        .borderRadius(this.getItemBoardRadius())
        .shadow(this.itemComStyle?.getShadow())
    }
    // 宽度保持占用
    .width('100%')
    .height(this.getStaticHeight())
    .padding(this.getShadowClipOffset())
    // 堆叠效果的缩放
    .scale(this.getFoldScale())
    // 堆叠效果的透明度
    .opacity(this.getFoldAlpha())
    // 堆叠效果的偏移、侧滑的偏移
    .offset(this.getShadowOffset())
    // 条目的偏移
    .translate(this.getItemTran())
  }

  /**
   * 列表条目光影效果
   */
  @Builder
  private ListItemPointLight() {
    Stack()
      .clip(true)
      .width('100%')
      .height(this.getShadowHeight())
      .opacity(this.getFoldAlpha())
      .borderRadius(this.getItemBoardRadius())
      .hitTestBehavior(HitTestMode.None)
      // 点击缩放保持一致
      .scale({ x: this.itemVm?.itemClickScale, y: this.itemVm?.itemClickScale })
      // 保持侧滑一致
      .offset({ start: LengthMetrics.vp(this.swipeVm?.offsetX) })
      // 光影效果
      .pointLight(this.itemComStyle?.getPointLight())
  }

  /**
   * 列表条目内容
   */
  @Builder
  private ListItemContent() {
    // 动态大小组件，负责动效时裁切组件
    Stack() {
      // 动效背景
      this.ListItemBg()

      // 固定大小组件
      Stack() {
        NotificationCardView({
          ntf: this.itemData,
          index: this.itemIndex
        })
      }
      // 内层缩放，配合外层裁切
      .scale(this.getFoldScale())
      .opacity(this.getFoldAlpha())
      .width(this.getStaticWidth())
      .height(this.getStaticHeight())
      .itemClip(this.getItemClip())

      // 光影效果
      this.ListItemPointLight()
    }
    .clip(this.isClipItem())
    .offset(this.getFoldTran())
    .borderRadius(this.getItemBoardRadius())
    .width(this.getAnimClipWidth())
    .height(this.getAnimClipHeight())
    .translate(this.getItemTran())
  }

  build() {
    ListItem() {
      // 条目阴影
      this.ListItemShadow()
      // 条目内容
      this.ListItemContent()
    }
    // 保持顶部对齐，ListItem内容超出ListItem的高度时也会强制顶部对齐
    .enabled(this.getIsEnabled())
    .align(Alignment.Top)
    .width(this.getStaticWidth())
    .height(this.getStaticHeight())
    // 条目透明度、缩放共享
    .opacity(this.getItemAlpha())
    .scale(this.getItemScale())
    .zIndex(this.getItemZIndex())
    .onAppear(() => this.listVm?.onItemAppear(this.itemData, this.itemIndex))
    .onAreaChange((oldValue, newValue) => this.listVm?.onItemAreaChange(this.itemData, newValue, this.itemIndex))
  }

  private getItemClip() {
    let clipHeight = this.itemFoldAnimSt?.getClipHeight() as number;
    let offsetY = this.itemFoldAnimSt?.getClipOffsetY() ?? 0;
    let radius = this.itemComStyle?.getBorderRadiusTL() ?? 0;
    return new ClipRectAnim()
      .buildClipHeight(clipHeight)
      .buildClipOffsetY(offsetY)
      .buildClipRadius(radius);
  }

  private getIsEnabled(): boolean {
    // 条目是否响应事件
    let isEnabled = this.itemComStyle?.isEnable() ?? true;
    if (this.itemFoldAnimSt) {
      isEnabled = this.itemFoldAnimSt?.isEnable() ?? isEnabled;
    }
    // 条目动效中屏蔽事件
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.isEnable() ?? isEnabled;
    }
    return isEnabled;
  }

  private getAnimClipWidth(): Length | undefined {
    // 动效时动态切割宽度
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getClipWidth();
    }
    return undefined;
  }

  private getAnimClipHeight(): Length | undefined {
    // 动效时动态切割高度
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getClipHeight();
    }
    return undefined;
  }

  private getFoldTran(): LocalizedEdges | undefined {
    // 堆叠位移用offset替代
    let offsetY = this.itemFoldAnimSt?.getTranY() ?? WDefault.MIN_VALUE;
    return { start: LengthMetrics.vp(WDefault.MIN_VALUE), top: LengthMetrics.vp(offsetY) };
  }

  private getStaticWidth(): Length | undefined {
    // 动效时保持固定宽度
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getWidth();
    }
    return undefined;
  }

  private getStaticHeight(): Length | undefined {
    // 动效时保持固定高度
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getHeight();
    }
    return undefined;
  }

  private getShadowAlign(): Alignment {
    let defaultAlign = Alignment.TopStart;
    // 动效时保持动效对齐方式
    if (this.itemShadowAnimSt?.isWidgetAnimating()) {
      return this.itemShadowAnimSt?.getAlignContent() ?? defaultAlign;
    }
    return defaultAlign;
  }

  private getShadowWidth(): Length | undefined {
    // 阴影默认宽度以横滑偏移后为准
    let swipeOffset = Math.abs(this.swipeVm?.offsetX ?? WDefault.MIN_VALUE);
    let defaultWidth = `calc(100% - ${swipeOffset}vp)`;
    // 动效时保持动效宽度
    if (this.itemShadowAnimSt?.isWidgetAnimating()) {
      return this.itemShadowAnimSt?.getClipWidth() ?? defaultWidth;
    }
    return defaultWidth;
  }

  private getShadowHeight(): Length | undefined {
    // 阴影默认高度以堆叠裁切高度为准
    let defaultHeight = this.itemFoldAnimSt?.getClipHeight();
    // 动效时保持动效高度
    if (this.itemShadowAnimSt?.isWidgetAnimating()) {
      return this.itemShadowAnimSt?.getClipHeight() ?? defaultHeight;
    }
    return defaultHeight;
  }

  private getShadowClipOffset(): Padding | undefined {
    // 阴影裁切偏移用padding替代
    let defaultOffsetY = this.itemFoldAnimSt?.getClipOffsetY();
    // 动效时保持动效裁切偏移
    if (this.itemShadowAnimSt?.isWidgetAnimating()) {
      return { top: this.itemShadowAnimSt?.getClipOffsetY() ?? defaultOffsetY };
    }
    return { top: defaultOffsetY };
  }

  private getShadowOffset(): LocalizedEdges | undefined {
    // 向右滑时，阴影宽度自动适配；向左滑时，跟随偏移
    let swipeOffset = this.swipeVm?.offsetX ?? WDefault.MIN_VALUE;
    let offsetX = Math.max(swipeOffset, WDefault.MIN_VALUE);
    // 堆叠位移用offset替代
    let offsetY = this.itemFoldAnimSt?.getTranY() ?? WDefault.MIN_VALUE;
    return { start: LengthMetrics.vp(offsetX), top: LengthMetrics.vp(offsetY) };
  }

  private isClipItem(): boolean {
    // 条目切割是否开启
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.isClipEnable() ?? false;
    }
    return false;
  }

  private getItemBoardRadius(): number | undefined {
    let defaultRadius = this.itemComStyle?.getBorderRadiusTL();
    // 开启条目切割，则使用动效圆角
    if (this.isClipItem()) {
      return this.itemComAnimSt?.getBorderRadiusTL() ?? defaultRadius;
    }
    return defaultRadius;
  }

  private getItemAlpha(): number | undefined {
    // 样式透明度
    let defaultAlpha = this.itemComStyle?.getAlpha();
    // 动效透明度
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getAlpha() ?? defaultAlpha;
    }
    return defaultAlpha;
  }

  private getFoldAlpha(): number | undefined {
    // 堆叠透明度
    return this.itemFoldAnimSt?.getAlpha();
  }

  private getItemTran(): TranslateOptions | undefined {
    // 动效位移
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return {
        x: this.itemComAnimSt?.getTranX() ?? WDefault.MIN_VALUE,
        y: this.itemComAnimSt?.getTranY() ?? WDefault.MIN_VALUE
      };
    }
    return undefined;
  }

  private getItemScale(): ScaleOptions | undefined {
    // 动效缩放
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return {
        x: this.itemComAnimSt?.getScaleX() ?? WDefault.MAX_VALUE,
        y: this.itemComAnimSt?.getScaleY() ?? WDefault.MAX_VALUE,
      };
    }
    return undefined;
  }

  private getFoldScale(): ScaleOptions {
    let scaleX = this.itemFoldAnimSt?.getScaleX() ?? WDefault.MAX_VALUE;
    let scaleY = this.itemFoldAnimSt?.getScaleY() ?? WDefault.MAX_VALUE;
    let centerY = this.itemFoldAnimSt?.getScaleCenterY() ?? '50%';
    return { x: scaleX, y: scaleY, centerY: centerY };
  }

  private getItemZIndex(): number | undefined {
    // 默认使用堆叠态Z序
    let defaultZIndex = this.itemFoldAnimSt?.getZIndex() ?? 0;
    // 动效期间使用动效Z序
    if (this.itemComAnimSt?.isWidgetAnimating()) {
      return this.itemComAnimSt?.getZIndex() ?? defaultZIndex;
    }
    return defaultZIndex;
  }
}