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
import { LiveNotification } from '../../../model/LiveNotification';
import { LiveStyle } from '../../../constants/LiveStyle';
import { DeviceInfoVm } from '../../../../vm/DeviceInfoVm';
import { LogDomain, Logger } from '@ohos/basicutils';
import { ILiveVmInjector } from '../../../interface/ILiveVmInjector';
import { InnerEventUtil } from '../../../../utils/InnerEventUtil';
import { LiveViewRequestEnterImmersiveEvent } from '../../../../event/LiveViewEvent';
import { AnimationBase } from '../../../../animation/AnimationBase';
import { AppProtectedStatusVm } from '../../../../vm/AppProtectedStatusVm';
import { SystemUICommonUtil } from '../../../../utils/SystemUICommonUtil';
import { curves } from '@kit.ArkUI';
import { EnvVm } from '../../../../vm/EnvVm';
import { sharedData } from '../../../../model/SendableData';

const TAG = 'PocketManager';
const log = Logger.getLogHelper(LogDomain.SYS_UI);

export class PocketManager {
  public static updateCapsuleShowStyle(liveList: LiveNotification[], vmInjector: ILiveVmInjector): void {
    for (const live of liveList) {
      const capsuleVm = vmInjector.getCapsuleVm(live);
      const liveMediaPlayerVm = vmInjector.getLiveMediaPlayerVm(live)
        capsuleVm.height = LiveStyle.CAPSULE_HEIGHT;
        capsuleVm.capsuleCircleWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH;
        capsuleVm.capsuleIconWidth = LiveStyle.CAPSULE_ICON_WIDTH;
        capsuleVm.capsuleShadowHeight = LiveStyle.CAPSULE_SHADOW_HEIGHT;
        capsuleVm.distanceBetweenShadowAndOutside = LiveStyle.SHADOW_CAPSULE_WIDTH;
        capsuleVm.shadowBorderRadius = LiveStyle.CAPSULE_SHADOW_HEIGHT / 2;
        capsuleVm.shadowClipBorderRadius = LiveStyle.CAPSULE_HEIGHT / 2;
        capsuleVm.iconWidth = LiveStyle.CAPSULE_ICON_WIDTH;
        capsuleVm.separatorWidth = LiveStyle.CAPSULE_SEPARATOR_WIDTH;
        if (live.isMediaPlayer()) {
          liveMediaPlayerVm.mediaCircleShape =
            new Circle({ width: LiveStyle.CAPSULE_ICON_WIDTH, height: LiveStyle.CAPSULE_ICON_WIDTH });
        }
    }
  }

  public static canEnterImmersive(live: LiveNotification): boolean {
    if (!EnvVm.instance.isScreenLock) {
      return false;
    }
    // 非播控开启隐藏通知内容时不支持沉浸式点击
    if (!live.isMediaPlayer() && PocketManager.isHideContent()) {
      log.showInfo(TAG, `Hide content, no icon click listener`);
      return false;
    }
    if (!live.isSupportImmersive()) {
      log.showInfo(TAG, `Live ${live.hashCode} is not support immersive`);
      return false;
    }
    if (AppProtectedStatusVm.instance.isProtected(live.creatorBundleName, live.appIndex)) {
      log.showInfo(TAG, `Live ${live.hashCode} is protected`);
      return false;
    }
    return true;
  }

  public static onIconClick(live: LiveNotification, vmInjector: ILiveVmInjector): void {
    if (PocketManager.canEnterImmersive(live)) {
      log.showInfo(TAG, `Enter immersive for ${live.hashCode}`);
      PocketManager.forwardAnimation(live, vmInjector);
      InnerEventUtil.post(LiveViewRequestEnterImmersiveEvent, new LiveViewRequestEnterImmersiveEvent(live.hashCode));
    } else {
      log.showInfo(TAG, `Click icon for ${live.hashCode} but cannot enter immersive, do card click`);
      vmInjector.getCardListItemVm(live).onClick();
    }
  }

  private static async forwardAnimation(live: LiveNotification, vmInjector: ILiveVmInjector): Promise<void> {
    const animation = new AnimationBase(AnimationBase.NAMES.LIVE_ENTER_IMMERSIVE_ANIMATION, false);
    const itemVm = vmInjector.getCardListItemVm(live);
    const rect = SystemUICommonUtil.getRect(itemVm.componentId);
    const immersiveCardRect = PocketManager.getImmersiveCardRect(live);
    log.info(TAG, 'Immersive card rect:', immersiveCardRect);
    log.info(TAG, 'Live card rect:', rect);
    sharedData.clickCardRect.update(rect);
    await animation.executeAnimation([
      {
        curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
        duration: 150,
        event: () => {
          vmInjector.getCardListVm().listOpacity = 0;
        },
        onFinish: () => {
          itemVm.containerOffsetY = 0;
          itemVm.containerScale = undefined;
          vmInjector.getSwitchVm().hidePanel();
          vmInjector.getCapsuleListVm().toggleCapsuleList();
        }
      },
      {
        curve: curves.interpolatingSpring(0, 1, 228, 24),
        event: () => {
          itemVm.containerOffsetX = PocketManager.getCenterX(immersiveCardRect) - PocketManager.getCenterX(rect);
          itemVm.containerOffsetY = PocketManager.getCenterY(immersiveCardRect) - PocketManager.getCenterY(rect);
          itemVm.containerScale = {
            x: immersiveCardRect.width / rect.width,
            y: immersiveCardRect.height / rect.height,
          };
        }
      }
    ]);
  }

  private static getCenterX(rect: RectResult): number {
    return rect.x + rect.width / 2;
  }

  private static getCenterY(rect: RectResult): number {
    return rect.y + rect.height / 2;
  }

  private static getImmersiveCardRect(live: LiveNotification): RectResult {
    const immersiveCardRect = sharedData.immersiveCardRect;
    if (!immersiveCardRect.width && !immersiveCardRect.height) {
      immersiveCardRect.width = 278;
      immersiveCardRect.height = live.isMediaPlayer() ? 108 : 84;
      immersiveCardRect.x = 24;
      immersiveCardRect.y = px2vp(908) - immersiveCardRect.height;
    }
    return immersiveCardRect;
  }

  public static isHideContent(): boolean {
    return EnvVm.instance.isLiveViewHideContent
  }
}