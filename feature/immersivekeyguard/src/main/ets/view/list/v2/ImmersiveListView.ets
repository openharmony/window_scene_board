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
import { SlWidgetId, ScreenLockNotificationConst } from '@ohos/screenlockcommon';
import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetStyleStateV2, WidgetAnimStateV2, SysFloatTipDialog } from '@ohos/screenlockcommon/Index';
import { IImmersiveListHandle } from '../../../common/interface/IImmersiveListHandle';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { SlListBindStateV2 } from '../../../model/data/v2/SlListBindStateV2';
import { SlListStaticStateV2 } from '../../../model/data/v2/SlListStaticStateV2';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveLiveVmInjector } from '../../../viewmodel/v2/injector/ImmersiveLiveVmInjector';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';
import { ImmersiveListItemView } from './ImmersiveListItemView';

/**
 * V2装饰器，沉浸通知列表主页面
 */
@ComponentV2
export struct ImmersiveListView {
  // 状态管理器，默认通用管理器
  private stateMgrName: SlStateMgr = SlStateMgr.MGR_COMMON;

  // 沉浸通用业务能力注入器
  @Provider() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.getNtfInjector(this.stateMgrName) ??
  v2Helper.defaultNtfInjector;

  // 沉浸实况业务能力注入器
  @Provider() liveVmInjector: ImmersiveLiveVmInjector = v2Helper.getLiveInjector(this.stateMgrName) ??
  v2Helper.defaultLiveInjector;

  // 沉浸列表业务管理器
  private listVm: IImmersiveListVm = this.ntfVmInjector.getImmersiveListVm();

  // 沉浸列表手势事件管理器
  private listHandle: IImmersiveListHandle = this.ntfVmInjector.getImmersiveListHandle();

  // 沉浸列表静态状态管理器
  private staticState: SlListStaticStateV2 = this.listVm?.getSlStaticState() as SlListStaticStateV2;

  // 沉浸列表UI绑定状态管理器
  private bindState: SlListBindStateV2 = this.listVm?.getSlBindState() as SlListBindStateV2;

  // 沉浸列表样式状态管理器
  private listStyle: WidgetStyleStateV2 = this.listVm?.getSlStyleState();

  // 沉浸列表动效状态管理器
  private listAnim: WidgetAnimStateV2 = this.listVm?.getSlAnimState();

  aboutToAppear(): void {
    this.ntfVmInjector?.getImmDataVm()?.init();
  }

  aboutToDisappear(): void {
    this.ntfVmInjector?.getImmDataVm()?.destroy();
  }

