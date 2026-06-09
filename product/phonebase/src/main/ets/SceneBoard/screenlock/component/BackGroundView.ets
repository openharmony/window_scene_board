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
import { DeviceHelper, WallpaperData, WallpaperManager } from '@ohos/frameworkwrapper';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  slWallpaperMgr,
  SLWallpaperState,
  SlVisualConfigManager,
  CcmOption
} from '@ohos/screenlockcommon';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SpecialModeManager } from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import { SpecialModeViewData } from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { SlGreetSBindState } from '@ohos/screenlockcomponent/src/main/ets/greet/model/data/SlGreetSBindState';
import { defaultManifestParam, LockManifest } from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import ScreenLockWallPaper from '@ohos/screenlockcomponent/src/main/ets/wallpaper/ScreenLockWallpaper';
import { OneMirrorService } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { SlBindState } from '../model/data/SlBindState';
import { slStateHelper } from '../model/helper/SlStateHelper';

const TAG = 'BackGroundView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const IS_PAD: boolean = DeviceHelper.isPadOr2in1PcType();

/**
 * 密码页根组件
 */
@Component
export struct BackGroundView {
  private readonly isEnableBouncerOneFrameCut: boolean =
    SlVisualConfigManager.getInstance().getEnable(CcmOption.SLIDE2BOUNCER);

  @Consume isWallPaperEffectFreeze: boolean;
  @Consume wallPaperEffectOpacity: number;
  @State lockManifestParam: LockManifest = defaultManifestParam;
  @State slBindState: SlBindState = slStateHelper.getSlBindState();
  @State specialModeViewData: SpecialModeViewData = SpecialModeManager.getInstance().getSpecialModeViewData();
  @State wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @StorageLink('blurRadius') wallpaperBlurRadius: number = 0; // 锁屏背景模糊效果
  // 锁屏问候
  @State slGreetAnimState: WidgetAnimState | undefined =
    slStateHelper.getSlLockGreetStaticState().getSlLockGreetAnimCtrl();
  @State slGreetSBindState: SlGreetSBindState | undefined = slStateHelper.getSlLockGreetBindState();


  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  private getScreenLockWallpaperScale(): ScaleOptions {
    return { x: 1, y: 1 };
  }

  private getScreenLockWallpaperBorderRadius(): Resource | number {
    return this.getScreenLockWallpaperScale() < 1 ? $r('app.float.wallpaper_outline_radius') : 0;
  }

  private getScreenLockWallpaperNeedClip(): boolean {
    return this.getScreenLockWallpaperScale() < 1;
  }

  private getSlWallpaperTranslate(): TranslateOptions {
    return { y: this.slBindState.getWallpaperTranslate() };
  }

  private getBackGroundBlurRadius(): number {
    return this.slGreetSBindState?.getIsShow() && this.getGreetBlurRadius() > 0 ? this.getGreetBlurRadius() :
    this.wallpaperBlurRadius;
  }

  private getGreetBlurRadius(): number {
    if (this.slGreetAnimState?.isSceneAnimating()) {
      return this.slGreetAnimState.getBlur() ?? 0;
    }
    return this.slGreetSBindState?.getBgGreetBlurRadius() ?? 0;
  }

  private isWallPaperImageVisible(): boolean {
    if (DeviceHelper.isPcNot2in1Device()) {
      let engineThemeStatic: boolean | undefined = AppStorage.get<boolean>('engineThemeStatic');
      if (engineThemeStatic === undefined) {
        return false;
      }
      return engineThemeStatic;
    }
    if (this.slBindState?.getSlState(
      SlBindStateType.IS_SMALL_OUT_SCREEN) as boolean) {
      return false;
    }

    if (!this.lockManifestParam?.clockVisible &&
      !this.slBindState?.getSlState(SlBindStateType.IMMERSIVE_SHOWING_STATE)) {
      return false;
    }
    if (this.slWallpaperState?.isVisible) {
      return true;
    }
    return false;
  }

  @Styles
  wallpaperBlur() {
    .backgroundEffect({
      policy: 1,
      radius: 45 * this.getBackGroundBlurRadius(),
      saturation: (1 + 0.2 * this.getBackGroundBlurRadius()),
      brightness: 1,
      blurOptions: { grayscale: [38 * this.getBackGroundBlurRadius(), 38 * this.getBackGroundBlurRadius()] },
    }, { disableSystemAdaptation: true })
  }

  build() {
    if (this.slBindState?.isPanelShowing()) {
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.isWallPaperImageVisible()) {
          Stack() { // 锁屏壁纸
            ScreenLockWallPaper({
              lockManifestParam: this.lockManifestParam
            })
              .scale(this.getScreenLockWallpaperScale())
              .borderRadius(this.getScreenLockWallpaperBorderRadius())
              .clip(true)
          }
          .width(StyleConstants.PERCENTAGE_100)
          .height(StyleConstants.PERCENTAGE_100)
          .translate(this.getSlWallpaperTranslate())
          .clip(this.getScreenLockWallpaperNeedClip())
          .id(`${TAG}_Column_BG_Outer`)
        }

        if (this.isEnableBouncerOneFrameCut ? this.wallpaperBlurRadius >= 1 : this.wallpaperBlurRadius > 0 ||
          this.slGreetSBindState?.getIsShow()) {
          Column()
            .width('100%')
            .height('100%')
            .opacity(this.wallPaperEffectOpacity)
            .wallpaperBlur()
            .freeze(this.isWallPaperEffectFreeze)
        }
      }
      .width('100%')
      .height('100%')
      .id(TAG)
    }
  }
}