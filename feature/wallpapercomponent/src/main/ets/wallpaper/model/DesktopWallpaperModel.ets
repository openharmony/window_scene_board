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
import { LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import {
  WallpaperManager,
  WallpaperType
} from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { DesktopWallpaperState } from '../viewmodel/DesktopWallpaperState';

const TAG = 'DesktopWallpaperModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面壁纸UI状态管理类
 */
class DesktopWallpaperModel {
  private wallpaperStateMap: Map<number, DesktopWallpaperState> = new Map<number, DesktopWallpaperState>();

  /**
   * 由桌面显示壁纸
   */
  private async showDefWallpaper(screenId: number): Promise<void> {
    log.showInfo(`screenId: ${screenId} showDefWallpaper`);
    WallpaperManager.getInstance().getWallpaperCache(WallpaperType.DESKTOP, TAG).then((wallpaper: image.PixelMap) => {
      let wallpaperState = this.getDtWallpaperState(screenId);
      wallpaperState.setDefaultsWallpaperImg(wallpaper);
      wallpaperState.setDefaultsWallpaperPath(WallpaperManager.getInstance().themePath);
      wallpaperState.setShowDefaultsWallpaper(true);
    });
  }

  /**
   * 由主题引擎显示壁纸
   */
  private showThemeWallpaper(screenId: number = SCBSceneSessionManager.getInstance().mainScreenId): void {
    log.showInfo(`screenId: ${screenId} showThemeWallpaper`);
    let wallpaperState = this.getDtWallpaperState(screenId);
    wallpaperState.setShowDefaultsWallpaper(false);
  }

  private applyWallpaper(wallpaperState: DesktopWallpaperState, wallpaper: image.PixelMap): void {
    if (wallpaperState.isShowDefaultsWallpaper()) {
      wallpaperState.setDefaultsWallpaperImg(wallpaper);
    }
  }

  private setWallpaperPath(wallpaperState: DesktopWallpaperState, wallpaperPath: string): void {
    if (wallpaperState.isShowDefaultsWallpaper()) {
      wallpaperState.setDefaultsWallpaperPath(wallpaperPath);
    }
  }

  /**
   * 当由桌面显示壁纸时，设置桌面上显示的壁纸
   *
   * @param wallpaper 桌面上显示的壁纸
   */
  public setDefaultsWallpaper(wallpaper: image.PixelMap, screenId?: number): void {
    if (screenId === undefined) {
      this.wallpaperStateMap.forEach((wallpaperState: DesktopWallpaperState) => {
        this.applyWallpaper(wallpaperState, wallpaper);
      });
    } else {
      let wallpaperState = this.getDtWallpaperState(screenId);
      this.applyWallpaper(wallpaperState, wallpaper);
    }
  }

  /**
   * 设置壁纸路径，用于DMA
   *
   * @param wallpaperPath 壁纸路径
   */
  public setDefaultsWallpaperPath(wallpaperPath: string): void {
    this.wallpaperStateMap.forEach((wallpaperState: DesktopWallpaperState) => {
      this.setWallpaperPath(wallpaperState, wallpaperPath);
    });
  }

  /**
   * 获取当前桌面壁纸控件的UI状态
   *
   * @returns 当前桌面壁纸控件的UI状态
   */
  public getDtWallpaperState(screenId: number = SCBSceneSessionManager.getInstance()
    .mainScreenId): DesktopWallpaperState {
    let wallpaperState = this.wallpaperStateMap.get(screenId);
    if (wallpaperState === undefined) {
      wallpaperState = new DesktopWallpaperState();
      this.wallpaperStateMap.set(screenId, wallpaperState);
    }
    wallpaperState.setShowDefaultsWallpaper(screenId !== SCBSceneSessionManager.getInstance().mainScreenId);
    return wallpaperState;
  }

  /**
   * 移除当前桌面壁纸控件的UI状态
   *
   * @returns 当前桌面壁纸控件的UI状态
   */
  public removeDtWallpaperState(screenId: number): void {
    this.wallpaperStateMap.delete(screenId);
  }

  /**
   * 切换桌面壁纸控件的状态，当前仅供壁纸服务和桌面壁纸控件初始化调用，后续优化为事件监听
   *
   * @param isUseEngineWallpaper true:由主题引擎显示壁纸, false:由桌面来显示壁纸
   */
  public setDesktopWallpaperMode(isUseEngineWallpaper: boolean,
    screenId: number = SCBSceneSessionManager.getInstance().mainScreenId): void {
    if (isUseEngineWallpaper) {
      this.showThemeWallpaper();
    } else {
      this.showDefWallpaper(screenId);
    }
    if (screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      AppStorage.setOrCreate('desktopWallpaperSupportScreenToEnd', isUseEngineWallpaper);
    }
  }
}

// 单例
export let dtWallpaperStateMgr: DesktopWallpaperModel = SingletonHelper.getInstance(DesktopWallpaperModel, TAG);