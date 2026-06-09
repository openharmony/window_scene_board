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

import { ILiveSwitchVm } from '../interface/ILiveSwitchVm';
import { LiveBaseVm } from './LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveCardListAnimation } from '../animation/LiveCardListAnimation';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { NotificationDataManager } from '../../manager/NotificationDataManager';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { AccessibilityVm } from '../../vm/AccessibilityVm';
import { LiveNotification } from '../model/LiveNotification';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { BannerPanelType } from '../../banner/common/info/BannerState';
import { EnvVm } from '../../vm/EnvVm';
import { DeviceRotateVm } from '../../vm/DeviceRotateVm';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { BannerVm } from '../../vm/BannerVm';

import { ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';

const TAG = 'LiveSwitchVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况胶囊和卡片切换VM
 */
@ObservedV2
export class LiveSwitchVm extends LiveBaseVm implements ILiveSwitchVm {
  /**
   * 冻结数据更新时长
   */
  private readonly FREEZE_DURATION = 1500;
  /**
   * 胶囊展开比卡片收起的延迟时间
   */
  private readonly CAPSULE_EXPAND_DELAY = 50;
  /**
   * 卡片展开相比动画开始时的时延
   */
  private readonly EXPAND_DELAY: number = 350;
  /**
   * 卡片展开相比动画开始时的时延
   */
  private readonly HEADS_UP_HIDE_TIME: number = 220;
  /**
   * 无孔卡片展开相比动画开始时的时延
   */
  private readonly EXPAND_DELAY_WITHOUT_HOLE: number = 230;
  /**
   * 动态模糊到静态模糊过渡间隔，保持和双中心一致
   */
  private readonly STATIC_BLUR_TIME = 30000;

  private bannerAppearPromise?: CustomPromise<void>;
  /**
   * 展开卡片的计时器ID
   */
  private expandCardTimerId?: number;
  private expandCardPromise?: CustomPromise<void>;
  private staticBlurTimerId?: number;

  @Trace public isExpanding: boolean = false;
  @Trace public isCollapsing: boolean = false;
  public envVm = EnvVm.instance;
  private deviceRotateVm = DeviceRotateVm.instance;

  @Monitor('envVm.isSingleHandMode')
  onSingleHandMode(): void {
    if (!this.envVm.isSingleHandMode) {
      log.showInfo(`start set dynamicEffect by SingleHandMode ${SystemEffectVm.instance.isLiteMode()}, ${this.vmInjector.getCardListVm()
        .isUseStaticEffect}`);
      this.setDynamicByScene(1000);
    }
  }

  public setDynamicByScene(duration: number = 0): void {
    if (SystemEffectVm.instance.isLiteMode()) {
      this.setDynamicEffect(duration);
      return;
    }
    if (this.vmInjector.getCardListVm().isUseStaticEffect) {
      this.setDynamicEffect(this.STATIC_BLUR_TIME);
    }
  }

  @Monitor('deviceRotateVm.isInRotateAnim')
  onDeviceRotateVm(): void {
    if (SystemEffectVm.instance.isLiteMode() && !this.deviceRotateVm.isInRotateAnim) {
      log.showInfo(`start set dynamicEffect by rotate`);
      this.setDynamicEffect(500);
    }
  }

  private get capsuleList(): LiveNotification[] {
    return this.vmInjector.getCapsuleListVm().liveList.filter((live) => {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      return !capsuleVm.isToDelete;
    });
  }

  public onPanelSizeChange = (_: SizeOptions, size: SizeOptions): void => {
    log.showInfo(`onListContainerSizeChange, width: ${size.width}, height: ${size.height}`);
    this.bannerAppearPromise?.resolve();
    this.bannerAppearPromise = undefined;

    if ((size.height as number) === 0 && (size.width as number) === 0) {
      this.closeStaticEffect();
      this.vmInjector.getCardListVm().onPanelHide();
    } else {
      this.updateStaticEffect();
      this.vmInjector.getCardListVm().onPanelShow();
    }

    if ((size.height as number) === 0) {
      this.vmInjector.getCapsuleListVm().viewManager.moveToStatusBar();
    } else {
      this.vmInjector.getCapsuleListVm().viewManager.moveToBanner();
    }
  };

  /**
   * 面板收起时关闭静态模糊，避免下次面板出现时动态模糊不生效
   */
  private closeStaticEffect(): void {
    if (this.staticBlurTimerId != undefined) {
      clearTimeout(this.staticBlurTimerId);
      this.staticBlurTimerId = undefined;
      log.showInfo('clear staticBlurTimerId due to panel hide');
    }
    this.vmInjector.getCardListVm().isUseStaticEffect = false;
  }

  /**
   * 考虑功耗开销，面板size发生变化时（如折叠屏开合），需先关闭静态模糊，启用动态模糊，保证模糊效果正常
   * 30s后关闭动态模糊，避免一直执行动态模糊，功耗开销过大
   */
  private updateStaticEffect(): void {
    if (!SystemEffectVm.instance.isLiteMode()) {
      this.setDynamicEffect(this.STATIC_BLUR_TIME);
    } else {
      if (this.deviceRotateVm.isInRotateAnim) {
        this.vmInjector.getCardListVm().isUseStaticEffect = false;
        return;
      }
      this.vmInjector.getCardListVm().isUseStaticEffect = true;
    }
  }

  public setDynamicEffect(duration: number = 0): void {
    this.vmInjector.getCardListVm().isUseStaticEffect = false;
    if (this.staticBlurTimerId !== undefined) {
      clearTimeout(this.staticBlurTimerId);
      this.staticBlurTimerId = undefined;
      log.showInfo('clear staticBlurTimerId due to panel size change, recreate timer');
    }
    this.staticBlurTimerId = setTimeout(() => {
      log.showInfo(`timeout, start static blur`);
      this.vmInjector.getCardListVm().isUseStaticEffect = true;
      this.staticBlurTimerId = undefined;
    }, duration);
    log.showInfo(`start staticBlurTimerId ${this.staticBlurTimerId}`);
  }

  public showBanner(): Promise<void> {
    log.showWarn(`start show banner ${this.bannerAppearPromise}`);
    if (!this.bannerAppearPromise) {
      this.bannerAppearPromise = new CustomPromise();
    }
    bannerMgr.requestPanelLiveList();
    // 修正热区（打断场景热区可能错误）
    bannerMgr.setResponseRegion(this.vmInjector.getCardListVm().listEventResponseArea, BannerPanelType.TYPE_LIVE_LIST);
    if (this.bannerAppearPromise) {
      return this.bannerAppearPromise;
    }
    return Promise.resolve();
  }

  public hidePanel(): void {
    log.showWarn('Hide live panel');
    this.isCollapsing = false;
    bannerMgr.releasePanelCapsuleList();
    //如果当前面板属于横幅面板,说明横幅即将弹出，不需要释放面板
    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      return;
    }
    bannerMgr.releasePanelLiveList();
  }

  public expandCapsuleToCard = async (): Promise<void> => {
    if (this.isExpanding) {
      log.showWarn('Current is expanding');
      return;
    }
    if (this.isCollapsing) {
      log.showWarn('Current is isCollapsing');
      return;
    }

    log.showInfo('ExpandCapsuleToCard begin');
    AccessibilityVm.instance.sendEventByResource($r('app.string.live_view_expanded'));
    this.isCollapsing = false;
    this.isExpanding = true;
    BannerVm.instance.checkDeviceStatus();
    this.vmInjector.getCardListVm().scrollToTop();
    NotificationDataManager.instance.freeze(NotificationDataManager.REASON.LIVE_PANEL_EXPAND, this.FREEZE_DURATION);
    //由于点击胶囊展开卡片，打断即时横幅展示时，所有胶囊需要收起不展示
    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      this.vmInjector.getCapsuleListVm().isInterruptInstantBanner = true;
    }
    await Promise.all([
      this.expandCard(),
      this.vmInjector.getCapsuleListVm().toggleCapsuleList(),
    ]);
    log.showWarn('ExpandCapsuleToCard end');
  };

  protected expandCard(): Promise<void> {
    this.expandCardPromise = new CustomPromise();
    this.vmInjector.getCardListVm().listOpacity = 0;
    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      log.showInfo('start hide live head up');
      this.vmInjector.getLiveHeadsUpVm().isInterrupt = true;
      this.vmInjector.getCardListVm().initLiveList(this.capsuleList);
      setTimeout(() => {
        this.showBanner();
      }, this.HEADS_UP_HIDE_TIME);
    } else {
      this.vmInjector.getCardListVm().initLiveList(this.capsuleList);
      this.showBanner();
    }
    this.expandCardTimerId = setTimeout(() => {
      if (EnvVm.instance.isScreenOff) {
        // 展开动效时已灭屏，则不执行动效收回列表面板
        this.collapseCardToCapsule();
        return;
      }
      this.expandCardTimerId = undefined;
      this.getCardListAnimation().expandCard().then(() => {
        this.expandCardPromise?.resolve();
      });
      // 避免因弹簧曲线导致expandCard动画时长比肉眼可见时长长，响应点击事件不及时
      this.onExpandEnd();
    }, CutoutVm.instance.isMiddleCutout() ? this.EXPAND_DELAY : this.EXPAND_DELAY_WITHOUT_HOLE);
    return this.expandCardPromise;
  }

  private async onExpandEnd() {
    await SystemUICommonUtil.sleep(350);
    NotificationDataManager.instance.unfreeze(NotificationDataManager.REASON.LIVE_PANEL_EXPAND);
    this.isExpanding = false;
    log.showWarn('live card could click, expanding is false');
    this.reportSwitch(true);
  }

  public collapseCardToCapsule = async (): Promise<void> => {
    if (this.isCollapsing) {
      log.showWarn('Current is collapsing');
      return;
    }

    log.showInfo('CollapseCardToCapsule begin');
    AccessibilityVm.instance.sendEventByResource($r('app.string.live_view_collapsed'));
    this.vmInjector.getLiveHeadsUpVm().headsUpNtfHashCode = undefined;
    this.vmInjector.getCapsuleListVm().isInterruptInstantBanner = false;
    this.isExpanding = false;
    this.isCollapsing = true;
    NotificationDataManager.instance.freeze(NotificationDataManager.REASON.LIVE_PANEL_COLLAPSE, this.FREEZE_DURATION);
    await this.vmInjector.getCardListVm().resetList();

    if (this.expandCardTimerId !== undefined) {
      clearTimeout(this.expandCardTimerId);
      this.expandCardTimerId = undefined;
      this.expandCardPromise?.resolve();
      this.hidePanel();
      // stopMarquee: 展开卡片收回成胶囊后默认胶囊不跑跑马灯
      this.vmInjector.getCapsuleListVm().toggleCapsuleList();
    } else {
      bannerMgr.requestPanelCapsuleList();
      bannerMgr.releasePanelLiveList();
      await Promise.all([
        this.getCardListAnimation().collapseCard().then(() => {
          this.vmInjector.getCardListVm().scrollToTop();
          this.hidePanel();
        }),
        SystemUICommonUtil.sleep(CutoutVm.instance.isMiddleCutout() ? this.CAPSULE_EXPAND_DELAY : 0)
          .then(() => this.vmInjector.getCapsuleListVm().toggleCapsuleList()),
      ]);
    }
    NotificationDataManager.instance.unfreeze(NotificationDataManager.REASON.LIVE_PANEL_COLLAPSE);
    this.reportSwitch(false);
    log.showWarn('CollapseCardToCapsule end');
  };

  private reportSwitch(expandCapsule: boolean): void {
    const liveList = this.vmInjector.getCapsuleListVm().liveList;
    if (expandCapsule) {
      ClickNotificationMaintenance.reportClick(undefined, {
        data: liveList[0],
        clickRegion: ClickRegion.CAPSULE,
      });
    } else {
      ClickNotificationMaintenance.reportClick(undefined, {
        data: liveList[0],
        clickRegion: ClickRegion.CAPSULE_COLLAPSE,
      });
    }
    LiveHiSysEvent.reportCapsuleSwitchEvent(liveList, expandCapsule);
  }

  protected getCardListAnimation(): LiveCardListAnimation {
    return new LiveCardListAnimation(this.vmInjector)
  }
}