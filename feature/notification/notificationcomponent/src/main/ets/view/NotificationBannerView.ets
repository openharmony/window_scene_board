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

import {
  BaseGesture,
  INotificationSwipeVm,
  NotificationVmInjector,
  BannerVm,
  NotificationIconView,
  INotificationVerticalSwipeVm,
  INotificationBannerVm,
  ResourceVm
} from '@ohos/systemuicommon/newIndex';
import { bannerMgr, BannerPanelType } from '@ohos/systemuicommon';
import { NotificationImmersiveView } from './NotificationImmersiveView';
import { NormalNotification, SystemUIUseScene } from '@ohos/systemuicommon/newTsIndex';
import { LogDomain, Logger, TraceUtil, DomainName } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationBannerVmInjectorFactory } from '../variant/banner/vm/NotificationBannerVmInjectorFactory';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationCardView } from './NotificationCardView';
import { NotificationBannerLiveVmInjector } from '../variant/banner/vm/NotificationBannerLiveVmInjector';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { OutdoorVm } from '@ohos/systemuicommon/src/main/ets/vm/OutdoorVm';

const TAG = 'NotificationBannerView';
const log: Logger = Logger.getLogHelper(LogDomain.NC);

/**
 * 横幅通知内容组件，横幅根布局
 */
@ComponentV2
export struct NotificationBannerView {
  @Provider() ntfVmInjector: NotificationVmInjector = NotificationBannerVmInjectorFactory.get();

  // 实况2.0场景，实况横幅使用单独的组件显示，通知横幅无需处理实况
  @Provider() liveVmInjector: NotificationBannerLiveVmInjector | undefined =
    SystemUICcmConfig.instance.isEnabledLive2 ? undefined : NotificationBannerLiveVmInjector.instance;

  @Param @Require screenId: number;

  @Param persistentId: number = 0;

  @Param bannerVm: BannerVm = BannerVm.instance;

  @Computed
  get notificationBannerVm(): INotificationBannerVm {
    return this.ntfVmInjector.getBannerVm();
  }

  @Computed
  get verticalSwipeVm(): INotificationVerticalSwipeVm | undefined {
    return this.ntfVmInjector.getVerticalSwipeVm();
  }

  private _contentGesture = new BaseGesture();

  @Computed
  get contentGesture(): BaseGesture | undefined {
    if (!this.verticalSwipeVm || !this.swipeVm) {
      log.showWarn(TAG, 'No verticalSwipeVm or swipeVm, no contentGesture');
      this._contentGesture.destroy();
    } else {
      // 从沉浸态切换到展开态，会重新add，导致冲突，先清理再add
      log.showInfo(TAG, 'Add banner gesture');
      this._contentGesture.destroy();
      this._contentGesture.addGesture(this.swipeVm.getPanGestureHandler());
      this._contentGesture.addGesture(this.verticalSwipeVm.getVerticalSwipeGesture());
    }
    return this._contentGesture;
  }

  @Computed
  get swipeVm(): INotificationSwipeVm | undefined {
    if (!this.notificationBannerVm.ntf) {
      return undefined;
    }
    return this.ntfVmInjector.getSwipeVm(this.notificationBannerVm.ntf);
  }

  aboutToAppear() {
    log.showInfo(TAG, `aboutToAppear`);
    this.notificationBannerVm.persistentId = this.persistentId;
    this.notificationBannerVm.init();
  }

  aboutToDisappear() {
    log.showInfo(TAG, `aboutToDisAppear`);
    this.notificationBannerVm.destroy();
  }

  private getContainerId(): string {
    log.showInfo(TAG, `getContainerId`);
    TraceUtil.traceOnce(DomainName.NC, 'getContainerId');
    return this.ntfVmInjector.getId(`${TAG}_${this.notificationBannerVm?.ntf?.hashCode}`);
  }

  private getCondition(): NormalNotification | undefined {
    log.showInfo(TAG, `getCondition: ${this.notificationBannerVm?.ntf?.toSimpleString()}`);
    TraceUtil.traceOnce(DomainName.NC, 'getCondition');
    return this.notificationBannerVm.ntf;
  }

