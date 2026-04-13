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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveVmInjectorFactory } from '../LiveVmInjectorFactory';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LiveCardListItemView } from './LiveCardListItemView';
import { LiveStyle } from '../constants/LiveStyle';
import { BannerVm } from '../../vm/BannerVm';
import { LiveNotification } from '../model/LiveNotification';
import { LengthMetrics } from '@kit.ArkUI';
import { ResourceVm } from '../../vm/ResourceVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';

const TAG = 'LiveCardListView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const MAX_CARD_COUNT = 5;

@ComponentV2
export struct LiveCardListView {
  @Provider() liveVmInjector: ILiveVmInjector = LiveVmInjectorFactory.get();

  cardListVm = this.liveVmInjector.getCardListVm();
  capsuleListVm = this.liveVmInjector.getCapsuleListVm();
  switchVm = this.liveVmInjector.getSwitchVm();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.liveVmInjector.getLiveDataVm().init();
    this.cardListVm.init();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisAppear');
    this.cardListVm.destroy();
  }

  build() {
    EffectComponent() {
      List({ scroller: this.cardListVm.scroller }) {
        // 用来挤占与状态栏的间距
        ListItem().width('100%').height(BannerVm.instance.containerMarginTop)

        ForEach(this.cardListVm.liveList.slice(0, MAX_CARD_COUNT), (live: LiveNotification, index?: number) => {
          LiveCardListItemView({ hashCode: live.hashCode })
        }, (live: LiveNotification, index?: number) => live.key)

        // 用来挤占与底部的空白距离
        ListItem().width('100%').height(LiveStyle.CARD_LIST_BOTTOM_HEIGHT)
      }
      .id(TAG)
      .clip(false)
      .opacity(this.cardListVm.listOpacity)
      .scale({ x: this.cardListVm.listScale, y: this.cardListVm.listScale })
      .edgeEffect(this.cardListVm.listEdgeEffect)
      .scrollBar(BarState.Off)
      .width(BannerVm.instance.cardListWidth)
      .alignListItem(ListItemAlign.Center)
      .hitTestBehavior(this.switchVm.isExpanding || this.switchVm.isCollapsing ? HitTestMode.Block
        : HitTestMode.Default)
      .onAreaChange((_, area) => {
        this.cardListVm.onListAreaChange({
          width: area.width,
          height: (area.height as number) - LiveStyle.CARD_LIST_BOTTOM_HEIGHT,
          position: area.position,
          globalPosition: area.globalPosition,
        })
      })
      .margin({
        start: LengthMetrics.vp(this.cardListVm.getCardLeftMargin())
      })
      .onTouch(this.cardListVm.onListTouch)
      .onWillScroll((offsetTop, state) => this.cardListVm.onListWillScroll(offsetTop, state))
      .gesture(PanGesture({ direction: PanDirection.Up, distance: 15 })
        .onActionEnd(() => {
          log.showInfo(`touch up live list end, collapseCardToCapsule.`);
          this.liveVmInjector.getSwitchVm().collapseCardToCapsule();
        })
      )
      .onReachStart(() => this.cardListVm.onListReachStartOrEnd(true))
      .onReachEnd(() => this.cardListVm.onListReachStartOrEnd(false))
      .onScrollIndex(this.cardListVm.onScrollIndexChange)
      .enableScrollInteraction(this.cardListVm.enableScroll)
      if (this.cardListVm.isNeedHeaderBlur) {
        this.buildHeadBlurArea()
      }
    }
    .width(this.cardListVm.containerWidth)
    .freeze(this.cardListVm.isUseStaticEffect)
    .align(ResourceVm.instance.isRTL ? Alignment.TopEnd : Alignment.TopStart)
    .backgroundEffect({
      policy: 1,
      radius: 30
    })
    .visibility(BannerVm.instance.isLivePanel() || this.liveVmInjector.getLiveHeadsUpVm().isInterrupt ?
    Visibility.Visible : Visibility.None)
    .onSizeChange(this.liveVmInjector.getSwitchVm().onPanelSizeChange)
  }

  @Builder
  buildHeadBlurArea() {
    Column() {
      Column()
        .width('200%')
        .height('100%')
        .compositingFilter(this.cardListVm.getHeaderBlurFilter?.())
        .blendMode(6)
    }
    .position({start: LengthMetrics.vp(-ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) / 2), top: LengthMetrics.vp(0)})
    .width('200%')
    .height(BannerVm.instance.containerMarginTop)
    .linearGradient({
      angle: 270, colors: [['rgba(0, 0, 0, 1)', 0],
        ['rgba(0, 0, 0, 1)', 0.8],
        ['rgba(0, 0, 0, 0)', 1]]
    })
    .blendMode(4, BlendApplyType.OFFSCREEN)
    .visibility(this.cardListVm.isShowHeaderBlur ? Visibility.Visible : Visibility.Hidden)
    .accessibilityLevel('no')
    .zIndex(2)
    .id(`${TAG}_HeadBlurArea`)
  }
}