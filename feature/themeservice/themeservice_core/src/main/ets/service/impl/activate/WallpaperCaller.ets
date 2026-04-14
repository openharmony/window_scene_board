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

import wallpaper from '@ohos.wallpaper';
import hilog from '@ohos.hilog';

const TAG: string = `WallpaperCaller`;
const TS_DOMAIN: number = 0x00ff;

export enum FoldState {
  NORMAL = 0,
  UNFOLD_ONCE_STATE = 1,
  UNFOLD_TWICE_STATE = 2,
}

export enum RotateState {
  PORTRAIT = 0,
  LANDSCAPE = 1,
}

export enum WallpaperType {
  WALLPAPER_SYSTEM = wallpaper.WallpaperType.WALLPAPER_SYSTEM,
  WALLPAPER_LOCKSCREEN = wallpaper.WallpaperType.WALLPAPER_LOCKSCREEN
}

export interface WallpaperInfo extends wallpaper.WallpaperInfo {
}

export class WallpaperCaller {

  public static async setAllWallpapers(wallpapers: Array<WallpaperInfo>, wallpaperType: WallpaperType): Promise<void> {
    try {
      let wallpaperInfos: wallpaper.WallpaperInfo[] = [];
      wallpapers.forEach((wall, index) => {
        let foldStateTmp: wallpaper.FoldState = wallpaper.FoldState.NORMAL;
        if (wall.foldState === FoldState.UNFOLD_ONCE_STATE) {
          foldStateTmp = wallpaper.FoldState.UNFOLD_ONCE_STATE;
        } else if (wall.foldState === FoldState.UNFOLD_TWICE_STATE) {
          foldStateTmp = wallpaper.FoldState.UNFOLD_TWICE_STATE;
        }
        let rotateStateTmp: wallpaper.RotateState = wallpaper.RotateState.PORTRAIT;
        if (wall.rotateState === RotateState.LANDSCAPE) {
          rotateStateTmp = wallpaper.RotateState.LANDSCAPE;
        }
        wallpaperInfos.push({ foldState: foldStateTmp, rotateState: rotateStateTmp, source: wall.source });
      });
      await wallpaper.setAllWallpapers(wallpaperInfos, wallpaperType);
    } catch (error) {
      hilog.info(TS_DOMAIN, TAG, `[ThemeService] error: ${error}`);
    }
    return;
  }
}