  @Builder
  buildSysFloatTipDialog() {
    SysFloatTipDialog({ componentId: ScreenLockNotificationConst.NTF_KEY_GUARD_TIP })
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.None)
  }

  build() {
    Stack({ alignContent: this.listStyle?.getAlignContent() ?? Alignment.Bottom }) {
      // 列表最大高度监控
      Stack()
        .width('100%')
        .height('100%')
        .onSizeChange((oldSize, newSize) => {
          this.staticState?.setListMaxHeight(newSize?.height as number);
          this.ntfVmInjector.getPanelVm().cardWidth = newSize.width as number;
        })

      // 列表内容
      List({ space: this.staticState?.getItemSpace(), scroller: this.staticState?.getListScroller() }) {
        Repeat(this.listVm?.getSlNtfList()).each((data) => {
          ImmersiveListItemView({
            itemData: data.item,
            itemIndex: data.index
          })
        }).key((item) => item.uid)
      }
      .id(SlWidgetId.IMMERSIVE_LIST_SHOW_AREA)
      .clip(false) // 列表保持不裁切，显示阴影
      .scrollBar(BarState.Off)
      .friction(this.staticState?.getScrollFriction())
      .cachedCount(this.staticState?.getItemCacheCount())
      .contentStartOffset(this.staticState?.getItemSpace())
      .contentEndOffset(this.staticState?.getItemSpace())
      .enableScrollInteraction(this.bindState?.isScrollerEnable())
      // 列表滑动禁止时，防止回弹
      .edgeEffect(this.bindState?.isScrollerEnable() ? EdgeEffect.Spring : EdgeEffect.None)
      .width(this.listStyle?.getWidth() ?? '100%')
      .height(this.listStyle?.getHeight())
      .enabled(this.listStyle?.isEnable() ?? true)
      .visibility(this.listStyle?.getVisibility())
      // 初始化时保持置顶状态
      .onAppear(() => this.staticState?.scrollListToTop())
      .onScrollIndex((start, end) => {
        this.staticState?.setStartIndex(start);
        this.staticState?.setEndIndex(end);
        this.listVm?.onScrollIndexChange();
      })
      .onScrollStart(() => {
        this.listHandle?.scrollStart();
        this.staticState?.setListScrolling(true);
        // 开启滑动，及时清除堆叠动效
        this.staticState?.clearItemFoldAnim();
      })
      .onScrollStop(() => this.staticState?.setListScrolling(false))
      .onReachStart(() => this.listVm?.onReachStart())
      .onReachEnd(() => this.listVm?.onReachEnd())
      .onTouch((event) => this.listHandle?.onListTouchEvent(event))
      .parallelGesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Up })
          .onActionStart((event: GestureEvent) => this.listHandle?.onGestureStart(PanDirection.Up, event))
          .onActionUpdate((event: GestureEvent) => this.listHandle?.onGestureUpdate(PanDirection.Up, event))
          .onActionEnd((event: GestureEvent) => this.listHandle?.onGestureEnd(PanDirection.Up, false, event))
          .onActionCancel(() => this.listHandle?.onGestureEnd(PanDirection.Up, true)),
        PanGesture({ direction: PanDirection.Down })
          .onActionStart((event: GestureEvent) => this.listHandle?.onGestureStart(PanDirection.Down, event))
          .onActionUpdate((event: GestureEvent) => this.listHandle?.onGestureUpdate(PanDirection.Down, event))
          .onActionCancel(() => this.listHandle?.onGestureEnd(PanDirection.Down, true))
          .onActionEnd((event?: GestureEvent) => this.listHandle?.onGestureEnd(PanDirection.Down, false, event)),
        PanGesture({ direction: PanDirection.Left })
          .onActionStart((event: GestureEvent) => this.listHandle?.onGestureStart(PanDirection.Left, event))
          .onActionEnd((event: GestureEvent) => this.listHandle?.onGestureEnd(PanDirection.Left, false, event))
          .onActionCancel(() => this.listHandle?.onGestureEnd(PanDirection.Left, true)),
        PanGesture({ direction: PanDirection.Right })
          .onActionStart((event: GestureEvent) => this.listHandle?.onGestureStart(PanDirection.Right, event))
          .onActionEnd((event: GestureEvent) => this.listHandle?.onGestureEnd(PanDirection.Right, false, event))
          .onActionCancel(() => this.listHandle?.onGestureEnd(PanDirection.Right, true)),
      ))
      .onAreaChange((oldArea, newArea) => {
        // 缓存List位置
        this.listVm?.onListAreaChange(oldArea, newArea);
      })
      .onWillScroll((willOffset) => this.listVm?.onListWillScroll(willOffset))
      .onDidScroll((scrollOffset) => this.staticState?.resetWillOffset())

      // 供AOD截图使用
      Stack()
        .id(SlWidgetId.IMMERSIVE_LIST_FOR_ADO)
        .width('100%')
        .height('100%')
        .hitTestBehavior(HitTestMode.None)
    }
    .padding({
      top: LengthMetrics.vp(this.listStyle?.getPaddingT()),
      bottom: LengthMetrics.vp(this.listStyle?.getPaddingB()),
      start: LengthMetrics.vp(this.listStyle?.getPaddingL()),
      end: LengthMetrics.vp(this.listStyle?.getPaddingR()),
    })
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.None)
    .overlay(this.buildSysFloatTipDialog(), { align: Alignment.Bottom,
      offset: { x: 0, y: -(this.listStyle?.getPaddingB() ?? 0) }
    })
    .opacity(this.getRootAlpha())
    .scale(this.getRootScale())
    .translate(this.getRootTran())
  }

  /**
   * 根组件透明度
   *
   * @returns 透明度
   */
  private getRootAlpha(): number | undefined {
    // 动效样式 > 默认样式
    let styleAlpha = this.listStyle?.getAlpha();
    if (this.listAnim?.isWidgetAnimating()) {
      return this.listAnim.getAlpha() ?? styleAlpha;
    }
    return styleAlpha;
  }

  /**
   * 根组件缩放度
   *
   * @returns 缩放度
   */
  private getRootScale(): ScaleOptions | undefined {
    // 动效样式 > 默认样式
    let styleScaleX = this.listStyle?.getScaleX();
    let styleScaleY = this.listStyle?.getScaleY();
    if (this.listAnim?.isWidgetAnimating()) {
      return {
        x: this.listAnim?.getScaleX() ?? styleScaleX,
        y: this.listAnim.getScaleY() ?? styleScaleY
      };
    }
    return { x: styleScaleX, y: styleScaleY };
  }

  /**
   * 根组件位移
   *
   * @returns 位移
   */
  private getRootTran(): TranslateOptions | undefined {
    if (this.listAnim?.isWidgetAnimating()) {
      return {
        x: this.listAnim?.getTranX(),
        y: this.listAnim.getTranY()
      };
    }
    return undefined;
  }
}