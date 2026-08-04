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
import {
  AnimateParams,
  AnimationBase,
  CutoutVm,
  DropdownVm,
  IStatusBarAnimVm,
  IStatusBarIconVm,
  StatusBarBaseVm,
  SystemEffectVm
} from '@ohos/systemuicommon/newIndex';
import curves from '@ohos.curves';
import { SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ClockShowType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { StatusBarChangeType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { LiveStyle } from '@ohos/systemuicommon/src/main/ets/live/constants/LiveStyle';
import lazy {
  TripleFoldAnimationConstants
} from '@ohos/launchercommon/src/main/ets/constants/TripleFoldAnimationConstants';
import lazy {
  SCBTripleStateChange,
} from '@ohos/launchercommon/src/main/ets/utils/TripleFoldExpandAnimUtils';
import { RTLUtil } from '@ohos/componenthelper';
import { display } from '@kit.ArkUI';
// instrument ignore file

const TAG = 'StatusBarAnimVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class StatusBarAnimVm extends StatusBarBaseVm implements IStatusBarAnimVm {
  // 状态栏这类 起始和终点一致的动效，实现上分为了两段，若在动效执行的同一帧被其他动效打断，会导致动效参数无法恢复到初始值
  // 解决方案为：仅允许相同动效打断，不同动效之间不允打断，所以下方一个动效分配一个动效对象。
  private animationMoveAndBlur: AnimationBase =
    new AnimationBase(AnimationBase.NAMES.STATUSBAR_MOVE_BLUR_ANIMATION, true);
  private animationScale: AnimationBase = new AnimationBase(AnimationBase.NAMES.STATUSBAR_SCALE_ANIMATION, true);
  // 状态栏图标的动效对象，处理单个图标的动效
  private animationIconOpacity: AnimationBase =
    new AnimationBase(AnimationBase.NAMES.STATUSBAR_ICON_OPACITY_ANIMATION, true);
  private animateIconTranslate: AnimationBase =
    new AnimationBase(AnimationBase.NAMES.STATUSBAR_ICON_TRANSLATE_ANIMATION, true);
  @Trace public blurRadiusLeft: number = 0;
  @Trace public blurRadiusRight: number = 0;
  @Trace public scaleXLeft: number = 1;
  @Trace public scaleXRight: number = 1;
  @Trace public offsetX: number = 0;

  @Trace public leftGroupTranslateX: number = 0;
  @Trace public rightGroupTranslateX: number = 0;

  @Trace public leftGroupOpacity: number = 1;
  @Trace public rightGroupOpacity: number = 1;

  public init(): void {

  }

  public async animateBaseLayoutOpacityChange(iconVms: IStatusBarIconVm[], needOpacity: number, duration: number):
    Promise<void> {
    const cmds: AnimateParams[] = []
    for (const vm of iconVms) {
      cmds.push({
        curve: Curve.Linear,
        duration: duration,
        event: () => {
          vm.baseLayoutOpacity = needOpacity;
        }
      })
    }
    if (cmds.length <= 0) {
      return;
    }
    await this.animationIconOpacity.executeAnimation(cmds,
      `animateBaseLayoutOpacityChange: ${iconVms.map((vm)=>vm.pluginName).join(',')}-${needOpacity}`);
  }

  public async animateMoveAndBlur(startDuration: number, resumeDuration: number): Promise<void> {
    const curve = curves.interpolatingSpring(0, 1, 247, 25);
    await this.animationMoveAndBlur.executeAnimation([
      {
        curve: Curve.Linear,
        duration: startDuration,
        event: () => {
          this.blurRadiusRight = 13;
          this.blurRadiusLeft = 13;
        },
      },
      {
        curve: curve,
        event: () => {
          this.offsetX = -13;
        },
      },
      {
        curve: Curve.Linear,
        delay: startDuration,
        duration: resumeDuration,
        event: () => {
          this.blurRadiusRight = 0;
          this.blurRadiusLeft = 0;
        },
      },
      {
        curve: curve,
        delay: startDuration,
        event: () => {
          this.offsetX = 0;
        },
      }
    ]);
  }

  public async animateMoveWithNoBlur(startDuration: number, resumeDuration: number): Promise<void> {
    const curve = curves.interpolatingSpring(0, 1, 247, 25);
    await this.animationMoveAndBlur.executeAnimation([
      {
        curve: curve,
        event: () => {
          this.offsetX = -13;
        },
      },
      {
        curve: curve,
        delay: startDuration,
        event: () => {
          this.offsetX = 0;
        },
      }
    ]);
  }

  public async animateScale(startDuration: number, resumeDuration: number, isLeft: boolean = false): Promise<void> {
    await this.animationScale.executeAnimation([
      {
        curve: Curve.Linear,
        duration: startDuration,
        event: () => {
          if (isLeft) {
            this.blurRadiusLeft = 8;
            this.scaleXLeft = 0.95;
          } else {
            this.blurRadiusRight = 8;
            this.scaleXRight = 0.95;
          }
        }
      },
    ]);
    await this.animationScale.executeAnimation([
      {
        curve: Curve.Linear,
        duration: resumeDuration,
        event: () => {
          if (isLeft) {
            this.blurRadiusLeft = 0;
            this.scaleXLeft = 1;
          } else {
            this.blurRadiusRight = 0;
            this.scaleXRight = 1;
          }
        }
      },
    ]);
  }

  public async animateScaleWithNoBlur(startDuration: number, resumeDuration: number,
    isLeft: boolean = false): Promise<void> {
    await this.animationScale.executeAnimation([
      {
        curve: Curve.Linear,
        duration: startDuration,
        event: () => {
          if (isLeft) {
            this.scaleXLeft = 0.95;
          } else {
            this.scaleXRight = 0.95;
          }
        }
      },
    ]);
    await this.animationScale.executeAnimation([
      {
        curve: Curve.Linear,
        duration: resumeDuration,
        event: () => {
          if (isLeft) {
            this.scaleXLeft = 1;
          } else {
            this.scaleXRight = 1;
          }
        }
      },
    ]);
  }

  public onStatusBarChange = async (type = StatusBarChangeType.Default): Promise<void> => {
    // 下拉、非中挖孔 不执行该动效
    if (!CutoutVm.instance.isMiddleCutout() || DropdownVm.instance.isDropDown) {
      log.showInfo(`Can't play animation in side cutout/not cutout or dropdown`);
      return;
    }

    log.info('start status bar change anim.', type);
    if (type === StatusBarChangeType.Remind) {
      if (!SystemEffectVm.instance.isBlurStatusBarWhenExpandCapsule()) {
        return this.animateScaleWithNoBlur(LiveStyle.METABALL_HIGHEST_DURATION, LiveStyle.METABALL_HIGHEST_DURATION);
      }
      return this.animateScale(LiveStyle.METABALL_HIGHEST_DURATION, LiveStyle.METABALL_HIGHEST_DURATION);
    }
    if (!SystemEffectVm.instance.isBlurStatusBarWhenExpandCapsule()) {
      return this.animateMoveWithNoBlur(LiveStyle.METABALL_HIGHEST_DURATION, LiveStyle.METABALL_HIGHEST_DURATION);
    }
    return this.animateMoveAndBlur(LiveStyle.METABALL_HIGHEST_DURATION, LiveStyle.METABALL_HIGHEST_DURATION);
  }

  public async animateGroupTranslate(stateChange: SCBTripleStateChange, orientation: number, screenChangeDelta: number):
    Promise<void> {
    this.updateTranslateDelta(stateChange, orientation, screenChangeDelta);
    await this.animateIconTranslate.executeAnimation([{
      curve: TripleFoldAnimationConstants.TRANSLATE_CURVES,
      duration: TripleFoldAnimationConstants.STATUS_BAR_TRANSLATE_DURATION,
      event: () => {
        if (this.leftGroupTranslateX !== 0) {
          this.leftGroupTranslateX = 0;
        }
        if (this.rightGroupTranslateX !== 0) {
          this.rightGroupTranslateX = 0;
        }
      }
    }])
  }

  private updateTranslateDelta(stateChange: SCBTripleStateChange, orientation: number, screenChangeDelta: number):
    void {
    if (stateChange === SCBTripleStateChange.M_TO_G) {
      if (RTLUtil.isRTL()) {
        if (orientation === display.Orientation.PORTRAIT) {
          this.rightGroupTranslateX += screenChangeDelta;
        } else if (orientation === display.Orientation.PORTRAIT_INVERTED) {
          this.leftGroupTranslateX -= screenChangeDelta;
        }
      } else {
        if (orientation === display.Orientation.PORTRAIT) {
          this.leftGroupTranslateX += screenChangeDelta;
        } else if (orientation === display.Orientation.PORTRAIT_INVERTED) {
          this.rightGroupTranslateX -= screenChangeDelta;
        }
      }
    } else if (stateChange === SCBTripleStateChange.G_TO_M) {
      if (RTLUtil.isRTL()) {
        if (orientation === display.Orientation.LANDSCAPE_INVERTED) {
          this.rightGroupTranslateX += screenChangeDelta;
        } else if (orientation === display.Orientation.LANDSCAPE) {
          this.leftGroupTranslateX -= screenChangeDelta;
        }
      } else {
        if (orientation === display.Orientation.LANDSCAPE_INVERTED) {
          this.leftGroupTranslateX += screenChangeDelta;
        } else if (orientation === display.Orientation.LANDSCAPE) {
          this.rightGroupTranslateX -= screenChangeDelta;
        }
      }
    } else if (stateChange === SCBTripleStateChange.F_TO_G) {
      if (RTLUtil.isRTL()) {
        if (orientation === display.Orientation.PORTRAIT) {
          this.leftGroupTranslateX -= screenChangeDelta;
        } else if (orientation === display.Orientation.PORTRAIT_INVERTED) {
          this.rightGroupTranslateX += screenChangeDelta;
        }
      } else {
        if (orientation === display.Orientation.PORTRAIT) {
          this.rightGroupTranslateX -= screenChangeDelta;
        } else if (orientation === display.Orientation.PORTRAIT_INVERTED) {
          this.leftGroupTranslateX += screenChangeDelta;
        }
      }
    } else if (stateChange === SCBTripleStateChange.G_TO_F) {
      if (RTLUtil.isRTL()) {
        if (orientation === display.Orientation.LANDSCAPE_INVERTED) {
          this.leftGroupTranslateX -= screenChangeDelta;
        } else if (orientation === display.Orientation.LANDSCAPE) {
          this.rightGroupTranslateX += screenChangeDelta;
        }
      } else {
        if (orientation === display.Orientation.LANDSCAPE_INVERTED) {
          this.rightGroupTranslateX -= screenChangeDelta;
        } else if (orientation === display.Orientation.LANDSCAPE) {
          this.leftGroupTranslateX += screenChangeDelta;
        }
      }
    }
  }
}