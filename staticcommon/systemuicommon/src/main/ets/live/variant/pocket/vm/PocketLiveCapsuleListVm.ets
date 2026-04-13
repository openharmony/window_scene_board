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
import {
  CapsulePositionChangeCallback,
  ILiveCapsuleListVm,
  StatusBarChangeCallback } from '../../../interface/ILiveCapsuleListVm';
import { LiveCapsuleListVm } from '../../../vm/LiveCapsuleListVm';
import { LiveNotification } from '../../../model/LiveNotification';
import { AppLifeCycleManager } from '../../../../manager/AppLifeCycleManager';
import { StatusBarCapsulePosition } from '../../../../statusbar/model/StatusBarCapsulePosition';
import image from '@ohos.multimedia.image';
import { InnerEventUtil } from '../../../../utils/InnerEventUtil';
import { LiveViewEnterImmersiveEvent, LiveViewExitImmersiveEvent } from '../../../../event/LiveViewEvent';
import { ILiveVmInjector } from '../../../interface/ILiveVmInjector';
import { componentSnapshot, curves } from '@kit.ArkUI';
import { SystemUICommonUtil } from '../../../../utils/SystemUICommonUtil';
import { AnimationBase } from '../../../../animation/AnimationBase';
import { LiveStyle } from '../../../constants/LiveStyle';
import { PowerStatusEnum, PowerStatusMonitorAdapter } from '../../../../adapter/PowerStatusMonitorAdapter';
import { LiveMetaBallScene } from '../../../model/LiveCommonModel';

@ObservedV2
export class PocketLiveCapsuleListVm extends LiveCapsuleListVm implements ILiveCapsuleListVm {
  protected TAG: string = 'PocketLiveCapsuleListVm';
  public immersiveHashCode = '';

  @Trace public overlayImage?: image.PixelMap;
  @Trace public overlayContainerSize?: SizeOptions;
  @Trace public overlayContainerTranslate?: TranslateOptions;
  @Trace public overlayContainerRadius?: Length;
  @Trace public overlayContentSize?: SizeOptions;
  @Trace public overlayContainerOpacity: number = 1;
  @Trace public isIconFreeze: boolean = false;

  init(position: StatusBarCapsulePosition, changeCallback: CapsulePositionChangeCallback,
    statusBarChangeCallback: StatusBarChangeCallback): void {
    super.init(position, changeCallback, statusBarChangeCallback);
    InnerEventUtil.on(LiveViewEnterImmersiveEvent, this.onEnterImmersive);
    InnerEventUtil.on(LiveViewExitImmersiveEvent, this.onExitImmersive);
    PowerStatusMonitorAdapter.subscribe({
      stage: PowerStatusEnum.BEGIN_DISPLAY_ON,
      callback: this.beginDisplayOn.bind(this)
    }, `${this.TAG}_BEGIN_DISPLAY_ON`);
    PowerStatusMonitorAdapter.subscribe({
      stage: PowerStatusEnum.BEGIN_DISPLAY_OFF,
      callback: this.beginDisplayOff.bind(this)
    }, `${this.TAG}_BEGIN_DISPLAY_OFF`);
  }

  @Monitor('deviceInfoVm.isOuterHome')
  public onOuterHomeChange(): void {
    this.vmInjector.getSwitchVm().hidePanel();
    this.hideHeadsUp('OuterHomeChange');
    this.vmInjector.getOverlayVm?.().hide();
    this.toggleCapsuleList({ needAnimation: false });
  }

  @Monitor('envVm.isPwdVisible')
  onPwdVisible(): void {
  }


  onDropdownShowChange(): void {
      super.onDropdownShowChange();
  }

  handleScreenLockChange(): void {
    if (!this.envVm.isScreenLock) {
      this.immersiveHashCode = '';
    }
    super.handleScreenLockChange();
  }

  beginDisplayOn(): void {
    this.isIconFreeze = false;
  }

  beginDisplayOff(): void {
  }

  private hideHeadsUp(reason: string): void {
    const headsUpVm = this.vmInjector.getLiveHeadsUpVm();
    if (headsUpVm.live) {
      this.log.showInfo(`Hide headsup: ${headsUpVm.live.hashCode}, reason: ${reason}`);
      headsUpVm.hideImmediately(headsUpVm.live);
    }
  }

  private async hideCardList(): Promise<void> {
    const animation = new AnimationBase(AnimationBase.NAMES.LIVE_CARD_LIST_ANIMATION, true);
    await animation.executeAnimation([
      {
        curve: Curve.Linear,
        duration: 200,
        event: () => {
          this.vmInjector.getCardListVm().listOpacity = 0;
        },
      }
    ]);
    this.vmInjector.getSwitchVm().hidePanel();
    this.vmInjector.getCapsuleListVm().toggleCapsuleList({ needAnimation: false });
  }

