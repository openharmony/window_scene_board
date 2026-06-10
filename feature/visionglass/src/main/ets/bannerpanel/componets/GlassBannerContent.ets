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

import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import { BannerHeadsUpContentCallBack, BannerPanelContentVM } from '../vm/GlassBannerContentVM';
import { GlassNtfSingleItem } from '../componets/GlassNtfSingleItem';
import { GlassBannerPanelManager } from '../manager/GlassBanerPanelManager';
import { BannerSwipeYController, SwipeYCallback } from '../controller/BannerSwipeYController';
import { GlassBannerContentStyle } from '../view/GlassBannerStyle';
import DateTime from '../../common/utils/DateTime';
import { Rect } from '../../scene/common/GlassSceneManager';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'GlassBannerContent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassBannerContent {
  @Provide ntf: NotificationEntry | null = null;
  @Provide mDateTime: DateTime = new DateTime();
  @Provide @Watch('updateExpand') ntfExpand: boolean = false;
  @State @Watch('updateSwipeBanner') style: GlassBannerContentStyle = new GlassBannerContentStyle();
  private bannerSwipeYController: BannerSwipeYController = new BannerSwipeYController();

  aboutToAppear(): void {
    log.info(`aboutToAppear`);
    BannerPanelContentVM.getInstance().init(this as BannerHeadsUpContentCallBack);
    this.bannerSwipeYController.registerSwipeCallback(this as SwipeYCallback);
    this.mDateTime.init(getContext(this));
  }

  aboutToDisappear(): void {
    log.info(`aboutToDisAppear`);
    BannerPanelContentVM.destroyInstance();
    this.mDateTime.release();
  }

  public getNtf(): NotificationEntry | null {
    return this.ntf;
  }

  public notifyNtfChange(ntf: NotificationEntry | null): void {
    log.showInfo(`notifyNtfChange,ntf is null ${!ntf}`);
    this.ntf = ntf;
    if (!this.ntf) {
      log.showInfo(`onNtfChange,ntf is invalid`);
      return;
    }
    GlassBannerPanelManager.getInstance().updateWindowRectByNtfType(this.ntf, this.ntfExpand);
    this.onNtfChange();
  }

  private onNtfChange(): void {
    log.showInfo(`onNtfChange`);
    BannerPanelContentVM.getInstance().resetWatcher();
    if (this.ntf === null) {
      this.ntfExpand = false;
    } else {
      this.ntfExpand = this.ntf.isItemExpanded;
    }
  }

  private updateSwipeBanner(): void {
    const rect: Rect | undefined = GlassBannerPanelManager.getInstance().getPanelRect();
    if (rect) {
      GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_BANNER, rect);
    }
  }

  private updateExpand(): void {
    log.info('updateExpand')
    if (this.ntfExpand) {
      log.info('updateExpand addWatcher');
      BannerPanelContentVM.getInstance().addWatcher();
    } else {
      log.info('updateExpand removeWatcher');
      BannerPanelContentVM.getInstance().removeWatcher();
    }
  }

  public onUpdateItemTranY(tranY: number, itemAnim?: AnimateParam): void {
    if (!itemAnim) {
      this.style.bannerTranY = tranY;
    } else {
      animateTo(itemAnim, () => {
        this.style.bannerTranY = tranY;
      });
    }
  }

  public onHideBanner(): void {
    log.info('onHideBanner');
    if (!this.ntf) {
      return;
    }
    this.style.bannerTranY = 0;
    BannerPanelContentVM.getInstance().cancelNtf(this.ntf, false);
  }

  build() {
    if (this.ntf) {
      Stack({ alignContent: Alignment.Bottom }) {
        GlassNtfSingleItem()
      }
      .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.All })
          .onActionStart((event) => {
            log.info('onActionStart');
            BannerPanelContentVM.getInstance().addWatcher();
            this.bannerSwipeYController.onStartSwipe(event);
          })
          .onActionUpdate((event) => {
            log.info('onActionUpdate');
            this.bannerSwipeYController.onUpdateSwipe(event);
          })
          .onActionEnd((event) => {
            log.info('onActionEnd');
            this.bannerSwipeYController.onEndSwipe(event);
            BannerPanelContentVM.getInstance().removeWatcher();
          })
          .onActionCancel(() => {
            log.info('onActionCancel');
            this.bannerSwipeYController.onCancelSwipe();
            BannerPanelContentVM.getInstance().removeWatcher();
          }),
        TapGesture()
          .onAction(() => {
            log.showInfo(`TapGesture,click banner hashcode is ${this.ntf?.hashCode},ntfExpand ${this.ntfExpand}`);
            BannerPanelContentVM.getInstance().clickNtf();
          }),
        LongPressGesture({ repeat: false })
          .onAction(() => {
            log.showInfo(`LongPressGesture,onAction addWatcher`);
            BannerPanelContentVM.getInstance().addWatcher();
          })
          .onActionEnd(() => {
            log.showInfo(`LongPressGesture,onActionEnd removeWatcher`);
            BannerPanelContentVM.getInstance().removeWatcher();
          })
          .onActionCancel(() => {
            log.showInfo(`LongPressGesture,onActionCancel removeWatcher`);
            BannerPanelContentVM.getInstance().removeWatcher();
          })
      ))
      .size({
        height: '100%',
        width: '100%'
      })
    }
  }
}