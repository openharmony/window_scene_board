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

import image from '@ohos.multimedia.image';
import { LogDomain,
  LogHelper,
  AppStorageUtil,
  DataProperty,
  DomainName,
  TraceUtil
} from '@ohos/basicutils';
import { slWallpaperMgr } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { SLWallpaperType } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperState';
import effectKit from '@ohos.effectKit';
import {
  WallpaperType,
  WallpaperChangeListener,
  WallpaperManager,
  DeviceHelper,
  ThemeActivationEvent
} from '@ohos/frameworkwrapper';
import { WallpaperConstants } from '@ohos/commonconstants';
// import { MemoryUtils } from '@ohos/windowscene';

import display from '@ohos.display';
import { dtWallpaperStateMgr } from './DesktopWallpaperModel';

const TAG = 'WallpaperModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class WallpaperModel {
  private contentColorListeners: Map<string, ContentColorListener> = new Map();

  private mWallPaperChangeListener: WallpaperChangeListener = {
    registeredTag: TAG,
    listenerType: WallpaperType.ALL,
    onWallPaperChange: (event: ThemeActivationEvent) => {
      log.showInfo('WallPaper Change');
      if (DeviceHelper.isPC()) {
        this.setWallpaper(WallpaperType.SCEENLOCK);
        this.setWallpaper(WallpaperType.DESKTOP);
      }

      // 当前折叠屏上未适配壁纸服务，壁纸切换依赖广播监听然后替换桌面显示，当折叠屏适配后此代码删除
      let isFoldable: boolean = false;
      try {
        isFoldable = display.isFoldable();
      } catch (err) {
        log.error(TAG, `Failed to retrieve foldable status, ${err.code} - ${err.message}`);
      }
      if (DeviceHelper.isPhone() && isFoldable) {
        this.setWallpaper(WallpaperType.DESKTOP);
      }
    }
  };

  static getInstance(): WallpaperModel {
    if (globalThis.WallpaperModel == null) {
      log.showInfo('getInstance');
      globalThis.WallpaperModel = new WallpaperModel();
    }
    return globalThis.WallpaperModel;
  }

  /**
   * 注册壁纸改变监听
   */
  public registerWallpaperChange(): void {
    TraceUtil.startTrace(DomainName.SCB, 'WallpaperModel.registerWallpaperChange');
    WallpaperManager.getInstance().addWallpaperChangeListener(this.mWallPaperChangeListener);
    TraceUtil.endTrace(DomainName.SCB, 'WallpaperModel.registerWallpaperChange');
  }

  /**
   * 注销壁纸改变监听
   */
  public unRegisterWallpaperChange(): void {
    WallpaperManager.getInstance().removeWallpaperChangeListener(this.mWallPaperChangeListener);
  }

  /**
   * 设置壁纸
   *
   * @param wallpaperType 设置的壁纸类型
   */
  public async setWallpaper(wallpaperType: WallpaperType): Promise<void> {
    log.showInfo('setWallpaper:' + wallpaperType);
    try {
      let wallpaper = await WallpaperManager.getInstance().getWallpaperCache(wallpaperType, TAG);
      if (wallpaper === undefined) {
        return;
      }
      if (wallpaperType === WallpaperType.DESKTOP) {
        dtWallpaperStateMgr.setDefaultsWallpaper(wallpaper);
        this.handleContentColorChange(wallpaper);
        if (DeviceHelper.isPC()) {
          AppStorageUtil.setOrCreate('desktopWallpaperChange', wallpaper, new DataProperty(true, false, 'PixelMap'));
          dtWallpaperStateMgr.setDefaultsWallpaperPath(WallpaperManager.getInstance().themePath);
        }
      } else {
        if (!DeviceHelper.isPC()) {
          // 锁屏壁纸
          slWallpaperMgr.setSlWallpaperImg(SLWallpaperType.TYPE_ENGINE_THEME, wallpaper);
        }
        this.handleScreenLockWallpaperChange(wallpaper);
      }
    } catch (e) {
      log.showError(`Can not read wallpaper path, error: ${JSON.stringify(e)}}`);
    }
    return;
  }

  async handleContentColorChange(image: image.PixelMap): Promise<void> {
    if (!image) {
      log.showError('handleContentColorChange image invalid');
      return;
    }
    this.contentColorListeners.forEach((listener, key) => {
      if (!listener) {
        log.showError('handleContentColorChange listener error');
        return;
      }
      this.calculateWallpaperDegreeWithRegion(image, listener.getRegion())
        .then((isBrightOrDark: boolean) => {
          listener.onContentColorChange(isBrightOrDark ? '#FFFFFF' : '#000000');
      }).catch((err: Error) => {
        log.showError(`handleContentColorChange error ${err?.message}`);
      });
    });
  }

  private async handleScreenLockWallpaperChange(wallPaper: image.PixelMap): Promise<void> {
    if (wallPaper === undefined || wallPaper === null) {
      return;
    }
    log.showInfo('start createColorPicker.');
    let colorPicker = await effectKit.createColorPicker(wallPaper);
    log.showInfo('handleScreenLockWallpaperChange font color');
    let degree = colorPicker.discriminatePitureLightDegree();
    // MemoryUtils.removeNapiWrap(colorPicker, false);
    log.showInfo('wallpaper type is ' + degree);
    let isBrightOrDark = degree === WallpaperConstants.WALLPAPER_TYPE_ONE ||
      degree === WallpaperConstants.WALLPAPER_TYPE_TWO;
    AppStorageUtil.setOrCreate('isScreenLockWallpaperBrightOrDark', isBrightOrDark, new DataProperty(true, false));
    AppStorageUtil.setOrCreate<number>('mWallpaperType', degree, new DataProperty(true, false));
  }

  private async calculateWallpaperDegreeWithRegion(image: image.PixelMap, region: Array<number>): Promise<boolean> {
    if (!image) {
      log.showError('theme desktop wallpapar not exist.');
      return false;
    }
    log.showInfo('start createColorPicker.');
    // 获取壁纸分类
    let colorPicker = await effectKit.createColorPicker(image, region);
    let color = colorPicker.getReverseColor();
    log.showInfo('handleWallpaperChange font color');
    let degree = colorPicker.discriminatePitureLightDegree();
    // MemoryUtils.removeNapiWrap(colorPicker, false);
    return degree !== WallpaperConstants.WALLPAPER_TYPE_ONE && degree !== WallpaperConstants.WALLPAPER_TYPE_TWO;
  }

  registerContentColorListener(key: string, listener: ContentColorListener): void {
    if (listener === undefined || listener === null) {
      log.showError(TAG, 'registerContentColorListener error');
      return;
    }
    this.contentColorListeners.set(key, listener);
  }

  unRegisterContentColorListener(key: string): void {
    if (this.contentColorListeners.get(key)) {
      this.contentColorListeners.delete(key);
    }
  }
}

export interface ContentColorListener {
  onContentColorChange(newContentColor: string): void;
  getRegion(): Array<number>;
}