  protected checkItemVisibleChanged(live: LiveNotification): boolean {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const oldVisible = capsuleVm.isVisible;

    if (capsuleVm.isToDelete) {
      this.log.showWarn(`Capsule ${live.hashCode} is toDelete`);
      capsuleVm.isVisible = false;
    } else if (this.deviceInfoVm.isEmergencyMode()) {
      this.log.showWarn(`Capsule ${live.hashCode} is in EmergencyMode: ${this.deviceInfoVm.deviceMode}`);
      capsuleVm.isVisible = false;
    } else if (live.isInstant()) {
      const remind = this.remindVm.getCurrentRemindCapsule()?.hashCode;
      this.log.showWarn(`Capsule ${live.hashCode} is Instant, remind: ${remind}`);
      capsuleVm.isVisible = live.hashCode === remind;
    } else if (this.dropdownVm.isDropDown) {
      this.log.showWarn(`Capsule ${live.hashCode} Dropdown is show`);
      capsuleVm.isVisible = false;
    } else if (this.bannerVm.isHideCapsule()) {
      this.log.showWarn(`Capsule ${live.hashCode} Banner is show liveCardList`);
      capsuleVm.isVisible = false;
    } else if (this.envVm.isScreenLock) {
      this.log.showWarn(`Capsule ${live.hashCode} Screen is locked, or is outer home`);
      capsuleVm.isVisible = false;
    } else if (this.vmInjector.getLiveHeadsUpVm().headsUpNtfHashCode === live.hashCode) {
      this.log.showWarn(`Capsule ${live.hashCode} Banner is show headsUp`);
      capsuleVm.isVisible = false;
    } else if (AppLifeCycleManager.instance.isForeground(live.creatorUid, live) && !live.capsule?.sticky) {
      this.log.showWarn(`Capsule ${live.hashCode} App ${live.creatorBundleName}_${live.creatorUid} is foreground`);
      capsuleVm.isVisible = false;
    } else if (this.remindVm.getCurrentRemindCapsule()) {
      const remind = this.remindVm.getCurrentRemindCapsule()?.hashCode;
      this.log.showWarn(`Capsule ${live.hashCode} is in remind scene, remind: ${remind}`);
      capsuleVm.isVisible = live.hashCode === remind;
    } else if (this.isInterruptInstantBanner) {
      this.log.showWarn(`Capsule ${live.hashCode} need hide by click when instant banner is interrupt`);
      capsuleVm.isVisible = false;
    } else {
      capsuleVm.isVisible = true;
    }

    if (capsuleVm.isVisible) {
      this.isShowCapsule = true;
    }

    const changed = capsuleVm.isVisible !== oldVisible;
    this.log.showWarn(`Check item visible for ${live.hashCode}, result: ${capsuleVm.isVisible}, changed: ${changed}`);

    return changed;
  }

  public onEnterImmersive = (event: LiveViewEnterImmersiveEvent): void => {
    this.log.showInfo(`onEnterImmersive for ${event.hashCode}`);
    if (event.hashCode !== this.immersiveHashCode && this.liveList.some((live) => live.hashCode === event.hashCode)) {
      this.immersiveHashCode = event.hashCode;
      this.toggleCapsuleList({ needAnimation: false });
    }
  };

  public onExitImmersive = async (event: LiveViewExitImmersiveEvent): Promise<void> => {
    this.log.showInfo(`onExitImmersive for ${event.hashCode} begin`);
    if (!this.envVm.isScreenLock) {
      this.log.showInfo('onExitImmersive, is not outer home or not screen lock');
      this.immersiveHashCode = '';
      return;
    }
    if (this.immersiveHashCode !== event.hashCode) {
      this.log.showInfo('Not current immersive');
      return;
    }
    const overlayVm = this.vmInjector.getOverlayVm?.();
    if (!overlayVm) {
      return;
    }
    try {
      const id = 'sl_state_outer_mgr_sl_immersive_live_card';
      const img = componentSnapshot.getSync(id);
      const rect = SystemUICommonUtil.getRect(id);
      overlayVm.show(wrapBuilder(overlayBuilder));
      this.immersiveHashCode = '';
      await Promise.all([
        this.exitImmersiveAnimation(img, rect),
        SystemUICommonUtil.sleep(150).then(() => { this.toggleCapsuleList() })
      ]);
      overlayVm.hide();
      this.log.showInfo(`onExitImmersive for ${event.hashCode} end`);
    } catch (e) {
      this.log.error(`onExitImmersive for ${event.hashCode} error:`, e);
    }
  };

  private async exitImmersiveAnimation(img: image.PixelMap, rect: RectResult): Promise<void> {
    const animation = new AnimationBase(AnimationBase.NAMES.LIVE_EXIT_IMMERSIVE_ANIMATION, true);
    const originalSize: SizeOptions = { width: rect.width, height: rect.height };
    const containerSize: SizeOptions = { width: 16, height: 16 };
    animation.setInitialState(() => {
      this.overlayImage = img;
      this.overlayContainerSize = originalSize;
      this.overlayContainerTranslate = {
        x: 8,
        y: rect.y - 4,
      };
      this.overlayContainerRadius = LiveStyle.CARD_RADIUS;
      this.overlayContainerOpacity = 1;
      this.overlayContentSize = originalSize;
      this.log.info(`overlayContainerTranslate:`, this.overlayContainerTranslate);
    });
    const curve = curves.cubicBezierCurve(0.4, 0, 0.4, 1);
    await animation.executeAnimation([
      {
        duration: 300,
        curve,
        event: () => {
          this.overlayContainerSize = containerSize;
          this.overlayContainerRadius = '50%';
          this.overlayContainerOpacity = 0;
          this.overlayContainerTranslate = { x: 10, y: 4 };
        }
      }
    ]);
  }
}

@Builder
function overlayBuilder(injector: ILiveVmInjector) {
  Stack({ alignContent: Alignment.Center }) {
    Image((injector.getCapsuleListVm() as PocketLiveCapsuleListVm).overlayImage)
      .size((injector.getCapsuleListVm() as PocketLiveCapsuleListVm).overlayContentSize)
  }
  .id('PocketLiveCapsuleOverlay')
  .position({ left: 0, top: 0 })
  .size((injector.getCapsuleListVm() as PocketLiveCapsuleListVm).overlayContainerSize)
  .translate((injector.getCapsuleListVm() as PocketLiveCapsuleListVm).overlayContainerTranslate)
  .borderRadius((injector.getCapsuleListVm() as PocketLiveCapsuleListVm).overlayContainerRadius)
  .opacity((injector.getCapsuleListVm() as PocketLiveCapsuleListVm).overlayContainerOpacity)
  .clip(true)
}