  build() {
    // 该判断必须放外层，否则横幅收起动效不生效
    if (this.getCondition()) {
      Column() {
        Row() {
          NotificationCardView({
            ntf: this.notificationBannerVm.ntf,
            index: 0
          })
          if (this.notificationBannerVm.isShowImmersive) {
            NotificationImmersiveView({
              ntf: this.notificationBannerVm.ntf as NormalNotification
            })
          }
          if (this.verticalSwipeVm?.isSupportFloating && !OutdoorVm.instance.isInOutdoorMode) {
            this.buildDropBar()
          }
        }
        .id(this.ntfVmInjector.getId(`${TAG}_inner`))
        .margin(this.notificationBannerVm.margin)
        .gestureModifier(this.contentGesture)
        .width(this.notificationBannerVm.containerWidth)
        .height(this.notificationBannerVm.containerHeight)
        .borderRadius(NotificationConfig.BORDER_RADIUS)
        .clip(this.notificationBannerVm.containerClip)
        .scale(this.notificationBannerVm.containerScaleOptions)
        .onTouch(this.notificationBannerVm.onTouch)
        .onAreaChange((oldArea: Area, newArea: Area) => {
          log.showInfo(TAG, `Inner area change, width: ${newArea.width}, height: ${newArea.height}` +
            `, x: ${newArea.globalPosition?.x}, y: ${newArea.globalPosition?.y}`);
          this.verticalSwipeVm?.initBannerDeformParam(Number(newArea.height));
          bannerMgr.setResponseRegion(newArea, BannerPanelType.TYPE_HEADS_UP);
        })
      }
      .id(this.getContainerId())
      .scale({ x: this.notificationBannerVm.scaleX, y: this.notificationBannerVm.scaleY })
      .width('100%')
      .position({ x: 0, y: 0 })
      // 整体竖向位移
      .translate({
        x: this.notificationBannerVm.containerTranslateX,
        y: this.notificationBannerVm.containerTranslateY
      })
      // 横幅弹出、收起动效
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.translate({ x: 0, y: NotificationConfig.HEADS_UP_EFFECT_TRAN_Y })
          .animation(NotificationConfig.HEADS_UP_SHOW_ANIM_PARAM),
        BannerVm.instance.isLivePanel() ? TransitionEffect.IDENTITY :
        this.notificationBannerVm.headsUpTransitionEffect))
      .alignItems(HorizontalAlign.Center)
      .visibility(BannerVm.instance.isHeadsUp() ? Visibility.Visible : Visibility.None)
      .onDisAppear(this.notificationBannerVm.onDisappear)
    }
  }

  @Builder
  buildDropBar() {
    // 下拉条
    Image($r('app.media.ic_ntf_drop'))
      .objectFit(ImageFit.Fill)
      .width($r('app.float.ntf_heads_up_drop_width'))
      .height($r('app.float.ntf_heads_up_drop_height'))
      .fillColor($r('app.color.ntf_heads_up_drop_color'))
      .position({
        left: '50%',
        bottom: this.notificationBannerVm.isShowImmersive && !this.notificationBannerVm.isImmersiveExpanded ? 4 : 6
      })
      .markAnchor({ x: 24 })
      .zIndex(2)
      .opacity(this.verticalSwipeVm?.bannerDeformState.bannerTextOpacity)
      // 避免遮挡下面的卡片点击事件
      .hitTestBehavior(HitTestMode.None)
      .translate({ x: ResourceVm.instance.isRTL ? -(this.swipeVm?.offsetX ?? 0) : this.swipeVm?.offsetX })

    // 蒙层
    if (this.verticalSwipeVm?.bannerDeformState.bannerMaskingVisibility) {
      Stack({ alignContent: Alignment.Center }) {
        NotificationIconView({
          scene: SystemUIUseScene.BANNER_MASK,
          ntf: this.notificationBannerVm.ntf!,
          scale: this.notificationBannerVm.floatingLayerIconScale
        })
      }
      .id(this.ntfVmInjector.getId(`${TAG}_mask`))
      .position({ left: 0, top: 0 })
      .clip(true)
      .zIndex(3)
      .backgroundColor($r('app.color.banner_to_floating_mask_color'))
      .width(this.verticalSwipeVm.isDeformFlag ? '100%' : 0)
      .height(this.verticalSwipeVm.isDeformFlag ? '100%' : 0)
      .opacity(this.verticalSwipeVm.bannerDeformState.bannerMaskingOpacity)
      .borderRadius(NotificationConfig.BORDER_RADIUS)
    }
  }
}