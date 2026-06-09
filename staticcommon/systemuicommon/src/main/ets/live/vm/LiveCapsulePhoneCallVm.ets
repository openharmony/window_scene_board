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

import curves from '@ohos.curves';
import { LiveCapsuleVm } from './LiveCapsuleVm';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import {
  StartAppOneMirrorAnimation,
  StartAppOneMirrorOnExecuteParams
} from '../../animation/StartAppOneMirrorAnimation';
import { LiveStyle } from '../constants/LiveStyle';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { AnimationBase } from '../../animation/AnimationBase';
import { StatusBarHeightVm } from '../../statusbar/vm/StatusBarHeightVm';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { EnvVm } from '../../vm/EnvVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';

const TAG = 'LiveCapsulePhoneCallVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const STATUS_BAR_HEIGHT: number = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
const CURVE_X = curves.springMotion(0.4, 1);
const CURVE_Y = curves.springMotion(0.3, 1);

/**
 * 通话胶囊VM
 */
@ObservedV2
export class LiveCapsulePhoneCallVm extends LiveCapsuleVm implements ILiveCapsuleVm {
  private animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_CLICK_TO_APP_ANIMATION);
  private stopCheck: boolean = false;

  public init(): void {
    log.showWarn(`init phone call ${this.live?.hashCode}`);
  }

  public destroy(): void {
    log.showWarn(`destroy phone call ${this.live?.hashCode}`);
  }

  public onClick = async (): Promise<void> => {
    if (!this.isShow) {
      log.showWarn(`Capsule ${this.live.hashCode} is not show for click`);
      return;
    }
    if (EnvVm.instance.isScreenOff) {
      log.showInfo('screen is off, click return');
      return;
    }
    if(this.vmInjector.getLiveHeadsUpVm().isHiding){
      log.showWarn(`Capsule ${this.live.hashCode} is hidding, could not click`);
      return;
    }
    log.showWarn(`Click for phone Capsule ${this.live.hashCode}`);
    // 只有一个通话胶囊且处于非沉浸态时点击直接拉起通话界面，否则就展开成卡片
    if (this.vmInjector.getCapsuleListVm().getShowCapsuleListNum() === 1 && !EnvVm.instance.isImmersive) {
      LiveHiSysEvent.reportLiveClickAppEvent(this.live, 5);

      // 横屏使用窗口动效
      if (!CutoutVm.instance.isMiddleCutout() || this.live.capsule?.sticky) {
        this.vmInjector.getStarterVm().startCapsuleWantAgent(this.live, true);
        return;
      }

      StartAppOneMirrorAnimation.instance.prepare({
        scene: this.vmInjector.scene,
        cardRect: {
          x: 0,
          y: 0,
          width: 0,
          height: 0,
        },
        cardRadius: LiveStyle.CAPSULE_RADIUS,
        bundleName: this.live.creatorBundleName,
        cardBgColor: '#000000',
        onExecute: (param) => {
          const height = param.sceneHeight;
          this.backgroundColor = 'rgba(0, 0, 0, 0)';
          this.disableOutline = true;
          StatusBarHeightVm.getInstance().preSetShowHeight(ArkUIAdapter.px2vp(height) - 50, TAG);

          // 胶囊动效
          this.collapseCapsuleList(param);
        },
        animationParams: {
          centerY: this.vmInjector.getMetaBallVm().getMiddleHole().centerY,
          width: this.width,
          height: LiveStyle.CAPSULE_HEIGHT,
          curveX: CURVE_X,
          curveY: CURVE_Y
        }
      });

      // 状态栏动效
      this.vmInjector.getCapsuleListVm().statusBarChangeCallback?.();
      // 拉起通话界面
      this.vmInjector.getStarterVm().startCapsuleWantAgent(this.live);
    } else {
      this.vmInjector.getSwitchVm().expandCapsuleToCard();
    }
  };

  private async collapseCapsuleList(param: StartAppOneMirrorOnExecuteParams): Promise<void> {
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(this.live);
    const height = param.sceneHeight;
    const centerY = this.vmInjector.getMetaBallVm().getMiddleHole().centerY;
    const position = this.vmInjector.getCapsuleListVm().position;

    await this.animation.executeAnimation([
      {
        curve: CURVE_X,
        event: () => {
          this.scaleX = 1.5;
          this.scaleY = 1.5;
          this.offsetY = ArkUIAdapter.px2vp(height) / 2 - centerY;
        }
      },
      {
        curve: Curve.Linear,
        duration: 167,
        event: () => {
          this.showType = CapsuleShowType.NONE;
          this.opacity = 0;
          capsuleMarqueeVm.radius = 10;
        }
      },
      {
        delay: 200,
        duration: 1,
        event: () => {
          this.scaleX = 1;
          this.scaleY = 1;
          this.offsetX = 0;
          this.offsetY = 0;
          this.width = position.width;
          capsuleMarqueeVm.radius = 0;
        }
      }
    ]);
    this.reset();
  }

  private reset() {
    this.backgroundColor = undefined;
    this.disableOutline = false;
    StatusBarHeightVm.getInstance().preSetShowHeight(STATUS_BAR_HEIGHT, TAG);
  }
}