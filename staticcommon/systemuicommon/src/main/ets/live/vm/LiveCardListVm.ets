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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../model/LiveNotification';
import { LiveBaseVm } from './LiveBaseVm';
import { ILiveCardListVm } from '../interface/ILiveCardListVm';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { BannerOutsideState, BannerPanelType } from '../../banner/common/info/BannerState';
import { OnStateChangeListener } from '@ohos/systemuiutils/src/main/ets/sysdialog/StateListenerRegister';
import { StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { NotificationArray } from '../../model/NotificationBase';
import { LiveType } from '../model/LiveCommonModel';
import { LiveCardAnimation } from '../animation/LiveCardAnimation';
import { BannerVm } from '../../vm/BannerVm';
import { LiveCardUpdateAnimation } from '../animation/LiveCardUpdateAnimation';
import { AnimationBase } from '../../animation/AnimationBase';
import { AppLifeCycleManager } from '../../manager/AppLifeCycleManager';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { ILiveSwitchVm } from '../interface/ILiveSwitchVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { TrimLevel, ViewType } from '@ohos/frameworkwrapper';
import { ViewManagerAdapter, ViewMgrPolicyViewCallback } from '../../adapter/ViewManagerAdapter';
import { DeviceModeEnum } from '@ohos/commonconstants';
import { OutdoorVm } from '../../vm/OutdoorVm';

const TAG = 'LiveCardListVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardListVm extends LiveBaseVm implements ILiveCardListVm {
  @Trace public readonly liveList: NotificationArray<LiveNotification> = new NotificationArray();
  @Trace public readonly liveMap: Map<string, LiveNotification> = new Map();
  @Trace public readonly excludeCapsuleSet: Set<string> = new Set();
  @Trace public listEventResponseArea?: Area;
  @Trace public listOpacity: number = 0;
  @Trace public listScale = 1;
  @Trace public listEdgeEffect = EdgeEffect.Spring;
  @Trace public enableScroll: boolean = true;
  @Trace public isUseStaticEffect: boolean = false;
  @Trace public isShowHeaderBlur: boolean = false;
  public scroller = new ListScroller();
  private cardUpdateAnimation = new LiveCardUpdateAnimation(this.vmInjector);
  private cardAddAnimation = new AnimationBase(AnimationBase.NAMES.LIVE_CARD_ADD_ANIMATION, true);
  private isTouchAfterReachEnd = false;
  private startY: Array<number> = [];
  private inOneScreen: boolean = false;
  protected  deviceInfoVm = DeviceInfoVm.instance;
  public isListRebound: boolean = false;
  public isAlreadyReachStart: boolean = true;
  public isAlreadyReachEnd: boolean = false;

  @Computed
  private get switchVm(): ILiveSwitchVm {
    return this.vmInjector.getSwitchVm();
  }

  @Computed
  public get containerWidth(): Length {
    for (const live of this.liveList) {
      if (this.vmInjector.getCardMenuVm(live).isTouching) {
        this.vmInjector.getSwitchVm().setDynamicByScene();
        return '100%';
      }
      continue;
    }
    return 'auto';
  }


  @Monitor('deviceInfoVm.deviceMode')
  onDeviceModeChange(): void {
    log.showWarn(`onDeviceModeChange: ${this.deviceInfoVm.deviceMode}`);
    if (this.deviceInfoVm.deviceMode === DeviceModeEnum.BASE_MODE) {
      return;
    }
    this.vmInjector.getSwitchVm().hidePanel();
  }

  /**
   * 处理面板外部区域触摸事件
   */
  private onTouchOutside: OnStateChangeListener = {
    onStateChange: async (outsideState): Promise<void> => {
      bannerMgr.runScopedTask(() => {
        this.handleOnTouchOutSide(outsideState as BannerOutsideState);
      });
    },
    getExtendType: (): number => {
      // 只监听实况面板外部触摸
      return BannerPanelType.TYPE_LIVE_LIST;
    }
  };

  private async handleOnTouchOutSide(outsideState: BannerOutsideState): Promise<void> {
    // 触摸时，面板处于未显示的状态，则不响应此事件
    if (outsideState?.currentPanelType !== BannerPanelType.TYPE_LIVE_LIST) {
      log.showWarn('TouchOutside banner type is not live list:' + outsideState.currentPanelType);
      return;
    }
    if (!this.listEventResponseArea) {
      log.showWarn('TouchOutside error, listArea is null');
      return;
    }
    // 下拉双中心时，由于实况卡片宽度未占满全屏
    // touch的x在实况卡片区域外时，isTouchInArea=false，需要避免执行collapse动效导致黑影
    if (outsideState.touchY < ArkUIAdapter.vp2px(BannerVm.instance.containerMarginTop)) {
      log.showWarn(`TouchOutside, top area`)
      return;
    }
    // 退出单手模式时，面板不收起
    if (outsideState.touchX > this.deviceInfoVm.width || outsideState.touchX < 0 ||
      outsideState.touchY > this.deviceInfoVm.height || outsideState.touchY < 0) {
      log.showWarn('TouchScreenOutside, exit SingleHandMode');
      return;
    }
    const isTouchInArea = this.checkPointInArea(outsideState.touchX, outsideState.touchY, this.listEventResponseArea);
    log.showWarn('TouchOutside, isTouchInArea:' + isTouchInArea);
    if (!isTouchInArea) {
      if (this.checkIsTouchMenu()) {
        return;
      }
      this.enableScroll = false;
      if (!CutoutVm.instance.isMiddleCutout()) {
        if (this.isListRebound) {
          // 列表触顶触底回弹时点击收回卡片，延迟350ms等待回弹效果结束
          await SystemUICommonUtil.sleep(350);
        } else {
          // 列表滑动时点击收回卡片，需要让列表停止滑动
          this.scroller.scrollTo({
            xOffset: this.scroller.currentOffset().xOffset,
            yOffset: this.scroller.currentOffset().yOffset,
            animation: { duration: 0, canOverScroll: true }
          });
          await SystemUICommonUtil.sleep(100);
        }
      }
      this.vmInjector.getSwitchVm().collapseCardToCapsule();
    }
  }

  public onListReachStartOrEnd(isReachTop: boolean): void {
    this.isAlreadyReachStart = isReachTop;
    this.isAlreadyReachEnd = !isReachTop;
    this.isListRebound = !this.isListRebound;
  }

  public init(): void {
    bannerMgr.registerStateChangeListener(StateType.TYPE_BANNER_OUTSIDE, this.onTouchOutside);
    ViewManagerAdapter.registerViewCallback(this.viewCallback, `${TAG}_registerViewCallback`);
  }

  public destroy(): void {
    ViewManagerAdapter.unRegisterViewCallback(this.viewCallback, `${TAG}_unRegisterViewCallback`);
  }

  private viewCallback: ViewMgrPolicyViewCallback = {
    viewType: ViewType.NOTIFICATION_BANNER,
    onTrimMemory: (level: TrimLevel): void => {
      log.showInfo('liveCardListVm onReleaseMemory');
      switch (level) {
        case TrimLevel.COMPLETE:
          if (BannerVm.instance.bannerType === BannerPanelType.TYPE_NONE) {
            this.clearLiveList();
          }
          break;
      }
    },
  }

  public initLiveList(liveList: LiveNotification[]): void {
    this.listEdgeEffect = EdgeEffect.Spring;
    this.clearLiveList();
    for (const live of liveList) {
      if (this.checkShouldAdd(live)) {
        this.liveList.push(live);
        this.liveMap.set(live.hashCode, live);
      }
    }
    log.showWarn(`Init live list, length: ${this.liveList.length}`);
    this.liveList.sort();
  }

  public async addLive(live: LiveNotification): Promise<void> {
    if (!BannerVm.instance.isLivePanel()) {
      log.showWarn('Live panel is not shown');
      return;
    }
    if (!this.checkShouldAdd(live)) {
      return;
    }
    await this.cardAddAnimation.executeAnimation([{
      duration: 350,
      curve: Curve.Friction,
      event: () => this.addAndSortLive(live)
    }]);
  }

  public localUpdateLiveList(liveList: LiveNotification[]): void {
    if (!BannerVm.instance.isLivePanel()) {
      log.showInfo('Live panel is not shown');
      return;
    }
    for (const live of liveList) {
      this.updateLive(live);
    }
    this.liveList.sort();
  }

  public remoteUpdateLive(live: LiveNotification): void {
    if (!BannerVm.instance.isLivePanel() || this.switchVm.isCollapsing) {
      log.showInfo('Live panel is not shown');
      return;
    }

    const i = this.liveList.findIndex((item) => item.hashCode === live.hashCode);
    // 不在列表中的卡片走添加动效
    if (i >= 5) {
      this.liveList.splice(i, 1);
      this.cardAddAnimation.executeAnimation([{
        duration: 350,
        curve: Curve.Friction,
        event: () => this.addAndSortLive(live)
      }]);
      this.vmInjector.updateVmByLive(live, TAG);
      return;
    }

    const index = this.updateLive(live);
    if (index < 0) {
      return;
    }
    if (index === 0) {
      this.liveList.sort();
    } else {
      this.cardUpdateAnimation.sort(index);
    }
  }

  public removeLiveList(liveList: LiveNotification[]): void {
    const cardAnimation = new LiveCardAnimation(this.vmInjector);
    if (!BannerVm.instance.isLivePanel()) {
      this.doRemove(liveList)
    } else {
      cardAnimation.removeCard(() => {
        this.doRemove(liveList)
      });
    }
  }

  public clearLiveList(): void {
    this.liveList.clear();
    this.liveMap.clear();
    this.excludeCapsuleSet.clear();
  }

  private doRemove(liveList: LiveNotification[]): void {
    for (const live of liveList) {
      log.showWarn(`Remove live card ${live.hashCode}`);
      this.liveList.remove(live.hashCode);
      this.liveMap.delete(live.hashCode);
    }
    if (BannerVm.instance.isLivePanel() && this.liveList.length === 0) {
      this.vmInjector.getSwitchVm().hidePanel();
    }
  }

  public onScrollIndexChange = (start: number, end: number, center: number): void => {
    log.showInfo(`on scroll index change: from ${start} to ${end}`);
    this.inOneScreen = false;
    const lastIndex = this.liveList.slice(0, 5).length + 1;
    if (end === lastIndex && start === 0) {
      // 部分设备一屏实况底部的空白item可能会超出，导致视觉上一屏实况却需要滑动两次才会收起
      this.inOneScreen = true;
    }
  }

  public onListAreaChange(area: Area): void {
    log.info('On list area change:', area);
    this.listEventResponseArea = area;

    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP) ||
      bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP)) {
      log.showInfo(`other pannel showing, no need set card list hot area`);
      return;
    }
    bannerMgr.setResponseRegion(area, BannerPanelType.TYPE_LIVE_LIST);
  }

  public onListTouch = async (event: TouchEvent): Promise<void> => {
    if (event.type === TouchType.Down) {
      log.showInfo(`onListTouch, isReachEnd: ${this.scroller.isAtEnd()}`);
      this.listEdgeEffect = EdgeEffect.Spring;
      this.startY[event.changedTouches[0].id] = event.changedTouches[0].windowY;
      if (this.scroller.isAtEnd() || this.inOneScreen) {
        this.isTouchAfterReachEnd = true;
      } else {
        this.isTouchAfterReachEnd = false;
      }
    } else if (event.type === TouchType.Move) {
      let offsetY = event.changedTouches[0].windowY - this.startY[event.changedTouches[0].id];
      let isMoveUp = offsetY < 0;

      if ((this.isAlreadyReachStart && offsetY > 0) || (this.isAlreadyReachEnd && offsetY < 0)) {
        this.isListRebound = true;
      } else {
        this.isListRebound = false;
      }

      if (this.isTouchAfterReachEnd && isMoveUp && Math.abs(offsetY) > 40) {
        this.isTouchAfterReachEnd = false;
        if (this.checkIsTouchMenu()) {
          log.showInfo('onListTouch has touching menu, not collapse');
          return;
        }
        if (this.checkIsShowMenu()) {
          log.showInfo('onListTouch has showing menu, not collapse');
          return;
        }
        // 列表至底部时，判断TouchY的距离阈值收起卡片
        log.showInfo(`onListTouch move to collapse: offsetY: ${offsetY}}`)
        this.vmInjector.getSwitchVm().collapseCardToCapsule();
      }
    } else {
      if (event.touches.length === 0) {
        this.startY = [];
      }
    }
  };

   public onListWillScroll(offsetTop: number, scrollState: ScrollState): void {
    // 从底部向上滑动一定距离后收起卡片列表
    if (this.isTouchAfterReachEnd && scrollState === ScrollState.Scroll) {
      if (offsetTop > 0) {
        this.listEdgeEffect = EdgeEffect.None;
        return;
      }
      this.isTouchAfterReachEnd = false;
      this.listEdgeEffect = EdgeEffect.Spring;
    }
  }

   public resetOpacity(): void {
     this.listOpacity = 0;
     for (const live of this.liveList) {
       const itemVm = this.vmInjector.getCardListItemVm(live);
       itemVm.containerOpacity = 0;
     }
   }

  private checkIsShowMenu(): boolean {
     for (const live of this.liveList) {
       const menuVm = this.vmInjector.getCardMenuVm(live);
       const itemVm = this.vmInjector.getCardListItemVm(live);
       if (menuVm && itemVm.containerOffsetX !== 0) {
         menuVm.reset('self');
         return true;
       }
     }
     return false;
   }

   private checkIsTouchMenu(): boolean {
     for (const live of this.liveList) {
       const menuVm = this.vmInjector.getCardMenuVm(live);
       if (menuVm.isTouching) {
         return true;
       }
     }
     return false;
   }

  public async resetList(): Promise<void> {
     if (this.checkIsShowMenu()) {
       await SystemUICommonUtil.sleep(300);
     }
  }

  public async scrollToTop(): Promise<void> {
    this.scroller.scrollEdge(Edge.Top);
  }

  public onPanelHide(): void {}


  public onPanelShow(): void {}

  private updateLive(live: LiveNotification): number {
    const index = this.liveList.findIndex((item) => item.hashCode === live.hashCode);
    if (index < 0) {
      log.showWarn(`Update live failed, not find live: ${live.hashCode}`);
      return index;
    }
    log.showInfo(`Update live card ${live.hashCode}`);
    this.liveList[index] = live;
    this.liveMap.set(live.hashCode, live);
    this.vmInjector.updateVmByLive(live, TAG);
    return index;
  }

  private checkShouldAdd(live: LiveNotification): boolean {
    if (!OutdoorVm.instance.isInOutdoorAppList(live)) {
      log.showWarn(`Add faield, ${live.creatorBundleName} is not in OutdoorAppList`);
      return false;
    }
    if (this.liveList.includes(live)) {
      log.showWarn(`Add faield, duplicate live: ${live.hashCode}`);
      return false;
    }
    if (live.type === LiveType.INSTANT) {
      log.showInfo(`Instant live not need card: ${live.hashCode}`)
      return false;
    }
    if (AppLifeCycleManager.instance.isForeground(live.creatorUid, live) && !live.capsule?.sticky) {
      log.showWarn(`Add faield for ${live.hashCode}, App ${live.creatorBundleName}_${live.creatorUid} is foreground`);
      return false;
    }
    log.showInfo(`Add live card ${live.hashCode}`);
    return true;
  }

  private addAndSortLive(live: LiveNotification): void {
    this.liveList.push(live);
    this.liveMap.set(live.hashCode, live);
    this.liveList.sort();
  }

  public getCardLeftMargin(): number {
    if (BannerVm.instance.isCardCenterLayout()) {
      return (ArkUIAdapter.px2vp(this.deviceInfoVm.width) - BannerVm.instance.cardListWidth) / 2;
    }
    return this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace;
  }
}