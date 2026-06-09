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

import { LogDomain, Logger, PixelMapUtil } from '@ohos/basicutils';
import wallpaper from '@ohos.wallpaper';
import { image } from '@kit.ImageKit';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'SCBKGBackWallpaper';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

@Component
export struct SCBKGBackWallpaper {
  @State _wallpaperBlurImage: PixelMap | undefined = undefined;

  aboutToAppear(): void {
    try {
      wallpaper.on('wallpaperChange', this.loadBlurWallpaper);
    } catch (err) {
      log.showError(TAG, 'wallpaperOn error');
    }
    log.showInfo(TAG, 'SCBKGBackWallpaper load');
    this.loadBlurWallpaper();
  }

  aboutToDisappear(): void {
    try {
      wallpaper.off('wallpaperChange', this.loadBlurWallpaper);
    } catch (err) {
      log.showError(TAG, 'wallpaperOff error');
    }
    log.showInfo(TAG, 'SCBKGBackWallpaper release');
    this._wallpaperBlurImage?.release();
    this._wallpaperBlurImage = undefined;
  }

  private loadBlurWallpaper = async () => {
    log.showInfo(TAG, `SCBKGBackWallpaper get wallpaper and blur`);
    let island: boolean = DeviceHelper.isLandscape();
    try {
      await wallpaper.getWallpaperByState(wallpaper.WallpaperType.WALLPAPER_LOCKSCREEN,
        wallpaper.FoldState.UNFOLD_ONCE_STATE,
        island ? wallpaper.RotateState.LANDSCAPE : wallpaper.RotateState.PORTRAIT).then((image: image.PixelMap) => {
          if (!image) {
            log.showError(TAG, 'loadBlurWallpaper null');
            return;
          }
          PixelMapUtil.addName(image, 'SCBKGBackWallpaper');
          this._wallpaperBlurImage?.release();
          this._wallpaperBlurImage = image;
      }).catch(() => {
        log.showError(TAG, 'loadBlurWallpaper getWallpaperByState error');
      });
    } catch (err) {
      log.showError(TAG, `loadBlurWallpaper err`);
    }
  }

  build() {
    Stack() {
      Image(this._wallpaperBlurImage)
        .renderGroup(true)
        .height('100%')
        .width('100%')

      Column()
        .backgroundColor('#99000000')
        .height('100%')
        .width('100%')
    }
    .id(TAG)
    .width('100%')
    .height('100%')
  }
}