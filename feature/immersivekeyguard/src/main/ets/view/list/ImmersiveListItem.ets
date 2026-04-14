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

import { BaseConstants, ImmersiveSysEventUtils } from '@ohos/systemuicommon';
import { NotificationAnimationParas } from '@ohos/notificationcomponent/src/main/ets/common/NotificationAnimationParas';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NotificationListItem } from '@ohos/notificationcomponent/src/main/ets/pages/phone/NotificationListItem';
import { NtfColorModeVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfColorModeVM';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';
import { interruptHelper } from '../../common/helper/ImmersiveInterruptHelper';
import { ImmersiveListVm } from '../../viewmodel/ImmersiveListVm';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { ImmersiveAnimManager } from '../../viewmodel/viewanim/ImmersiveAnimManager';
import { NtfListStaticState } from '../../viewmodel/viewdata/NtfListState';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { ImmersiveListHandle } from '../../viewmodel/viewevent/ImmersiveListHandle';
import { WDefault } from '@ohos/screenlockcommon';
import { SlVisualArgs, SlVisualControl, SlPositionType, SlAreaType, CcmOption, slWallpaperMgr}
  from '@ohos/screenlockcommon';
import {
  ImmUeDataHelper
} from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/helper/ImmUeDataHelper';

const MAX = WDefault.MAX_VALUE;

/**
 * 沉浸列表单条目组件
 */
@Component
export struct ImmersiveListItem {
  /**
   * 沉浸列表业务管理器
   */
  private listVm: ImmersiveListVm = immersiveVm.getImmersiveListVm();

  /**
   * 沉浸动效管理器
   */
  private animMgr: ImmersiveAnimManager = immersiveVm.getImmersiveAnimMgr();

  /**
   * 事件处理器
   */
  private eventHandle: ImmersiveListHandle = immersiveVm.getImmersiveListHandle();

  /**
   * 列表静态状态管理
   */
  private listStaticState: NtfListStaticState = this.listVm.getListStaticState();

  /**
   * 单条通知数据
   */
  @State ntfEntry?: NotificationEntry = undefined;

  /**
   * 通知卡片反转动效参数
   */
  @ObjectLink ntfAnimParameters: NotificationAnimationParas;

  /**
   * 动效状态管理
   */
  @ObjectLink animState: WidgetAnimState;

  /**
   * 子组件动效状态管理
   */
  @State innerState: WidgetAnimState | undefined = undefined;

  /**
   * 锁屏条目提亮参数
   */
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  //是否开启辅助功能朗读模式
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  @State backgroundBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_NTF_LIST_BACK);

  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CAPSULE);

  /**
   * 提亮管理
   */
  private colorModeVM: NtfColorModeVM | undefined = undefined;

  /**
   * 条目侧滑事件回调
   */
  private itemTouchListener = (isItemTouching: boolean): void => {
    // 条目位移后，触摸事件跟随内层item
    this.listStaticState.isTouchingItem = isItemTouching;
    if (isItemTouching && !this.listStaticState.isLongClickAnimating()) { // 动效中侧滑，去除模糊
      this.animState?.setUseEffect().setClip().setAlignContent();
      this.ntfAnimParameters?.updateDisableEffect();
    }
  };

  /**
   * 条目区域变化
   */
  private itemAreaChange = (oldArea: Area, newArea: Area): void => {
    // 缓存item卡片位置
    this.animMgr.setListViewArea(this.getEntryGroupKey(), newArea);
    // 竖直方向变化，及时清除裁剪
    if (oldArea.globalPosition?.y !== newArea.globalPosition?.y) {
      this.animState?.setClip().setAlignContent();
      this.ntfAnimParameters?.updateDisableEffect();
    }
  };

  private getBgColor(): ResourceColor | undefined {
    return this.colorModeVM?.liveNtfItemBgColor;
  }

  aboutToAppear(): void {
    this.innerState = this.animState?.getChildState(this.animState?.getStateId());
    ImmersiveSysEventUtils.reportImmersiveListAppearEvent({
      USER_PACKAGE_NAME: this.ntfEntry?.creatorBundleName,
      NTF_HASHCODE: this.ntfEntry?.getFirstChildEntry()?.hashCode ?? '',
      IS_LIVE: this.ntfEntry?.isLiveType() ? 0 : 1,
      VISUAL_PARAMS: ImmUeDataHelper.getInstance().getVisualParams(),
    });
  }

  @Styles
  private itemRootStyle() {
    .id(this.getItemImmersiveId())
    .align(this.getItemAlign())
    .width(this.getItemStaticWidth() ?? '100%')
    .height(this.getItemStaticHeight())
    .translate({ y: 0 })
    .draggable(false)
    .enabled(this.isAccessibilityMode ? true : (this.ntfAnimParameters?.isItemEnable() ?? true))
    .borderRadius(this.listStaticState.itemRadius)
    .zIndex(this.getItemZIndex())
    .transition(this.listStaticState.itemTransition)
    .onAreaChange((old, newArea) => this.itemAreaChange?.(old, newArea))
    .onSizeChange((old, newSize) => this.listVm?.onItemSizeChange(this.getEntryGroupKey(), old, newSize))
    .onTouchIntercept((event: TouchEvent) => this.eventHandle.onItemTouchIntercept(event, this.getEntryGroupKey()))
  }

  @Builder
  ItemBackground() { // 模糊背景，实况背景场景
    if (this.isBgBlurEnable()) {
      Stack() {
        Stack()
          .width(this.getItemAnimWidth())
          .height(this.getItemAnimHeight())
          .backgroundColor(this.getBgColor())
          .backgroundBrightnessInternal(this.enableBright ? this.colorModeVM?.bgBrightnessOption : undefined)
      }
      .clip(true)
      .useEffect(true)
      .borderRadius(this.getItemAnimRadius())
      .scale(this.getInnerScale())
      // 保持堆叠效果
      .translate({ y: this.ntfAnimParameters?.ntfItemTranslateY ?? MAX })
      .opacity(this.ntfAnimParameters?.clearAnimOpacity ?? MAX)
    }
  }

  @Builder
  ItemContent() {
    if (this.ntfEntry) {
      Stack() {
        this.ItemBackground()

        NotificationListItem({
          ntfGroupEntry: this.ntfEntry,
          ntfAniParameters: this.ntfAnimParameters,
          radius: this.listStaticState.itemRadius,
          colorModeVM: this.colorModeVM,
          isUseEffect: this.listStaticState.isUseEffect,
          canExpand: this.listStaticState.groupCanExpand,
          isGestureEnabled: this.listStaticState.isGestureEnabled,
          touchListItemCallback: this.itemTouchListener,
          dataChangeInterrupt: interruptHelper.ntfDataChangeIt
        })
          .offset(this.getInnerOffset())
          .translate(this.getInnerTran())
          .width(this.getItemStaticWidth())
          .height(this.getItemStaticHeight())
          .scale(this.getItemScale())
      }
      .alignContent(this.getItemAlign())
      // 模糊背景替代时，父组件关闭裁切
      .clip(this.isClipItem() && !this.isBgBlurEnable())
      .width(this.getItemAnimWidth())
      .height(this.getItemAnimHeight())
      .borderRadius(this.getItemAnimRadius())
      .opacity(this.getItemAlpha())
      .translate(this.getItemTran())
      .offset(this.getItemOffset())
    }
  }

  @Builder
  ItemComponent() {
    ListItem() {
      this.ItemContent()
    }
    .itemRootStyle()
  }

  build() {
    this.ItemComponent()
  }

  /**
   * 条目对齐方式
   *
   * @returns 对齐方式
   */
  private getItemAlign(): Alignment {
    if (this.animState?.isSceneAnimating()) { // 动效期间，保持顶部对齐
      return this.animState?.getAlignContent() ?? Alignment.Center;
    }
    return Alignment.Center; // 默认居中
  }

  /**
   * 条目固定高度
   *
   * @returns 高度
   */
  private getItemStaticHeight(): number | string | undefined {
    if (this.isClipItem()) {
      return this.animState?.getHeight();
    }
    return undefined;
  }

  /**
   * 条目固定宽度
   *
   * @returns 宽度
   */
  private getItemStaticWidth(): number | string | undefined {
    if (this.isClipItem()) {
      return this.animState?.getWidth();
    }
    return undefined;
  }

  /**
   * 条目动态高度
   *
   * @returns 动态高度
   */
  private getItemAnimHeight(): number | string | undefined {
    if (this.isClipItem()) {
      return this.animState?.getClipHeight();
    }
    return undefined;
  }

  /**
   * 条目动态宽度
   *
   * @returns 动态宽度
   */
  private getItemAnimWidth(): number | string | undefined {
    if (this.isClipItem()) {
      return this.animState?.getClipWidth() ?? BaseConstants.PERCENT_MAX;
    }
    return undefined;
  }

  /**
   * 条目动态圆角
   *
   * @returns 圆角
   */
  private getItemAnimRadius(): number | undefined {
    // 开启模糊，则开启圆角
    if (this.isClipItem()) {
      return this.animState?.getBorderRadiusTL() ?? this.listStaticState.itemRadius;
    }
    return this.listStaticState.itemRadius;
  }

  /**
   * 条目偏移，抵消inner偏移
   * ListItem子组件超出高度后，top对齐，需偏移量保持居中
   *
   * @returns 偏移
   */
  private getItemOffset(): Position | undefined {
    if (this.isClipItem()) {
      return {
        y: this.animState?.getMarginT() ?? 0
      };
    }
    return undefined;
  }

  /**
   * 条目inner缩放
   *
   * @returns 缩放
   */
  private getInnerScale(): ScaleOptions | undefined {
    let paraScale = this.ntfAnimParameters?.clearAnimScale ?? MAX;
    if (this.innerState?.isSceneAnimating()) {
      let scaleX = this.innerState.getScaleX() ?? MAX;
      let scaleY = this.innerState.getScaleY() ?? MAX;
      return { x: scaleX * paraScale, y: scaleY * paraScale };
    }
    return { x: paraScale, y: paraScale };
  }

  /**
   * 是否开启背景模糊
   *
   * @returns true背景模糊
   */
  private isBgBlurEnable(): boolean {
    if (this.innerState?.isSceneAnimating()) {
      return this.innerState?.isUseEffect() ?? false;
    }
    return false;
  }

  /**
   * 是否裁切条目形状
   *
   * @returns true裁切
   */
  private isClipItem(): boolean {
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.isClipEnable() ?? false;
    }
    return false;
  }

  /**
   * 子组件位移量，用于宽高裁剪方案的竖向偏移
   *
   * @returns 位移量
   */
  private getInnerTran(): TranslateOptions | undefined {
    if (this.isClipItem()) {
      let clipOffsetY = this.animState?.getClipOffsetY() ?? 0;
      return {
        y: -clipOffsetY
      };
    }
    return undefined;
  }

  /**
   * 子组件偏移量，替代内部翻转动效偏移
   *
   * @returns 偏移量
   */
  private getInnerOffset(): Position | undefined {
    if (this.isClipItem()) {
      return {
        y: this.innerState?.getMarginT() ?? 0
      };
    }
    return undefined;
  }

  /**
   * 条目层级
   *
   * @returns 层级
   */
  private getItemZIndex(): number | undefined {
    let index = this.ntfAnimParameters?.ntfItemZIndex;
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getZIndex() ?? index;
    }
    return index;
  }

  /**
   * item透明度
   *
   * @returns 透明度
   */
  private getItemAlpha(): number | undefined {
    // 动效透明度
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getAlpha();
    }
    return undefined;
  }

  /**
   * item位移
   *
   * @returns 位移
   */
  private getItemTran(): TranslateOptions | undefined {
    // 动效位移
    if (this.animState?.isSceneAnimating()) {
      return { x: this.animState?.getTranX(), y: this.animState?.getTranY() };
    }
    return undefined;
  }

  /**
   * item缩放
   *
   * @returns 缩放
   */
  private getItemScale(): ScaleOptions | undefined {
    if (this.animState?.isSceneAnimating()) {
      return {
        x: this.animState?.getScaleX(), y: this.animState?.getScaleY(), centerY: this.animState?.getScaleCenterY()
      };
    }
    return undefined;
  }

  /**
   * 条目组件ID
   *
   * @returns ID
   */
  private getItemImmersiveId(): string {
    return ImmersiveConstants.getImmersiveID(this.getEntryGroupKey());
  }

  /**
   * 数据分组标识
   *
   * @returns 分组标识
   */
  private getEntryGroupKey(): string {
    return this.ntfEntry?.getGroupKey() ?? '';
  }
}