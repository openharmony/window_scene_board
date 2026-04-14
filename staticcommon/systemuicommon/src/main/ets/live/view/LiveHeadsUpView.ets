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
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { BannerVm } from '../../vm/BannerVm';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveHeadsUpSwipeVm } from '../interface/ILiveHeadsUpSwipeVm';
import { LiveVmInjectorFactory } from '../LiveVmInjectorFactory';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LiveHeadsUpCommonCardView } from './LiveHeadsUpCommonCardView';
import { LiveHeadsUpWalletCardView } from './LiveHeadsUpWalletCardView';
import { LiveHeadsUpFaceLockView } from './LiveHeadsUpFaceLockView';
import { ILiveCardFloatingVm } from '../interface/ILiveCardFloatingVm';

const TAG = 'LiveHeadsUpView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveHeadsUpView {
  @Provider() liveVmInjector: ILiveVmInjector = LiveVmInjectorFactory.get();

  headsUpVm = this.liveVmInjector.getLiveHeadsUpVm();

  @Computed get headsUpSwipeVm(): ILiveHeadsUpSwipeVm | undefined {
    if (this.headsUpVm.live) {
      const headUpSwipeVm = this.liveVmInjector.getLiveHeadsUpSwipeVm(this.headsUpVm.live);
      return headUpSwipeVm
    }
    return undefined;
  }
  @Computed get floatingVm(): ILiveCardFloatingVm | undefined {
    if (this.headsUpVm.live) {
      return this.liveVmInjector.getCardFloatingVm(this.headsUpVm.live);
    }
    return undefined;
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.headsUpVm.init();
  }

  build() {
    EffectComponent() {
      Stack({ alignContent: CutoutVm.instance.isMiddleCutout() ? Alignment.Center : Alignment.Start }) {
        Stack({ alignContent: this.floatingVm?.isDeformFlag ? Alignment.TopStart : Alignment.Center }) {
          if (this.headsUpVm.live && this.headsUpVm.showLive) {
            if (this.headsUpVm.showLive.isWallet()) {
              LiveHeadsUpWalletCardView()
            } else if (this.headsUpVm.showLive.isFaceLock()) {
              LiveHeadsUpFaceLockView()
            } else {
              LiveHeadsUpCommonCardView({ live: this.headsUpVm.showLive })
            }
          }
        }
        .id(this.headsUpVm.contentId)
        .size(this.headsUpVm.contentSize)
        .opacity(this.headsUpVm.contentOpacity)
        .panGestureStyle()
        .onTouch(this.headsUpVm.onTouchEvent)
        .onClick(() => this.headsUpVm.onClick())
        .accessibilityDescription(!this.headsUpVm.showLive?.wantAgent ? ' ' : '')
        .onAreaChange(this.headsUpVm.onListAreaChange)
      }
      .margin({
        start: this.headsUpVm.getCardMargin()
      })
      .size(this.headsUpVm.containerSize ? this.headsUpVm.containerSize :
        { width: this.headsUpVm.getContainerWidth(BannerVm.instance.cardListWidth)})
      .opacity(this.headsUpVm.containerOpacity)
    }
    .hitTestBehavior(this.headsUpVm?.showLive?.isFaceLock() ? HitTestMode.None : HitTestMode.Default)
    .align(this.headsUpVm.getCardAlign())
    .width('100%')
    .padding({ top: this.headsUpVm.getCardPadding()})
    .borderRadius(LiveStyle.CARD_RADIUS)
    .backgroundEffect({
      policy: 1,
      radius: 30
    })
    .translate({
      x: this.headsUpVm.contentOffsetX,
      y: this.headsUpVm.contentOffsetY
    })
    .visibility(this.headsUpVm.isLiveHeadsUp ? Visibility.Visible : Visibility.None)
    .zIndex(1)
  }

  @Styles
  panGestureStyle() {
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        GestureGroup(GestureMode.Parallel,
          // 横滑触摸手势
          PanGesture({ direction: PanDirection.Horizontal, distance: 5 })
            .onActionStart((event) => {
              if (this.headsUpSwipeVm) {
                this.headsUpSwipeVm.onHorizontalPanStart(event)
              }
            })
            .onActionUpdate((event) => {
              if (this.headsUpSwipeVm) {
                this.headsUpSwipeVm.onHorizontalPanUpdate(event);
              }
            })
            .onActionEnd((event) => {
              if (this.headsUpSwipeVm) {
                this.headsUpSwipeVm.onHorizontalPanEnd(event);
              }
            })
            .onActionCancel(() => {
              if (this.headsUpSwipeVm) {
                this.headsUpSwipeVm.onHorizontalPanCancel();
              }
            })
        ),
        // 竖滑触摸手势
        PanGesture({ direction: PanDirection.Vertical, distance: 5 })
          .onActionStart((event) => {
            if (this.headsUpSwipeVm) {
              this.headsUpSwipeVm.onVerticalPanStart(event);
            }
          })
          .onActionUpdate((event) => {
            if (this.headsUpSwipeVm) {
              this.headsUpSwipeVm.onVerticalPanUpdate(event);
            }
          })
          .onActionEnd((event) => {
            if (this.headsUpSwipeVm) {
              this.headsUpSwipeVm.onVerticalPanEnd(event);
            }
            log.showInfo(`onActionEnd`);
          })
          .onActionCancel(() => {
            if (this.headsUpSwipeVm) {
              this.headsUpSwipeVm.onVerticalPanCancel();
            }
          }),
      ))
  }
}