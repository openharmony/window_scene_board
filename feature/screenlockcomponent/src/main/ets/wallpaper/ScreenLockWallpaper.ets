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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  slWallpaperMgr,
  SLWallpaperState,
} from '@ohos/screenlockcommon';
import { SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slStateHelper } from '../common/helper/SlStateHelper';
import { defaultManifestParam, LockManifest } from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import { WallpaperVc } from './WallpaperVc';

const TAG = 'Wallpaper'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const COMPONENT_ID_WALLPAPER = TAG + '_Image_wallpaper';

/**
 * 锁屏壁纸
 */
@Component
export default struct ScreenLockWallpaper {
  /**
   * 锁屏壁纸状态管理
   */
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  /**
   * 锁屏面板UI绑定状态
   */
  @State slBindState?: ISlState = slStateHelper.getSlBindState();

  @State lockManifestParam: LockManifest = defaultManifestParam;
  private wallpaperViewControl?: WallpaperVc;

  aboutToAppear() {
    log.showInfo(`aboutToAppear`);
    this.wallpaperViewControl = new WallpaperVc({
      slWallpaperState: this.slWallpaperState,
    });
    this.wallpaperViewControl.init();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisapper`);
    this.wallpaperViewControl?.release();
  }

  /**
   * Wallpaper build
   */
  public build(): void {
    Stack() {
      Image(this.slWallpaperState?.wallpaperImg)
        .draggable(false)
        .id(COMPONENT_ID_WALLPAPER)
        .syncLoad(true)
        .objectFit(ImageFit.Cover)
        .hoverEffect(HoverEffect.None)
        .interpolation(ImageInterpolation.Low)
        .blur(this.slWallpaperState?.wallpaperBlur, undefined, { disableSystemAdaptation: true })
        .width('100%')
        .height('100%')
        .visibility(this.isWallPaperImageVisible() ? Visibility.Visible : Visibility.Hidden)
        .scale(this.getWallpaperScale())
    }
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

  private getWallpaperScale(): ScaleOptions {
    return {
      x: 1,
      y: 1
    };
  }
}