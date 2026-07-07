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

import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { fileUri } from '@kit.CoreFileKit';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';

const TAG = 'DesktopWallpaperState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面壁纸UI状态
 */
@Observed
export class DesktopWallpaperState {
  /*
   * 是否由桌面加载显示默认壁纸
   */
  private mIsShowDefaultsWallpaper: boolean = false;

  /*
   * 默认壁纸图片
   */
  private mDefaultsWallpaperImg?: image.PixelMap;

  /*
   * 默认壁纸图片路径
   */
  private mDefaultsWallpaperPath: string = '';

  /**
   * 获取由桌面显示的默认壁纸
   *
   * @returns 桌面显示的默认壁纸
   */
  public getDefaultsWallpaperImg(): image.PixelMap | string | undefined {
    if (!DeviceHelper.isPC()) {
      return this.mDefaultsWallpaperImg;
    }
    if (this.mDefaultsWallpaperPath === '') {
      log.showError(`default wallpaper path is null`);
      return this.mDefaultsWallpaperImg;
    }
    let wallpaperPath: string | undefined = undefined;
    try {
      wallpaperPath = fileUri.getUriFromPath(this.mDefaultsWallpaperPath);
    } catch (error) {
      wallpaperPath = undefined;
      log.showError(`get wallpaperPath error ${error.code} ${error.message}`);
    }
    return wallpaperPath ?? this.mDefaultsWallpaperImg;
  }

  /**
   * 获取默认壁纸路径
   * */
  public async getDefaultWallpaperPath(context: common.UIAbilityContext, isLock: boolean):  Promise<PixelMap | null> {
    try {
      const lockStr = isLock ? 'lock' : 'unlock'
      const savePath = `data/storage/el2/base/haps/themecomponent/files/wallpaper_${lockStr}_image.webp`;
      const file = fs.openSync(savePath, fs.OpenMode.READ_ONLY)
      const stat = fs.statSync(savePath)
      const fileSize = stat.size
      const buffer = new ArrayBuffer(fileSize)
      fs.readSync(file.fd, buffer)
      fs.close(file)
      const imageSource = image.createImageSource(buffer)
      // 2. 创建PixelMap
      const pixelMap = await imageSource.createPixelMap();
      return pixelMap
    } catch (error) {
      const err = error as BusinessError;
      return null;
    }
  }

  /**
   * 设置桌面显示的默认壁纸
   *
   * @param wallpaper 桌面显示的默认壁纸
   */
  public setDefaultsWallpaperImg(wallpaper: image.PixelMap): void {
    this.mDefaultsWallpaperImg = wallpaper;
  }

  /**
   * 设置桌面显示的默认壁纸路径
   *
   * @param wallpaperPath 桌面显示的默认壁纸路径
   */
  public setDefaultsWallpaperPath(wallpaperPath: string): void {
    this.mDefaultsWallpaperPath = wallpaperPath;
  }

  /**
   * 是否由桌面加载显示默认壁纸
   *
   * @returns true：由桌面加载显示默认壁纸，false：由主题引擎显示壁纸
   */
  public isShowDefaultsWallpaper(): boolean {
    return this.mIsShowDefaultsWallpaper;
  }

  /**
   * 设置是否由桌面加载显示默认壁纸
   *
   * @param isShow true：由桌面加载显示默认壁纸，false：由主题引擎显示壁纸
   */
  public setShowDefaultsWallpaper(isShow: boolean): void {
    this.mIsShowDefaultsWallpaper = isShow;
  }

  /**
   * 释放state中的图片资源
   */
  public releaseImg(): void {
    if (this.mDefaultsWallpaperImg) {
      log.showInfo('release stateImg');
      this.mDefaultsWallpaperImg.release().catch((error: Error) => {
        log.error('release stateImg error, error:', error);
      });
    }
  }
}
