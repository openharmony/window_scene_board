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
import {
  AnimateParams,
  AnimationBase,
  IStatusBarIconAnimVm,
  IStatusBarIconVm,
  StatusBarBaseVm,
} from '@ohos/systemuicommon/newIndex';
import { ClockShowType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { curves } from '@kit.ArkUI';
import { StatusBarNotificationIconVm } from './StatusBarNotificationIconVm';
import { IconFilterType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';

const TAG = 'StatusBarAnimVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class StatusBarIconAnimVm extends StatusBarBaseVm implements IStatusBarIconAnimVm {
  private readonly springMotionCurve: string | Curve | ICurve | undefined = curves.springMotion(0.513, 0.792);
  @Trace public clockTextScale: number = 1;
  @Trace public isExtrudeType: boolean = false;
  private animationIcon: AnimationBase = new AnimationBase(AnimationBase.NAMES.STATUSBAR_ICON_ANIMATION, false);

  public async executeAnimation(cmds: AnimateParams[]): Promise<void> {
    if (cmds.length <= 0) {
      return;
    }
    await this.animationIcon.executeAnimation(cmds);
    this.animationIcon.clearAnimations();
  }

  public getVisibleChangeParam(cmds: AnimateParams[], animateDurationMs: number, delay: number,
    newVisibleIcons: Set<string>, avoidName: string, avoidMargin: number, tempHideInfo: Set<string>): void {
    const layoutVm = this.vmInjector.getStatusBarLayoutVm();
    // 跨孔图标隐藏
    if (tempHideInfo.size > 0) {
      cmds.push({
        curve: Curve.Linear,
        duration: 1,
        delay: delay,
        event: () => {
          layoutVm.iconTempHideInfo = tempHideInfo;
        }
      })
    }
    // 图标布局变更
    cmds.push({
      curve: Curve.Friction,
      duration: animateDurationMs,
      delay: delay,
      event: () => {
        const layoutVm = this.vmInjector.getStatusBarLayoutVm();
        layoutVm.layoutIsVisibleIcons = newVisibleIcons;
        layoutVm.avoidIconName = avoidName;
        layoutVm.avoidIconMargin = avoidMargin;
      }
    });

    // 隐藏的图标显示
    if (tempHideInfo.size > 0) {
      cmds.push({
        curve: Curve.Linear,
        duration: animateDurationMs,
        delay: delay + animateDurationMs,
        event: () => {
          layoutVm.iconTempHideInfo.clear();
        }
      })
    }
  }

  public getSystemIconAnimatePara(
    iconVm: IStatusBarIconVm, opacity: number, scale: number, offset: number, delay: number, duration?: number
  ): AnimateParams {
    if (duration === undefined || duration > 0) {
      return {
        curve: this.springMotionCurve,
        delay: delay + 33,
        event: () => {
          iconVm.capsuleLayoutOpacity = opacity;
          iconVm.scaleX = scale;
          iconVm.scaleY = scale;
          iconVm.offset = offset;
        }
      }
    } else {
      return {
        curve: Curve.Linear,
        duration: 0,
        event: () => {
          iconVm.capsuleLayoutOpacity = opacity;
          iconVm.scaleX = scale;
          iconVm.scaleY = scale;
          iconVm.offset = offset;
        }
      }
    }
  }

  public getNtfIconAnimateParam(
    iconVm: StatusBarNotificationIconVm, showMaxIconCount: number, delay: number
  ): AnimateParams {
    return {
      curve: this.springMotionCurve,
      delay: delay,
      event: () => {
        iconVm.updateShowMaxIconCount(showMaxIconCount);
      },
    }
  }

  // 状态栏时间显隐、压缩动效
  public getClockAnimateParam(iconVm: IStatusBarIconVm, showType: ClockShowType, clockTextScale: number,
    baseDelay: number = 0): Array<AnimateParams> {
    let cmds: AnimateParams[] = [];
    if (showType === ClockShowType.EXTRUDE_SHOW) {
      cmds.push(
        {
          delay: baseDelay + 17,
          curve: this.springMotionCurve,
          event: () => {
            this.isExtrudeType = true;
            this.clockTextScale = clockTextScale;
          },
        },
        {
          delay: baseDelay + 50,
          duration: 17,
          curve: Curve.Linear,
          event: () => {
            iconVm.separatorOpacity = 0;
          }
        }
      )
    } else if (showType === ClockShowType.NORMAL_SHOW) {
      cmds.push(
        {
          delay: baseDelay + 17,
          curve: this.springMotionCurve,
          event: () => {
            this.isExtrudeType = false;
            this.clockTextScale = 1;
          }
        },
        {
          delay: baseDelay + 183,
          curve: Curve.Linear,
          duration: 17,
          event: () => {
            iconVm.separatorOpacity = 1;
          }
        }
      )
    }

    return cmds;
  }

  // 图标透明度变化
  public getIconOpacityParam(iconVm: IStatusBarIconVm, needOpacity: number, duration: number): AnimateParams {
    return {
      curve: Curve.Linear,
      duration: duration,
      event: () => {
        iconVm.capsuleLayoutOpacity = needOpacity;
      }
    }
  }
}