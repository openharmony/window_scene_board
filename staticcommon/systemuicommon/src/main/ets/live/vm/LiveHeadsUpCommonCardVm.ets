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

import { ILiveHeadsUpCommonCardVm } from '../interface/ILiveHeadsUpCommonCardVm';
import { LiveBaseVm } from './LiveBaseVm';
import { LogDomain, Logger } from '@ohos/basicutils';
import { LiveNotification } from '../model/LiveNotification';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveHeadsUpCommonCardAnimation } from '../animation/LiveHeadsUpCommonCardAnimation';
import { EnvVm } from '../../vm/EnvVm';
import { DropdownVm } from '../../vm/DropdownVm';
import { TargetPanel } from '@ohos/frameworkwrapper';

const TAG = 'LiveHeadsUpCommonCardVm';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

/**
 * 实况横幅通用卡片VM
 */
@ObservedV2
export class LiveHeadsUpCommonCardVm extends LiveBaseVm implements ILiveHeadsUpCommonCardVm {
  public componentId: string = this.vmInjector.getId(TAG);

  @Trace public live?: LiveNotification;
  @Trace public containerSize: SizeOptions = { width: '100%', height: 'auto' };
  @Trace public contentSize?: SizeOptions;
  @Trace public contentAlign: Alignment = Alignment.End;
  @Trace public contentScale?: ScaleOptions;
  @Trace public contentOpacity: number = 1;
  @Trace public containerOffsetX: number = 0;
  @Trace public containerOffsetY: number = 0;
  @Trace public containerOpacity: number = 1;
  @Trace public containerScale?: ScaleOptions;
  @Trace public containerBorderRadius: number = LiveStyle.CARD_RADIUS;
  @Trace public zIndex: number = 1;
  @Trace public cardGradientOpacity: number = 1;
  @Trace public backCardOpacity: number = 0;

  @Computed
  public get cardGradientColor(): Array<[ResourceColor, number]> {
    if (this.live && !this.live.card.isSmallCard()) {
      const gradientColor = this.live.capsule?.backgroundColor ?? LiveStyle.CAPSULE_CONTENT_COLOR as string;
      return [[this.convertColorToRgba(gradientColor, 0.25), 0], ['rgba(0, 0, 0, 0.25)', 1]];
    }
    return [['rgba(0, 0, 0, 0)', 0], ['rgba(0, 0, 0, 0)', 1]];
  }

  @Computed
  public get cardWidth(): Length {
    return '100%';
  }

  public async show(live: LiveNotification, preemption?: boolean): Promise<void> {
    log.showInfo(TAG, `Show for ${live.hashCode}`);
    this.live = live;
    const animation = new LiveHeadsUpCommonCardAnimation(this, this.vmInjector.getCapsuleListVm().position);
    await animation.expandCard(preemption);
  }

  public async update(live: LiveNotification): Promise<void> {
    log.showInfo(TAG, `Update for ${live.hashCode}`);
    this.live = live;
    if (!live.isPhoneCall()) {
      // 通话横幅接听后会连发几次更新，定时器id会被刷新导致定时器文本消失再出现
      this.vmInjector.updateVmByLive(live, TAG);
    }
  }

  public async hide(): Promise<void> {
    if (!this.live) {
      log.showWarn(TAG, 'No live data');
      return;
    }
    log.showInfo(TAG, `Hide for ${this.live.hashCode}`);
    const animation = new LiveHeadsUpCommonCardAnimation(this, this.vmInjector.getCapsuleListVm().position);
    await animation.collapseCard();
    this.live = undefined;
  }

  public isNeedShow(live: LiveNotification): boolean {
    const isLock = EnvVm.instance.isScreenLock || EnvVm.instance.isScreenOff;
    //普通实况横幅在息屏或者锁屏时，不展示在桌面
    if (!live.isInstantBanner() && isLock) {
      return false;
    }
    if (DropdownVm.instance.isDropDown) {
      //通话实况允许在控制中心展示时，收起控制中心后展示通话横幅
      if (DropdownVm.instance.dropdownEvent.target === TargetPanel.CONTROL_CENTER_PANEL && live.isPhoneCall()) {
        return true;
      }
      return false;
    }
    return true;
  }

  public setCardResponseRegion(isRotate: boolean): void {
    return;
  }
}