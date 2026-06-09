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

import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import { slStateHelper } from '../../common/helper/SlStateHelper';
import { MirrorAnimState, MirrorsScene } from '../constants/MirrorToEndConst';
import IComponentMirrorCtrl from './IComponentMirrorCtrl';
import { WBaseProperty, slClockOneShotToDesktopService, CcmOption, SlAreaType, SlPositionType,
  SlVisualControl } from '@ohos/screenlockcommon';
import { aodHardwareConfig } from '@ohos/screenlockcommon/Index';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { BatteryLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

const TAG = 'ClockMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DEFAULT_BACK_GROUND_COLOR: ResourceColor = '#FFFFFFFF';
const PART_AOD_BACK_GROUND_COLOR: ResourceColor = '#FFFFFFFF';

export class ClockMirrorCtrl implements IComponentMirrorCtrl {
  // 时钟组件动效状态管理
  private clockAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlClockAnimState();
  // 时钟组件UI状态管理
  private clockUiBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState();
  // 时钟组件静态状态管理
  private clockStaticCtrl: SlClockStaticState = slStateHelper.getSlClockStaticState();

  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CLOCK);
  private enableSolid: boolean = SlVisualControl.getInstance().getEnable(CcmOption.SOLID, SlAreaType.CLOCK);

  private getDefaultBackgroundColor(): ResourceColor {
    let defaultColor: ResourceColor | undefined;
    if (this.enableSolid) {
      defaultColor = SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CLOCK_WIDGET)?.getSolidColor();
    } else if (!this.enableBright) {
      defaultColor = SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CLOCK_WIDGET)?.getBrightnessColor(
        this.clockUiBindCtrl?.getLightWallpaperState());
    }
    return defaultColor ?? DEFAULT_BACK_GROUND_COLOR;
  }

  private aodBackgroundColor: ResourceColor = '#FFAFAFAF';
  private aodBrightBackgroundColor: ResourceColor = '#DEffffff';
  private aodAlpha: number = 1;

  setUiBindState(scene: string): void {
    log.showInfo(`setUiBindState=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      if (!this.clockUiBindCtrl?.getClockDesktopToAod()) {
        this.clockUiBindCtrl?.setLayoutOpacity(0.01);
        this.clockUiBindCtrl?.setLayoutScale(1.2);
      } else {
        log.showInfo('setUiBindState getClockDesktopToAod=true');
        this.clockUiBindCtrl?.setLayoutOpacity(1);
        this.clockUiBindCtrl?.setLayoutScale(1);
      }
      this.setBatteryVisibility(false);
      return;
    }

    this.clockUiBindCtrl?.setLayoutOpacity(1);
    if (scene === MirrorsScene.AOD_TO_SL || scene === MirrorsScene.SCREEN_OFF_TO_SL_END) {
      this.clockUiBindCtrl?.setBackgroundColor(
        this.clockStaticCtrl.getBackgroundColor() ?? this.getDefaultBackgroundColor());
      if (this.enableBright) {
        this.clockUiBindCtrl?.setBrightness(this.getClockBrightnessOptions());
      } else {
        this.clockUiBindCtrl?.setBrightness(undefined);
      }
      this.setBatteryVisibility(false);
    }

    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD) {
      let aodColor: ResourceColor = this.clockStaticCtrl.getAodClockColor() ?? this.aodBackgroundColor;
      if (aodHardwareConfig.isSupportBackgroundEffect() && !(this.clockStaticCtrl?.getChangeColorState()) &&
        this.enableBright) {
        if (aodHardwareConfig.isSupportNewEffect()) {
          this.clockUiBindCtrl?.setBrightness(BrightnessOptionUtils.aodTimeLightOptionForNewEffect);
        } else {
          this.clockUiBindCtrl?.setBrightness(BrightnessOptionUtils.aodTimeLightOption);
        }
        this.aodAlpha = 1;
      } else {
        this.clockUiBindCtrl?.setBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
      }
      this.clockUiBindCtrl?.setBackgroundColor(aodColor);
      log.showInfo(`ui update clock color: ${aodColor}, aplha: ${this.aodAlpha}`);
      this.clockUiBindCtrl?.setLayoutOpacity(this.aodAlpha);
      this.setBatteryVisibility(true);
    }
    // 黑屏到锁屏的第一帧
    if (this.isScreenOffToSLWithoutClockOneShot(scene)) {
      this.clockUiBindCtrl?.setLayoutScale(0.7);
      this.clockUiBindCtrl?.setLayoutOpacity(0);
      return;
    }
    this.clockUiBindCtrl?.setLayoutScale(1);
  }

  setPartUiBindState(scene: string): void {
    log.showInfo(`setPartUiBindState=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL ||
      scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      this.clockUiBindCtrl?.setLayoutScale(0);
      this.clockUiBindCtrl?.setLayoutOpacity(0);
      return;
    }
    this.clockUiBindCtrl?.setLayoutScale(1);
    this.clockUiBindCtrl?.setLayoutOpacity(1);
  }

  setAnimEmoji(scene: string): void {
    log.showInfo(`setAnimEmoji state=${scene}`)
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL ||
      scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      this.clockAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 0);
      return;
    }
    this.clockAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 1);
  }

  setAnimState(scene: string): void {
    log.showInfo(`setAnimState state=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      if (!this.clockUiBindCtrl?.getClockDesktopToAod()) {
        this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, 1.2);
        this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, 1.2);
        this.clockAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 0.01);
      } else {
        this.clockAnimCtrl?.setStateValue(WBaseProperty.BACKGROUND_COLOR, this.getStartBackgroundColor());
      }
      let aodColor: ResourceColor = this.clockStaticCtrl.getAodClockColor() ?? this.aodBackgroundColor;
      if (this.enableBright) {
        this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
      } else {
        this.aodBrightBackgroundColor;
        this.clockAnimCtrl?.setBgColor(aodColor);
        this.clockAnimCtrl?.setFgBrightness(undefined);
      }
      return;
    }
    if (scene === MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START) {
      if (this.clockUiBindCtrl?.getClockAodToDesktop()) {
        log.showInfo('setAnimState getClockAodToDesktop=true');
        this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
        if (!this.enableBright) {
          this.clockAnimCtrl?.setBgColor(this.getStartBackgroundColor() ?? this.getDefaultBackgroundColor());
        }
      }
      return;
    }

    // 黑屏到锁屏的第一帧
    if (this.isScreenOffToSLWithoutClockOneShot(scene)) {
      this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, 0.7);
      this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, 0.7);
      this.clockAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 0);
      return;
    }

    this.clockAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 1);
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD) {
      let aodColor: ResourceColor = this.clockStaticCtrl.getAodClockColor() ?? this.aodBackgroundColor;
      if (aodHardwareConfig.isSupportBackgroundEffect() && !(this.clockStaticCtrl?.getChangeColorState()) &&
        this.enableBright) {
        if (aodHardwareConfig.isSupportNewEffect()) {
          this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForNewEffect);
        } else {
          this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOption);
        }
        this.aodAlpha = 1;
      } else {
        this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
      }
      this.clockAnimCtrl?.setBgColor(aodColor);
      log.showInfo(`anim update clock color: ${aodColor}, aplha: ${this.aodAlpha}`);
      this.clockAnimCtrl?.setStateValue(WBaseProperty.ALPHA, this.aodAlpha);
      this.setBatteryVisibility(true);
    } else {
      if (scene === MirrorsScene.AOD_TO_DESKTOP) {
        // AOD到桌面场景重置时钟颜色
        this.clockAnimCtrl?.setBgColor(this.clockStaticCtrl.getBackgroundColor() ?? this.getDefaultBackgroundColor());
      }

      if (!this.enableBright) {
        this.clockAnimCtrl?.setBgColor(this.getStartBackgroundColor() ?? this.getDefaultBackgroundColor());
      }

      if (!this.clockUiBindCtrl?.getClockAodToDesktop()) {
        log.showInfo('setAnimState getClockAodToDesktop=false');
        this.clockAnimCtrl?.setBgColor(this.clockStaticCtrl.getBackgroundColor() ?? this.getDefaultBackgroundColor());
        if (this.enableBright) {
          this.clockAnimCtrl?.setFgBrightness(this.getClockBrightnessOptions());
        } else {
          this.clockAnimCtrl?.setFgBrightness(undefined);
        }
      }
      this.setBatteryVisibility(false);
    }
    if (scene === MirrorsScene.SCREEN_OFF_TO_SL_END) {
      this.clockUiBindCtrl?.setLayoutOpacity(1);
      this.clockUiBindCtrl?.setLayoutScale(1);
    }
    this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, 1);
    this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, 1);
  }

  setPartAodAnimState(scene: string): void {
    log.showInfo(`setPartAodAnimState state=${scene}`);
    const batteryLayout = BatteryLayout.DEFAULT_LAYOUT;
    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      this.clockAnimCtrl?.setStateValue(WBaseProperty.BACKGROUND_COLOR, this.getStartBackgroundColor());
      if (aodHardwareConfig.isSupportBackgroundEffect() && !(this.clockStaticCtrl?.getChangeColorState())) {
        this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOption);
      } else {
        if (this.enableBright) {
          this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
        } else {
          this.clockAnimCtrl?.setBgColor(PART_AOD_BACK_GROUND_COLOR);
          this.clockAnimCtrl?.setFgBrightness(undefined);
        }
      }
      return;
    }
    if (scene === MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START) {
      if (this.clockUiBindCtrl?.getClockAodToDesktop()) {
        this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
        if (!this.enableBright) {
          this.clockAnimCtrl?.setBgColor(this.getStartBackgroundColor() ?? this.getDefaultBackgroundColor());
        }
      }
      return;
    }

    // 黑屏到锁屏的第一帧
    if (this.isScreenOffToSLWithoutClockOneShot(scene)) {
      this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, 0.7);
      this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, 0.7);
      this.clockAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 0);
      return;
    }

    this.clockAnimCtrl?.setStateValue(WBaseProperty.ALPHA, 1);
    this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_X, 1);
    this.clockAnimCtrl?.setStateValue(WBaseProperty.SCALE_Y, 1);
    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD) {
      if (aodHardwareConfig.isSupportBackgroundEffect() && !(this.clockStaticCtrl?.getChangeColorState()) &&
      this.enableBright) {
        this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOption);
      } else {
        this.clockAnimCtrl?.setFgBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
      }
      this.clockAnimCtrl?.setBgColor(PART_AOD_BACK_GROUND_COLOR);
      log.showInfo(`anim update clock color: ${PART_AOD_BACK_GROUND_COLOR}, aplha: ${this.aodAlpha}`);
      this.setBatteryVisibility(true, batteryLayout);
    } else {
      if (scene === MirrorsScene.AOD_TO_DESKTOP) {
        // AOD到桌面场景重置时钟颜色
        this.clockAnimCtrl?.setBgColor(this.clockStaticCtrl.getBackgroundColor() ?? this.getDefaultBackgroundColor());
      }

      if (!this.enableBright) {
        this.clockAnimCtrl?.setBgColor(this.getStartBackgroundColor() ?? this.getDefaultBackgroundColor());
      }

      if (!this.clockUiBindCtrl?.getClockAodToDesktop()) {
        this.clockAnimCtrl?.setBgColor(this.clockStaticCtrl.getBackgroundColor() ?? this.getDefaultBackgroundColor());
        if (this.enableBright) {
          this.clockAnimCtrl?.setFgBrightness(this.getClockBrightnessOptions());
        } else {
          this.clockAnimCtrl?.setFgBrightness(undefined);
        }
      }
      this.setBatteryVisibility(false, batteryLayout);
    }
  }

  setPartAodUiBindState(scene: string): void {
    log.showInfo(`setPartAodAnimState state=${scene}`);
    const batteryLayout = BatteryLayout.DEFAULT_LAYOUT;
    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      this.setBatteryVisibility(false, batteryLayout);
      return;
    }

    this.clockUiBindCtrl?.setLayoutOpacity(1);
    if (scene === MirrorsScene.AOD_TO_SL || scene === MirrorsScene.SCREEN_OFF_TO_SL_END) {
      this.clockUiBindCtrl?.setBackgroundColor(
        this.clockStaticCtrl.getBackgroundColor() ?? this.getDefaultBackgroundColor());
      if (this.enableBright) {
        this.clockUiBindCtrl?.setBrightness(this.getClockBrightnessOptions());
      } else {
        this.clockUiBindCtrl?.setBrightness(undefined);
      }
      this.setBatteryVisibility(false, batteryLayout);
    }

    if (scene === MirrorsScene.DESKTOP_TO_AOD || scene === MirrorsScene.SL_TO_AOD) {
      if (aodHardwareConfig.isSupportBackgroundEffect() && !(this.clockStaticCtrl?.getChangeColorState()) &&
      this.enableBright) {
        this.clockUiBindCtrl?.setBrightness(BrightnessOptionUtils.aodTimeLightOption);
      } else {
        this.clockUiBindCtrl?.setBrightness(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
      }
      this.clockUiBindCtrl?.setBackgroundColor(PART_AOD_BACK_GROUND_COLOR);
      this.setBatteryVisibility(true, batteryLayout);
    }
    // 黑屏到锁屏的第一帧
    if (this.isScreenOffToSLWithoutClockOneShot(scene)) {
      this.clockUiBindCtrl?.setLayoutScale(0.7);
      this.clockUiBindCtrl?.setLayoutOpacity(0);
      return;
    }
    this.clockUiBindCtrl?.setLayoutScale(1);
  }

  startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
    if (isStart) {
      this.clearAnimating();
    }
    if (scene !== MirrorsScene.DESKTOP_TO_AOD) {
      if (!this.clockUiBindCtrl?.getClockAodToDesktop()) {
        log.showInfo('startAnim getClockAodToDesktop=false');
        this.clockAnimCtrl?.setBgColor(this.clockUiBindCtrl?.getBackgroundColor());
      }
    }
    this.clockAnimCtrl?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: true });
  }

  isSceneAnimating(scene: string): boolean {
    return this.clockAnimCtrl?.isSceneAnimating(scene) ?? false;
  }

  clearAnimating(): void {
    let scenes = this.clockAnimCtrl?.getSceneValues();
    log.showInfo(`now clear all anim scenes, ${scenes}`)
    scenes?.split(',').forEach((scene) => {
      this.clockAnimCtrl?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: true });
    })
  }

  private getStartBackgroundColor(): string {
    return slClockOneShotToDesktopService.getTextColorOfDesktopClock();
  }

  private getClockBrightnessOptions():BrightnessOptions {
    let isLightWallpaper = this.clockUiBindCtrl?.getLightWallpaperState();
    let isChangeColor = this.clockStaticCtrl?.getChangeColorState();

    if (isChangeColor) {
      return isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
      BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
    }
    return isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
      BrightnessOptionUtils.keyguardTimeLightOption;
  }

  private isScreenOffToSLWithoutClockOneShot(scene: string): boolean {
    return scene === MirrorsScene.SCREEN_OFF_TO_SL && !this.clockUiBindCtrl?.isInDesktopAndAodClockOneShot();
  }

  private setBatteryVisibility(isShowing: boolean, layout: BatteryLayout = BatteryLayout.DEFAULT_LAYOUT): void {
    let showAodBatterySwitchState = this.clockStaticCtrl?.getBatterySwitchState(layout);
    if (!showAodBatterySwitchState) {
      log.showWarn('AOD battery switch is close');
    }

    this.clockUiBindCtrl?.setBatteryVisibility(
      isShowing && showAodBatterySwitchState ? Visibility.Visible : Visibility.None);
  }
}