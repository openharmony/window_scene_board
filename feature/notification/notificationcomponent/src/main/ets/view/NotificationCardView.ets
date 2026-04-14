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

import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { LiveCardSystemModel,
  NormalNotification,
  NormalNotificationGroup, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import {
  BaseGesture,
  INotificationCardVm,
  INotificationSwipeVm,
  NotificationVmInjector
} from '@ohos/systemuicommon/newIndex';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationNormalGroupView } from './NotificationNormalGroupView';
import { NotificationMenuView } from './NotificationMenuView';
import { NotificationNormalView } from './NotificationNormalView';
import { MediaPlaybackControllerItem } from '@ohos/mediacontrolcomponent';
import { NotificationMoreBriefView } from './NotificationMoreBriefView';
import { LengthMetrics } from '@kit.ArkUI';
import { NotificationPrivacyView } from './NotificationPrivacyView';
import { NotificationLiveCardView } from './NotificationLiveCardView';
import { NotificationNormalVm } from '../viewmodel/NotificationNormalVm';
import { ViewName } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'NotificationCardView';
const log = Logger.getLogHelper(LogDomain.NC);

@ComponentV2
export struct NotificationCardView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  @Param @Require ntf: NotificationBase;
  @Param @Require index: number;

  @Computed get cardVm(): INotificationCardVm {
    return this.ntfVmInjector.getCardVm(this.ntf);
  }
  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    return this.ntfVmInjector.getSwipeVm(this.ntf);
  }

  @Computed get baseGesture(): BaseGesture {
    const gesture = new BaseGesture();
    if (this.swipeVm && this.cardVm.needGesture) {
      gesture.addGesture(this.swipeVm.getPanGestureHandler());
    }
    return gesture;
  }

  aboutToAppear(): void {
    log.showInfo(TAG, `aboutToAppear: ${this.ntf.hashCode}`);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear: ${this.ntf.hashCode}`);
  }

  build() {
    Stack({ alignContent: this.cardVm.align }) {
      RelativeContainer() {
        // 提亮模糊分层。提亮和模糊处于同一节点时，深色背景下会出现横幅轻微闪烁的问题。将模糊提取到一个单独的节点上
        Column() {}
        .id(this.ntfVmInjector.getId(`${TAG}_backgroundContainer_effect_${this.ntf.hashCode}`))
        .alignRules({
          left: { anchor: this.cardVm.contentId, align: HorizontalAlign.Start },
          top: { anchor: this.cardVm.contentId, align: VerticalAlign.Top },
          right: { anchor: this.cardVm.contentId, align: HorizontalAlign.End },
          bottom: { anchor: this.cardVm.contentId, align: VerticalAlign.Bottom },
        })
        .borderRadius(NotificationConfig.BORDER_RADIUS)
        .height(this.cardVm.cardBgHeight)
        .clip(true)
        .visibility(this.cardVm.isCardBgHide ? Visibility.None : Visibility.Visible)
        .backgroundEffect(this.cardVm.cardBgEffect)
        .accessibilityLevel('no')

        Column() {}
        .id(this.ntfVmInjector.getId(`${TAG}_backgroundContainer_${this.ntf.hashCode}`))
        .alignRules({
          left: { anchor: this.cardVm.contentId, align: HorizontalAlign.Start },
          top: { anchor: this.cardVm.contentId, align: VerticalAlign.Top },
          right: { anchor: this.cardVm.contentId, align: HorizontalAlign.End },
          bottom: { anchor: this.cardVm.contentId, align: VerticalAlign.Bottom },
        })
        .borderRadius(NotificationConfig.BORDER_RADIUS)
        .height(this.cardVm.cardBgHeight)
        .clip(true)
        .visibility(this.cardVm.isCardBgHide ? Visibility.None : Visibility.Visible)
        .backgroundColor(this.cardVm.getCardBgColor())
        .backgroundBrightnessInternal(this.cardVm.cardBgBrightness)
        .accessibilityLevel('no')

        Column() {
          if (this.cardVm.isMoreBrief()) {
            NotificationMoreBriefView()
          } else if (this.cardVm.isPrivacy) {
            NotificationPrivacyView({ ntf: this.ntf })
          } else if (this.ntf.isLiveView() && !this.ntf.isMediaPlayer()) {
            NotificationLiveCardView({
              live: this.ntf,
              displayButtonsHashCode: NotificationNormalVm.expandActionButtonMap.get(this.ntfVmInjector.scene)
            })
          } else if (this.ntf.isLiveView() && this.ntf.isMediaPlayer()) {
            MediaPlaybackControllerItem({
              onIconClickV2: this.cardVm.onMediaCenterIconClick,
              isScreenLock: Boolean(this.cardVm.onMediaCenterIconClick),
              notifyId: this.ntf.hashCode,
              isNotificationFromDeviceChange: (this.ntf.card as LiveCardSystemModel)?.title === '',
              itemData: undefined,
              // 首次通知面板显示时才创建投播进程
              ntfPanelVisible: this.ntfVmInjector.getPanelVm().isVisible
            })
          } else if (this.ntf.isNormal() || this.ntf.isNormalGroup()) {
            // animateTo中改变if的判断条件，实现卡片的一镜到底动效
            if (this.cardVm.showGroup) {
              NotificationNormalGroupView({ ntf: (this.ntf as NormalNotificationGroup) })
            } else {
              NotificationNormalView({ ntf: (this.ntf as NormalNotification) })
            }
          }
        }
        .id(this.cardVm.contentId)
        .size(this.cardVm.containerSize)
        .borderRadius(NotificationConfig.BORDER_RADIUS)
        .clip(true)
        .scale(this.cardVm?.cardContentScale)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .onGestureJudgeBegin((info) => {
          return this.cardVm?.onGestureJudgeBegin(info);
        })
        .onClick(() => {
          this.cardVm.onClick(this.ntf);
        })
        .alignRules(this.cardVm.containerSize ? {
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          center: { anchor: '__container__', align: VerticalAlign.Center },
        } : {})
        .accessibilityLevel(this.ntf.isLiveView() ? 'yes' : 'no')
        .accessibilityDescription(this.cardVm.accessibilityDescription)
      }
      .size(this.cardVm.contentSize)
      .offset({ start: LengthMetrics.vp(this.swipeVm?.offsetX) })
      .onGestureJudgeBegin((info) => {
        return this.cardVm?.onGestureJudgeBegin(info);
      })
      .gestureModifier(this.ntfVmInjector.viewName === ViewName.DROPDOWN_VIEW ? undefined : this.baseGesture)
      // 无背景时无需模糊
      .useEffect(!this.cardVm.isCardBgHide && this.cardVm.isUseEffect)
      .borderRadius(NotificationConfig.BORDER_RADIUS)
      .clip(this.cardVm.contentClipParam)
      .shadow(this.cardVm.shadow)

      // 性能、内存优化：默认不创建卡片菜单组件，卡片滑动时才创建.
      if (this.swipeVm?.offsetX !== 0) {
        NotificationMenuView({ ntf: this.ntf })
      }
    }
    .id(this.cardVm.componentId)
    .borderRadius(NotificationConfig.BORDER_RADIUS)
    .gestureModifier(this.ntfVmInjector.viewName === ViewName.DROPDOWN_VIEW ? this.baseGesture : undefined)
    .clip(this.cardVm.containerClip)
    .translate({ y: this.cardVm.translateY })
    .scale({
      x: this.cardVm.scale * this.cardVm.itemClickScale,
      y: this.cardVm.scale * this.cardVm.itemClickScale,
      // centerY和rotate冲突，scale需要放到rotate后面
      centerX: '50%',
      centerY: this.cardVm.scaleCenterY
    })
    .position(this.cardVm.position)
    .opacity(this.cardVm.opacity)
    .enabled(this.cardVm.opacity !== 0)
    .width(this.cardVm.cardWidth)
    .height(this.cardVm.containerSize?.height)
    .zIndex(this.cardVm.zIndex)
    .onTouch((event) => this.cardVm.onTouch(event))
    .enabled(this.cardVm.cardEnable)
    .onSizeChange(this.cardVm.onSizeChange)
    .onAreaChange(this.cardVm.onAreaChange)
  }
}