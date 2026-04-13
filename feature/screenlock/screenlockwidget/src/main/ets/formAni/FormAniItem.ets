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
import { curves, LengthMetrics } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { SlVisualArgs } from '@ohos/screenlockcommon/src/main/ets/visual/SlVisualData';
import { SlVisualControl } from '@ohos/screenlockcommon/src/main/ets/visual/SlVisualControl';
import { SlAreaType, SlPositionType, CcmOption } from '@ohos/screenlockcommon/src/main/ets/constants/CommonConstants';
import { ClockBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ScreenLockFormAniData } from './ScreenLockFormAniData';
import { ScreenLockAniScene } from './ScreenLockFormAniMgr';

const DEFAULT_FOREGROUND_COLOR: string = '#ffffff';
const BLENDMODE_DESTINATION_IN: number = 6;
const DEFAULT_FORM_HEIGHT: number = 58;
const DEFAULT_FIX_VALUE: number = 24;
const COLOR_BLACK: string = '#ff000000';

@Component
export default struct FormAniItem {
  @State data: ScreenLockFormAniData = new ScreenLockFormAniData();
  @Prop scene: ScreenLockAniScene = ScreenLockAniScene.INNER;

  // 时钟组件UI样式状态管理
  @State clockBindCtrl: ISlState | undefined = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_BIND_STATE);
  @State foregroundBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_FORM_FOREGROUND);
  @State panelBrightArgs?: SlVisualArgs = SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_FORM_PANEL);
  private enableEffect: boolean = SlVisualControl.getInstance().getEnable(CcmOption.EFFECT, SlAreaType.FORM);
  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.FORM);
  private enableSolid: boolean = SlVisualControl.getInstance().getEnable(CcmOption.SOLID, SlAreaType.FORM);

  // private getBrightnessOption(): BrightnessOptions | undefined {
  //   if (!this.enableBright || this.data.color === COLOR_BLACK) {
  //     return undefined;
  //   }
  //
  //   if (this.data.color !== DEFAULT_FOREGROUND_COLOR) {
  //     return this.data.isLightWallpaper ?
  //       BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
  //       BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
  //   }
  //   return this.data.isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
  //     BrightnessOptionUtils.keyguardTimeLightOption;
  // }

  private getBrightnessOption(): BackgroundBrightnessOptions | undefined {
    if (!this.enableBright || this.data.color === COLOR_BLACK) {
      return undefined;
    }

    if (this.data.color !== DEFAULT_FOREGROUND_COLOR) {
      return this.data.isLightWallpaper ?
      BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
      BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
    }
    return this.data.isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
    BrightnessOptionUtils.keyguardTimeLightOption;
  }

  // private getBgBrightnessOption(): BrightnessOptions | undefined {
  //   if (!this.enableBright) {
  //     return undefined;
  //   }
  //   return this.data.isLightWallpaper ? BrightnessOptionUtils.keyguardCardBackgroundDarkOption :
  //     BrightnessOptionUtils.keyguardCardBackgroundLightOption;
  // }

  private getBgBrightnessOption(): BackgroundBrightnessOptions  | undefined {
    if (!this.enableBright) {
      return undefined;
    }
    return this.data.isLightWallpaper ? BrightnessOptionUtils.keyguardCardBackgroundDarkOption :
    BrightnessOptionUtils.keyguardCardBackgroundLightOption;
  }


  private getBackgroundColor(): ResourceColor | undefined {
    if (this.enableSolid) {
      return this.panelBrightArgs?.getSolidColor();
    }
    if (!this.enableBright) {
      return this.panelBrightArgs?.getBrightnessColor(this.data.isLightWallpaper);
    }
    return this.data.color;
  }

  private getBgColor(): ResourceColor | undefined {
    if (this.enableSolid) {
      if (this.data.color !== DEFAULT_FOREGROUND_COLOR) {
        return BrightnessOptionUtils.changeRgb(this.data.color?.toString());
      }
      return this.foregroundBrightArgs?.getSolidColor();
    }
    if (!this.enableBright) {
      if (this.data.color !== DEFAULT_FOREGROUND_COLOR) {
        return BrightnessOptionUtils.changeRgb(this.data.color?.toString());
      }
      return this.foregroundBrightArgs?.getBrightnessColor(this.data.isLightWallpaper);
    }
    return this.data.color;
  }

  private getEffect(): BackgroundEffectOptions | undefined {
    if (!this.enableEffect) {
      return undefined;
    }
    if (!this.enableBright) {
      return {
        policy: 1,
        radius: 25,
        color: this.data.color !== DEFAULT_FOREGROUND_COLOR ?
        BrightnessOptionUtils.changeRgb(this.data.color?.toString()) :
        this.foregroundBrightArgs?.getBrightnessColor(this.data.isLightWallpaper)
      }
    }
    return {
      policy: 1,
      radius: 25
    }
  }

  build() {
    if (this.data.isAnimationViewShow) {
      EffectComponent() {
        Stack() {
          Stack() {
            Column() {
            }
            .backgroundEffect(this.getEffect())
            .width('100%')
            .height('100%')

            Column() {
            }
            .backgroundColor(this.getBackgroundColor())
            // .backgroundBrightnessInternal(this.getBgBrightnessOption())
            .backgroundBrightness(this.getBgBrightnessOption())
            .width('100%')
            .height('100%')
          }
          .clip(true)
          .markAnchor({
            x: RTLUtil.isRTL() ? '-50%' : '50%',
            y: '50%'
          })
          .position({
            start: LengthMetrics.vp(Number(this.data.position?.x)),
            top: LengthMetrics.vp(Number(this.data.position?.y))
          })
          .draggable(false)
          .scale({
            x: this.data.scaleX,
            y: this.data.scaleY
          })
          .width(this.data.width)
          .height(this.data.height)
          .borderRadius(this.data.radius)

          Stack() {
            Image(this.data.snapshot)
              .markAnchor({
                x: RTLUtil.isRTL() ? '-50%' : '50%',
                y: '50%'
              })
              .width(
                this.data.gridWidth * this.data.dimensionX - DEFAULT_FIX_VALUE)
              .height(
                (this.data.gridWidth - DEFAULT_FIX_VALUE))
              .scale({
                x: this.data.scaleX,
                y:  this.data.scaleY,
              })
              .objectFit(ImageFit.None)
              .position({
                start: LengthMetrics.vp(Number(this.data.position?.x)),
                top: LengthMetrics.vp(Number(this.data.position?.y))
              })
              .draggable(false)
              .borderRadius(this.data.gridWidth / 2 - 12)

            Column() {
            }
            .hitTestBehavior(HitTestMode.Transparent)
            .useEffect(this.enableEffect)
            .width('100%')
            .height('100%')
            .blendMode(BLENDMODE_DESTINATION_IN)

            Column() {
            }
            .hitTestBehavior(HitTestMode.Transparent)
            .width('100%')
            .height('100%')
            // .blendMode(!this.enableBright || this.enableSolid || this.data.color === COLOR_BLACK ?
            //   BLENDMODE_DESTINATION_IN : BlendMode.NORMAL)
            .blendMode(!this.enableBright || this.enableSolid || this.data.color === COLOR_BLACK ?
              BLENDMODE_DESTINATION_IN : BlendMode.SRC_OVER)
            .backgroundColor(this.getBgColor())
            // .backgroundBrightnessInternal(this.getBrightnessOption())
            .backgroundBrightness(this.getBrightnessOption())


            if (this.data.color !== DEFAULT_FOREGROUND_COLOR && this.enableBright && this.data.color !== COLOR_BLACK) {
              Column() {
              }
              .hitTestBehavior(HitTestMode.Transparent)
              .width('100%')
              .height('100%')
              .backgroundColor(this.data.color)
              // .backgroundBrightnessInternal(BrightnessOptionUtils.keyguardSecondBrightnessOption)
              .backgroundBrightness(BrightnessOptionUtils.keyguardSecondBrightnessOption)
              .accessibilityLevel('no')
            }
          }
          .blendMode(1000)
        }
        .hitTestBehavior(HitTestMode.Transparent)
        .height('100%')
        .width('100%')
      }
      .backgroundEffect(this.getEffect(), { disableSystemAdaptation: true })
      .hitTestBehavior(HitTestMode.Transparent)
      .width('100%')
      .height('100%')
    }
  }
}